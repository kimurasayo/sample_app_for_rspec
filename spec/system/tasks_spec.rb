require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }
  
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
      context 'ページ遷移する' do
        it 'タスクの詳細ページに遷移する' do
          visit task_path(task)
          expect(current_path).to eq task_path(task)
          expect(page).to have_content task.title
        end
        it 'タスクの一覧ページに遷移する' do
          task_list = create_list(:task, 3)
          visit tasks_path
          expect(page).to have_content task_list[0].title
          expect(page).to have_content task_list[1].title
          expect(page).to have_content task_list[2].title
          expect(current_path).to eq tasks_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { Login_as(user) }

    describe 'タスクの作成' do
      context '正常に作成できる' do
        it 'タスクの新規作成に成功する' do
          visit new_task_path
          fill_in 'Title', with: "title"
          fill_in 'Content', with: 'content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Create Task'
          expect(page).to have_content 'Title: title'
          expect(page).to have_content 'Content: content'
          expect(page).to have_content 'Deadline: 2020/6/1 10:30'
          expect(current_path).to eq '/tasks/1'
        end
      end
      context '作成できない' do
        it 'タスクの新規作成に失敗する' do
          visit new_task_path
          fill_in 'Title', with: ""
          fill_in 'Content', with: 'content'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
        it 'タイトルが重複して新規作成に失敗する' do
          visit new_task_path
          other_task = create(:task)
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'content'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq tasks_path
        end
      end
    end
    describe 'タスクの編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }
      before { visit edit_task_path(task) }
      
      context 'フォームの入力値が正常' do
        it 'タスクの編集に成功する' do
          fill_in 'Title', with: "title"
          fill_in 'Content', with: 'content'
          click_button 'Update Task'
          expect(page).to have_content "Task was successfully updated."
          expect(page).to have_content "Title: title"
          expect(page).to have_content "Content: content"
          expect(current_path).to eq task_path(task)
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの編集に失敗する' do
          fill_in 'Title', with: nil
          fill_in 'Content', with: 'content'
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end
      context '登録済みのタイトルを入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Title', with: other_task.title
          select :todo, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }

      it 'タスクの削除に成功する' do
        visit tasks_path
        click_link "Destroy"
        expect(page.accept_confirm).to eq "Are you sure?"
        expect(page).to have_content "Task was successfully destroyed."
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title
      end
    end
  end
end
