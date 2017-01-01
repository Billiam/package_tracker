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
      trackingNumber: data.tracking_number
    }
  };

  event.waitUntil(
    registration.getNotifications().then(function(notifications) {
      for(var i = 0, l = notifications.length; i < l; i++) {
        if (notifications[i].data && notifications[i].data.trackingNumber) {
          return notifications[i];
        }
      }
      return false;
    }).then(function(currentNotification) {
      if (currentNotification) {
        var messageCount = currentNotification.data.messageCount + 1;
        title = messageCount + ' new tracking updates';
        delete options.body;
        options.silent = true;
        options.data.messageCount = messageCount;
        options.data.url = '/';
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
        return matchingClient.focus();
      } else {
        return clients.openWindow(urlToOpen);
      }
    })
  );
});
