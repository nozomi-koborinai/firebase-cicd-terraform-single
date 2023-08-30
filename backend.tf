terraform {
  backend "gcs" {
    bucket = "firebase-cicd-terraform-single-backend"
  }
}