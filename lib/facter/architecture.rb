Facter.add(:architecture) do
  confine :operatingsystem => 'FreeboxOS'
  has_weight 100
  setcode do
    'armv5'
  end
end

