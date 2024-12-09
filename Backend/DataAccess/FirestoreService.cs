using Google.Cloud.Firestore;

namespace Backend.DataAccess
{
    public class FirestoreService
    {
        private FirestoreDb _firestoreDb;

        public FirestoreService()
        {
            string pathToCredentials = @"E:\DACN\movieticketapp-d914f-firebase-adminsdk-2m0f8-b1e688c750.json";
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", pathToCredentials);
            _firestoreDb = FirestoreDb.Create("movieticketapp-d914f");
        }

        public FirestoreDb GetFirestoreDb() => _firestoreDb;
    }
}
