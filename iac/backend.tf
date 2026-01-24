terraform {
  backend "gcs" {
    bucket  = "tf-state-sathur"        
    prefix  = "statefile/terraform"   
  }
}