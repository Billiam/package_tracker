(function() {
  var worker = {
    supported: function() {
      return navigator.serviceWorker;
    },

    registerWorker: function() {
      navigator.serviceWorker.register('/serviceworker.js').then(function(reg) {
        console.log('Service worker change, registered the service worker');
      });
    },

    init: function() {
      if ( ! worker.supported()) {
        console.log('Service worker is not supported');
        return;
      }

      worker.registerWorker();

      navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
        return serviceWorkerRegistration.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: window.vapidPublicKey
        }).then(function() {
          return serviceWorkerRegistration.pushManager.getSubscription()
        })
      }).then(function(subscription) {
        // $.post("/push", { subscription: subscription.toJSON(), message: "You clicked a button!" });
        console.log(subscription);

        var request = new XMLHttpRequest();
        request.open('POST', '/subscription', true);
        request.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
        request.send(JSON.stringify({
          "subscriber": subscription.toJSON()
        }));
      });
    }
  };

  var notification = {
    init: function() {
      if ( ! notification.available()) {
        console.error('Browser does not support desktop notifications');
        return;
      }

      if (notification.permissionGranted()) {
        notification.startWorker();
        return;
      }

      if( ! notification.permissionDenied()) {
        notification.requestPermission();
      }
    },

    requestPermission: function() {
      Notification.requestPermission(function (permission) {
        if (permission === "granted") {
          console.log("Permission to receive notifications has been granted");
          //register worker
          notification.startWorker();
        }
      });
    },

    startWorker: function() {
      worker.init();
    },
    permissionDenied: function() {
      return Notification.permission === "denied"
    },
    permissionGranted: function() {
      return Notification.permission === "granted"
    },
    available: function() {
      return "Notification" in window
    }
  };

  var init = function() {
    notification.init();
  };

  if (document.readyState !== 'loading') {
    init();
  } else {
    document.addEventListener('DOMContentLoaded', init);
  }
})();
