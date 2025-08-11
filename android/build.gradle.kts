import com.android.build.gradle.LibraryExtension
import com.android.build.gradle.tasks.ProcessLibraryManifest
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Ensure third-party Android libraries have a namespace (required by AGP 8+)
subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<LibraryExtension>("android") {
            if (namespace == null || namespace!!.isEmpty()) {
                // Derive a stable fallback namespace from the project name
                val safeName = project.name.replace('-', '_').replace('.', '_')
                namespace = "com.external.$safeName"
            }

            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
            tasks.withType<KotlinCompile>().configureEach {
                kotlinOptions {
                    jvmTarget = JavaVersion.VERSION_17.toString()
                    freeCompilerArgs = freeCompilerArgs + listOf("-Xlint:-options")
                }
            }
        }

        // Workaround for libraries that still set AndroidManifest.xml package attribute
        tasks.withType<ProcessLibraryManifest>().configureEach {
            doFirst {
                try {
                    val manifestFile = project.file("src/main/AndroidManifest.xml")
                    if (manifestFile.exists()) {
                        val text = manifestFile.readText()
                        val updated = text.replace(Regex("\\s*package=\"[^\"]+\""), "")
                        if (updated != text) {
                            manifestFile.writeText(updated)
                            println("[workaround] Stripped package attribute from ${project.path} manifest")
                        }
                    }
                } catch (e: Exception) {
                    println("[workaround] Failed to adjust manifest for ${project.path}: ${e.message}")
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
