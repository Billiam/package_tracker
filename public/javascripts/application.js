(function() {
  const OPTIONS = ['notify_all', 'notify_delivered', 'notify_scheduled', 'notify_new'];

  var preferences = {
    init: function() {
      var elements = document.getElementsByClassName('push_label');
      if (elements.length == 0) {
        return;
      }
      preferences.bind(elements[0]);
    },

    submit: function() {
      var prefs = {};
      OPTIONS.forEach(function(option) {
        prefs[option] = document.getElementById(option).checked;
      });

      worker.setOptions(prefs);
    },

    loadSettings: function(settings) {
      var subscribed = OPTIONS.some(function(preference) { return settings.hasOwnProperty(preference) && settings[preference] === true });
      if ( ! subscribed) {
        return;
      }

      document.getElementsByClassName('push_label')[0].classList.add('active');
      OPTIONS.forEach(function(option) {
        document.getElementById(option).checked = settings[option] === true;
      });
    },

    bind: function(element) {
      element.addEventListener('click', function(e) {

        var preferenceBlock = document.getElementsByClassName('preferences')[0];
        preferenceBlock.style.display = preferenceBlock.style.display == 'none' ? 'block' : 'none';
      });

      var button = document.getElementsByTagName('button')[0];
      button.addEventListener('click', function(e) {
        preferences.submit();
      });
    }
  };


  var worker = {

    init: function() {
      if ( ! worker.supported()) {
        console.warn('Service worker is not supported');
        return;
      }

      worker.registerWorker().then(function() {
        return worker.fetchOptions()
      }).then(function(settings) {
        preferences.loadSettings(settings);
      }).catch(function(error) {
        console.log(error);
      })
    },

    fetchOptions: function() {
      return worker.getSubscription().then(function(subscription) {
        return fetch('/subscription?subscriber[url]=' + encodeURIComponent(subscription.endpoint)).then(function(response) {
          if (response.status == 200) {
            return response.json();
          } else {
            var error = new Error(response.statusText);
            error.response = response;
            throw error;
          }
        })
      })
    },

    supported: function() {
      return navigator.serviceWorker;
    },

    registerWorker: function() {
      return navigator.serviceWorker.register('/serviceworker.js')
    },

    subscribe: function() {
      return navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
        return serviceWorkerRegistration.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: window.vapidPublicKey
        })
      }).then(function() {
        return worker.getSubscription();
      })
    },

    getSubscription: function() {
      return navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
        return serviceWorkerRegistration.pushManager.getSubscription()
      })
    },

    storeOptions: function(subscription, options) {
      if ( ! subscription) {
        return;
      }

      return fetch('/subscription', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: JSON.stringify({
          "subscriber": subscription.toJSON(),
          "preferences": options
        })
      });
    },

    removeSubscription: function() {
      worker.getSubscription().then(function(subscription) {
        worker.storeOptions(subscription, {});
      }).catch(function(error) {
        console.error(error);
      });
    },

    saveSubscription: function(options) {
      worker.subscribe().then(function(subscription) {
        worker.storeOptions(subscription, options)
      }).catch(function(error) {
        console.warn(error);
      });
    },


    setOptions: function(options) {
      var anySubscription = OPTIONS.some(function(option) { return options[option] === true });
      if (anySubscription) {
        return worker.saveSubscription(options);
      } else {
        return worker.removeSubscription();
      }
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

    ensurePermission: function(callback) {
      if (notification.permissionGranted()) {
        callback();
      } else if ( ! notification.permissionDenied()) {
        Notification.requestPermission(function (permission) {
          if (permission === "granted") {
           callback();
          }
        });
      }
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
    preferences.init();
  };

  if (document.readyState !== 'loading') {
    init();
  } else {
    document.addEventListener('DOMContentLoaded', init);
  }
})();
