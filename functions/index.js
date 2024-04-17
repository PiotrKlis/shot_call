const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendAlarmNotification = functions.firestore
    .document("parties/nowsza")
    .onUpdate(async (change, context) => {
      const newValue = change.after.data();
      const previousValue = change.before.data();

      // Check if the alarm field has changed and is not empty
      if (newValue.alarm.length > previousValue.alarm.length) {
        // Retrieve the list of users subscribed to the "nowsza" topic

        const message = {
          notification: {
            title: "title",
            body: "body",
          },
          topic: "nowsza",
        };

        admin.messaging().send(message).then((response) => {
          // Response is a message ID string.
          console.log("Successfully sent message:", response);
        })
            .catch((error) => {
              console.log("Error sending message:", error);
            });
      }

      return null;
    });
