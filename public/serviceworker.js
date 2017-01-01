self.addEventListener("push", function(event)  {
  var data = JSON.parse(event.data.text());
  // tag should be the tracking number
  var tag = 'updated-' + data.tracking_number;
  var icon = '/images/favicon.png';

  event.waitUntil(
    self.registration.showNotification(data.title, {
      body: data.body,
      icon: icon,
      badge: icon,
      tag: tag,
      requireInteraction: true,
      data: {
        url: data.url || '/',
        trackingNumber: data.tracking_number
      }
    })
  )
});

self.addEventListener('notificationclick', function(event) {
  var eventData = event.notification.data;
  event.notification.close();
  event.waitUntil(
    clients.openWindow(eventData.url)
  );
});
