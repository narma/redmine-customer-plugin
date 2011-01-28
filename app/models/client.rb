class Client < ActiveRecord::Base

  has_many :issues

  def to_s
    "#{name}"
  end

  def ip_list
    deploy_ips and deploy_ips.split or []
  end

end

