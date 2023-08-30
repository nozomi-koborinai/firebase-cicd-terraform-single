# 各種 API を有効化する
resource "google_project_service" "default" {
  provider = google-beta
  project  = local.project_id
  for_each = toset([
    "firestore.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "identitytoolkit.googleapis.com",
    "firebase.googleapis.com",
    "firebaserules.googleapis.com",
    "firebasestorage.googleapis.com",
    "storage.googleapis.com",
  ])
  service            = each.key
  disable_on_destroy = false
}

# Firebase のプロジェクトを立ち上げる
resource "google_firebase_project" "default" {
  provider = google-beta
  project  = local.project_id

  # 各種 API が有効化されるのを待ってから 本リソースが実行される
  depends_on = [
    google_project_service.default,
  ]
}

# Firebase プロジェクトを東京リージョンに配置する
resource "google_firebase_project_location" "default" {
  provider = google-beta
  project  = google_firebase_project.default.project

  location_id = local.region
}

# モジュールに locals ファイルを渡す
## Firebase Authentication
module "authentication" {
  source         = "./modules/authentication"
  project_id     = local.project_id
  services_ready = google_firebase_project.default
}