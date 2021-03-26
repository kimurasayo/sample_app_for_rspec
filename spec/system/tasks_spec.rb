require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) {create(:task, user: user) }
  
  describe 'ログイン前' do
    describe 'タスクの作成' do
      context 'ページ遷移しない' do
        it 'タスクの新規作成ページに遷移しない' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content "Login required"
        end
        it 'タスクの編集ページに遷移しない' do
          visit edit_task_path(task)
          expect(current_path).to eq login_path
          expect(page).to have_content "Login required"
        end
      end
    end
  end

  describe 'ログイン後' do
    let!(:task) { create(:task, user: user) }
    describe 'タスクの作成' do
      context '正常に作成できる' do
        it 'タスクの新規作成に成功する' do
          Login_as(user)
          visit new_task_path
          fill_in 'Title', with: "title"
          fill_in 'Content', with: 'content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: '2021/3/30 17:48'
          click_button 'Create Task'
        end
        it 'タスクの編集に成功する' do
          Login_as(user)
          visit edit_task_path(task)
          fill_in 'Title', with: "title"
          fill_in 'Content', with: 'content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: '2021/3/30 17:48'
          click_button 'Update Task'
          expect(page).to have_content "Task was successfully updated."
          expect(page).to have_content "Title: title"
          expect(page).to have_content "Content: content"
          expect(page).to have_content "Status: todo"
        end
        it 'タスクの削除に成功する' do
          Login_as(user)
          visit tasks_path
          click_link "Destroy", match: :first
          expect {
          page.accept_confirm "Are you sure?"
          expect(page).to have_content "Task was successfully destroyed."
          }.to change { Task.count }.by(-1)
          expect(current_path).to eq tasks_path
        end
      end
      context '作成できない' do
        it 'タスクの新規作成に失敗する' do
          Login_as(user)
          visit new_task_path
          fill_in 'Title', with: ""
          fill_in 'Content', with: 'content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: '2021/3/30 17:48'
          click_button 'Create Task'
        end
        it 'タスクの編集に失敗する' do
          Login_as(user)
          visit edit_task_path(task)
          fill_in 'Title', with: ""
          fill_in 'Content', with: 'content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: '2021/3/30 17:48'
          click_button 'Update Task'
          expect(page).to have_content "Title can't be blank"
        end
      end
    end
  end
end
