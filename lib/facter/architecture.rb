Facter.add(:architecture) do
  confine :operatingsystem => 'FreeboxOS'
  has_weight 100
  setcode do
    'arm'
  end
end

