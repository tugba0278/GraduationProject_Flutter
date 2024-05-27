/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

const logger = require("firebase-functions/logger");

const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationV2 = onDocumentCreated("kan-verme/{req}", async (event) => {
    /* ... */ 
    const snapshot = event.data;
    if (!snapshot) {
        console.log("No data associated with the event");
        return;
    }
    const data = snapshot.data();
    const message = {
        notification: {
            title: 'Yeni Kan İhtiyacı',
            body: 'Yeni bir kan ihtiyacı bildirimi!',
            channel_id: 'Kan Bağışı',
            priority: 'high'
        },
        // Hedef cihazlara gönderilecek veri (isteğe bağlı)
        // data: {
        //     // Örnek veri alanları
        //     // Örneğin: veritabanındaki belgenin ID'si
        //     documentId: context.params.documentId,
        //     // Diğer veri alanları buraya eklenebilir
        // },
        // Bildirimi alacak hedef cihazlara hedef belirleme (isteğe bağlı)
        topic: 'kan_verme', // Örnek bir konu adı
    };
    print("NEWVALUE: " + data)

    // FCM (Firebase Cloud Messaging) kullanarak bildirim gönderme
    admin.messaging().send(message);
    const tokensSnapshot = await firestore().collection('tokens').get();
    const tokens = tokensSnapshot.docs.map((doc) => doc.data().fcmToken);

    // Send notifications to all users
    await admin.messaging().sendToDevice(tokens, message);


 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
