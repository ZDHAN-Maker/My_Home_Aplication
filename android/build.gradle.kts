import java.util.Properties
import java.io.FileInputStream


buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Versi AGP terbaru yang cocok dengan Gradle 8.9
        classpath("com.android.tools.build:gradle:8.5.2")
    }
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}

// Jika ingin custom build directory, pastikan variabel dan pemanggilannya benar.
// Namun, untuk stabilitas, gunakan konfigurasi default Gradle.

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
