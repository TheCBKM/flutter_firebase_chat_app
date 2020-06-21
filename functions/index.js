const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.onmsg = functions.firestore.document('chat/{message}').onCreate((snap, ctx) => {
    console.log(snap.data());
   return admin.messaging().sendToTopic('chat', {
        notification: {
            title: snap.data().username, body: snap.data().text,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
        }
    })

})
