module LoginModule
  def Login_as(user)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: 'password'
    click_button "Login"
  end
end