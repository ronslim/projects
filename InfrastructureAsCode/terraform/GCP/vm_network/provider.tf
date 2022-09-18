provider "google" {
  credentials = file("qwiklabs-gcp-01-af4cc034f8f9-cd6834f779f9.json")

  project = "qwiklabs-gcp-01-af4cc034f8f9"
  region  = "us-central1"
  zone    = "us-central1-c"
}