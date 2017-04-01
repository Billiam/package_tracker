self.addEventListener("push", function(event)  {
  var data = JSON.parse(event.data.text());
  var title = data.title;
  var options = {
    body: data.body,
    icon: '/images/favicon.png',
    badge: '/images/favicon.png',
    tag: 'updated-' + data.tracking_number,
    requireInteraction: true,
    data: {
      messageCount: 1,
      url: data.url || '/',
      trackingNumbers: [data.tracking_number]
    }
  };

  event.waitUntil(
    registration.getNotifications().then(function(notifications) {
      for(var i = 0, l = notifications.length; i < l; i++) {
        if (notifications[i].data && notifications[i].data.trackingNumbers) {
          return notifications[i];
        }
      }
      return false;
    }).then(function(currentNotification) {
      if (currentNotification) {
        var messageCount = currentNotification.data.messageCount + 1;
        if (currentNotification.data.trackingNumbers.indexOf(data.tracking_number) === -1) {
          var uniquePackages = currentNotification.data.trackingNumbers
            .concat(options.data.trackingNumbers)
            .filter(function(value, index, self) {
              return self.indexOf(value) === index;
            });

          options.data.trackingNumbers = uniquePackages;
          var packageCount = uniquePackages.length;

          if (messageCount > packageCount) {
            title = messageCount + ' updates to ' + packageCount + ' packages';
          } else {
            title = packageCount + ' packages updated';
          }

          delete options.body;
          options.silent = true;
          options.data.url = '/';
        }

        options.data.messageCount = messageCount;
        currentNotification.close();
      }

      return self.registration.showNotification(title, options);
    })
  );
});

self.addEventListener('notificationclick', function(event) {
  var eventData = event.notification.data;
  var urlToOpen = eventData.url;

  event.notification.close();

  event.waitUntil(
    clients.matchAll({
      type: 'window',
      includeUncontrolled: true
    }).then(function(windowClients) {
      var matchingClient = null;
      var i,l, windowClient, url;

      for (i = 0, l = windowClients.length; i < l; i++) {
        windowClient = windowClients[i];
        url = new URL(windowClient.url);
        if (url.href === urlToOpen || url.pathname === urlToOpen) {
          matchingClient = windowClient;
          break;
        }
      }

      if (matchingClient) {
        return matchingClient.focus().then(function() {
          return matchingClient.navigate(matchingClient.url)
        });
      } else {
        return clients.openWindow(urlToOpen);
      }
    })
  );
});
