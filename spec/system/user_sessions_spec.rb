require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }
  
  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
        visit root_path
        expect(page).to have_content('Login')
        visit login_path
        fill_in "Email", with: user.email
        fill_in "Password", with: 'password'
        click_button 'Login'
        expect(current_path).to eq root_path
        expect(page).to have_content "Login successful"
      end
    end
    context 'フォームが未入力' do
      it 'ログイン処理が失敗する' do
        visit root_path
        expect(page).to have_content('Login')
        visit login_path
        fill_in 'Email', with: ''
        fill_in 'Password', with: 'password'
        click_button 'Login'
        expect(current_path).to eq login_path
        expect(page).to have_content "Login failed"
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        Login_as(user)
        expect(current_path).to eq root_path
        click_on 'Logout'
        expect(current_path).to eq root_path
        expect(page).to have_content "Logged out"
      end
    end
  end
end
