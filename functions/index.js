const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document('kan-ihtiyacı/{documentId}') // Buradaki 'kan-ihtiyacı' koleksiyonunu kendi koleksiyonunuzla değiştirin
    .onCreate((snap, context) => {
        // Yeni bir belge oluşturulduğunda çalışacak kod buraya gelecek
        // Bildirim gönderme işlemleri burada gerçekleştirilecek
        // Örnek bildirim gönderme kodu:
        const newValue = snap.data();
        const message = {
            notification: {
                title: 'Yeni Kan İhtiyacı',
                body: 'Yeni bir kan ihtiyacı bildirimi!',
            },
            // Hedef cihazlara gönderilecek veri (isteğe bağlı)
            data: {
                // Örnek veri alanları
                // Örneğin: veritabanındaki belgenin ID'si
                documentId: context.params.documentId,
                // Diğer veri alanları buraya eklenebilir
            },
            // Bildirimi alacak hedef cihazlara hedef belirleme (isteğe bağlı)
            topic: 'kan_ihtiyaci', // Örnek bir konu adı
        };

        // FCM (Firebase Cloud Messaging) kullanarak bildirim gönderme
        return admin.messaging().send(message);
    });
