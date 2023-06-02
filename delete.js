const admin = require("firebase-admin");
const serviceAccount = require("../scopr-b12c2-firebase-adminsdk-3bjy8-bedf8e4de4.json");
const databaseURL = "https://scopr-b12c2.firebaseio.com";
const storageBucket = "gs://scopr-b12c2.appspot.com";


admin.initializeApp({ credential: admin.credential.cert(serviceAccount), databaseURL: databaseURL, storageBucket: storageBucket});


const deleteAllUsers = (nextPageToken) => {
    let uids = []
    admin
        .auth()
        .listUsers(100, nextPageToken)
        .then((listUsersResult) => {
            uids = uids.concat(listUsersResult.users.map((userRecord) => userRecord.uid))
            console.log(uids)
            if (listUsersResult.pageToken) {
                deleteAllUsers(listUsersResult.pageToken);
            }
        })
        .catch((error) => {
            console.log('Error listing users:', error);
        }).finally(() => {
            admin.auth().deleteUsers(uids)
        })
};

// Delete all files in Firebase Storage
const deleteFiles = async () => {
    const bucket = admin.storage().bucket();
    const [files] = await bucket.getFiles();
    const deleteFilesPromises = files.map(async file => {
        await file.delete();
    });
    await Promise.all(deleteFilesPromises);
}


// Delete all documents in Firestore
// const deleteDocuments = async (collectionName) => {
//     const collectionRef = admin.firestore().collection(collectionName);
//     const query = collectionRef.get();
//     const documents = query.then(snapshot => {
//         let documents = [];
//         snapshot.forEach(doc => {
//             documents.push(doc);
//         });
//         return documents;
//     });
//     const documentsToDelete = await documents;
//     documentsToDelete.forEach(async document => {
//         await document.ref.delete();
//     });
// }
// Delete all documents in Firestore
// const deleteAllCollections = async () => {
//     const collectionRef = admin.firestore().collection();
//     const query = collectionRef.get();
//     const collections = query.then(snapshot => {
//         let collections = [];
//         snapshot.forEach(doc => {
//             collections.push(doc);
//         });
//         return collections;
//     });
//     const collectionsToDelete = await collections;
//     collectionsToDelete.forEach(async collection => {
//         await collection.ref.delete();
//     });
// }
// Reset Firestore
// const resetFirestore = async () => {
//     const collectionRef = admin.firestore().collection();
//     const query = collectionRef.get();
//     const collections = query.then(snapshot => {
//       let collections = [];
//       snapshot.forEach(doc => {
//         collections.push(doc);
//       });
//       return collections;
//     });
//     const collectionsToDelete = await collections;
//     collectionsToDelete.forEach(async collection => {
//       await collection.ref.delete();
//     });
//     const resetPromise = admin.firestore().settings();
//     await resetPromise.then(() => {
//       console.log('Firestore reset');
//     });
//   }

// resetFirestore();

deleteAllUsers();
deleteFiles();
//deleteAllCollections();
// deleteDocuments("collection_name");