Facter.add(:interfaces) do
  confine :operatingsystem => 'FreeboxOS'
  has_weight 100
  setcode do
    'ppp0,eth0,lo'
  end
end
