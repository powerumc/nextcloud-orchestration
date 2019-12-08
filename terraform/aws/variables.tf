variable "nextcloud" {
  type = object({
    vpc_cidr_block        = string
    subnet_cidr_block     = string
    instance_private_ip   = string
    instance_ami          = string
    instance_key_name     = string
    instance_type         = string
    ebs_db_volumn_type    = string
    ebs_db_volumn_size    = number
    route53_domain        = string
    your_nextcloud_domain = string
    your_email            = string
    ssh_key_file_path     = string
  })
  default = {
    vpc_cidr_block        = "10.10.0.0/16"
    subnet_cidr_block     = "10.10.0.0/24"
    instance_private_ip   = "10.10.0.10"
    instance_ami          = "ami-0d59ddf55cdda6e21"
    instance_key_name     = "powerumc-aws"
    instance_type         = "t2.micro"
    ebs_db_volumn_type    = "sc1"
    ebs_db_volumn_size    = 500
    route53_domain        = "powerumc.kr."
    your_nextcloud_domain = "cloud.powerumc.kr"
    your_email            = "powerumc@gmail.com"
    ssh_key_file_path     = "~/Dropbox/security/powerumc-aws.pem"
  }
}