# Keep Google Play Services Auth classes
-keep class com.google.android.gms.auth.api.credentials.Credential$Builder { *; }
-keep class com.google.android.gms.auth.api.credentials.Credential { *; }
-keep class com.google.android.gms.auth.api.credentials.CredentialPickerConfig$Builder { *; }
-keep class com.google.android.gms.auth.api.credentials.CredentialPickerConfig { *; }
-keep class com.google.android.gms.auth.api.credentials.CredentialRequest$Builder { *; }
-keep class com.google.android.gms.auth.api.credentials.CredentialRequest { *; }
-keep class com.google.android.gms.auth.api.credentials.CredentialRequestResponse { *; }
-keep class com.google.android.gms.auth.api.credentials.Credentials { *; }
-keep class com.google.android.gms.auth.api.credentials.CredentialsClient { *; }
-keep class com.google.android.gms.auth.api.credentials.HintRequest$Builder { *; }
-keep class com.google.android.gms.auth.api.credentials.HintRequest { *; }

# Keep Proguard annotations
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# Suppress warnings for the specified classes
-dontwarn com.google.android.gms.auth.api.credentials.Credential$Builder
-dontwarn com.google.android.gms.auth.api.credentials.Credential
-dontwarn com.google.android.gms.auth.api.credentials.CredentialPickerConfig$Builder
-dontwarn com.google.android.gms.auth.api.credentials.CredentialPickerConfig
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequest$Builder
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequest
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequestResponse
-dontwarn com.google.android.gms.auth.api.credentials.Credentials
-dontwarn com.google.android.gms.auth.api.credentials.CredentialsClient
-dontwarn com.google.android.gms.auth.api.credentials.HintRequest$Builder
-dontwarn com.google.android.gms.auth.api.credentials.HintRequest
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers
