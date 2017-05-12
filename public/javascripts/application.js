(function() {
  if (window.env && window.env !== 'development') {
    console.log = function() {}
  }

  const OPTIONS = ['notify_all', 'notify_delivered', 'notify_scheduled', 'notify_new'];

  var preferences = {
    init: function() {
      var elements = document.getElementsByClassName('notifications');
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

      worker.setOptions(prefs).then(function() {
        preferences.toggleVisible(false);
      });
    },

    activateNotifications: function() {
      document.getElementsByClassName('push-label')[0].classList.add('active');
    },

    deactivateNotifications: function() {
      document.getElementsByClassName('push-label')[0].classList.remove('active');
    },

    loadSettings: function(settings) {
      var subscribed = OPTIONS.some(function(preference) { return settings.hasOwnProperty(preference) && settings[preference] === true });
      if (subscribed) {
        preferences.activateNotifications();
        OPTIONS.forEach(function(option) {
          document.getElementById(option).checked = settings[option] === true;
        });
      }
      document.getElementsByClassName('notifications')[0].classList.remove('hidden');
    },

    toggleVisible: function(show) {
      document.getElementsByClassName('preferences')[0].classList.toggle('expanded', show);
    },

    bind: function(node) {
      var label = node.getElementsByClassName('push-label')[0];
      label.addEventListener('click', function(e) {
        preferences.toggleVisible();
      });

      var button = node.getElementsByTagName('button')[0];
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
      }).catch(function() {
        return {};
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
      }).then(function(subscription) {
        if ( ! subscription) {
          throw new Error('No subscription found');
        }
        return subscription;
      });
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
      return worker.getSubscription().then(function(subscription) {
        worker.storeOptions(subscription, {});
      }).catch(function(error) {
        console.error('Could not update subscription information', error);
      });
    },

    saveSubscription: function(options) {
      return worker.subscribe().then(function(subscription) {
        worker.storeOptions(subscription, options)
      }).catch(function(error) {
        console.warn(error);
      });
    },


    setOptions: function(options) {
      var anySubscription = OPTIONS.some(function(option) { return options[option] === true });
      if (anySubscription) {
        return worker.saveSubscription(options).then(function() {
          preferences.activateNotifications();
        });
      } else {
        return worker.removeSubscription().then(function() {
          preferences.deactivateNotifications();
        });
      }
    }
  };

  var notification = {
    init: function() {
      if ( ! notification.available()) {
        console.error('Browser does not support desktop notifications');
        return;
      }

      if ( ! notification.permissionDenied()) {
        notification.startWorker();
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

  var mailbox = {
    init: function() {
      var mailSections = document.getElementsByClassName('mailbox-toggler');
      if (mailSections.length === 0) {
        return;
      }
      mailbox.bind(mailSections[0]);
    },

    recalculateHeight: function(element) {
      element.style.maxHeight = element.scrollHeight + "px";
    },

    bind: function(element) {
      var timeout = 200;
      var throttled;
      var toggleable = document.getElementsByClassName('mailbox-toggle')[0];

      element.addEventListener('click', function() {
        var classes = toggleable.classList;
        var expanded = classes.toggle('expanded');
        classes.toggle('collapsed', !expanded);
      });

      window.addEventListener('resize', function() {
        if ( ! throttled) {
          throttled = setTimeout(function() {
            throttled = null;
          }, timeout);

          mailbox.recalculateHeight(toggleable);
        }
      });

      mailbox.recalculateHeight(toggleable);
    }
  };

  var init = function() {
    notification.init();
    preferences.init();
    mailbox.init();
  };

  if (document.readyState !== 'loading') {
    init();
  } else {
    document.addEventListener('DOMContentLoaded', init);
  }
})();
