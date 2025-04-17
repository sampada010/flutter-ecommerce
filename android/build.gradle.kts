// Root-level build.gradle.kts

buildscript {
    repositories {
        google()
        mavenCentral()
        jcenter() // This is deprecated, but some older libraries might still use it
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.0.4") // Or use the latest stable version of the Android Gradle Plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        jcenter() // Optional, some legacy libraries may still be hosted here
    }
}

// Custom build directory configuration
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Optional: To ensure that 'app' is evaluated before other subprojects
    project.evaluationDependsOn(":app")
}

// Clean task to delete the build directories
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

