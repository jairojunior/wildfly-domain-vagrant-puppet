class role::lb {
  include profile::httpd::cluster
  include profile::httpd::cluster::firewalld
}
