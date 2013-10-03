Facter.add(:fqdn) do
  confine :operatingsystem => 'FreeboxOS'
  has_weight 100
  setcode do
    Facter['clientcert'] == nil ? 'mafreebox.free.fr' : Facter['clientcert'].value
  end
end
