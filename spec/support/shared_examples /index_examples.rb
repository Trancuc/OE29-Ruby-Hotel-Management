RSpec.shared_examples "index_examples" do
  let!(:user){FactoryBot.create :user, role: :client}
  let! (:user_admin){FactoryBot.create :user, role: :admin}
end
