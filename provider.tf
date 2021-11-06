terraform{
	backend "s3"{
		bucket = "als-recc-storage-krauzem"
		key = "tfstate/terraform.tfstate"
		region = "eu-central-1"
		encrypt = "true"
	}
}

provider "aws" {
	region = "eu-central-1"
	profile = "default"
}
