require 'rails_helper'
require 'pry'

RSpec.describe LessonsController, type: :controller do
  describe 'routes' do
    it { should route(:get, '/lessons').to(action: :index) }
    it { should route(:get, '/lessons/574d5c29-fd2d-4494-ae28-12cdb0da1c07').to(action: :show, id: "574d5c29-fd2d-4494-ae28-12cdb0da1c07") }
    it { should route(:post, '/lessons').to(action: :create) }
    it { should route(:put, '/lessons/574d5c29-fd2d-4494-ae28-12cdb0da1c07').to(action: :update, id: "574d5c29-fd2d-4494-ae28-12cdb0da1c07") }
    it { should route(:patch, '/lessons/574d5c29-fd2d-4494-ae28-12cdb0da1c07').to(action: :update, id: "574d5c29-fd2d-4494-ae28-12cdb0da1c07") }
    it { should route(:delete, '/lessons/574d5c29-fd2d-4494-ae28-12cdb0da1c07').to(action: :destroy, id: "574d5c29-fd2d-4494-ae28-12cdb0da1c07") }
  end

  describe 'GET #index' do
    subject do
      get :index
    end

    before do
      FactoryBot.create_list(:lesson, 2)
      subject
    end

    it 'returns status 200' do
      expect(response.code).to eq("200")
    end

    it 'lists 2 lessons' do
      expect(json_response.count).to eq(2)
    end
  end

  describe 'GET #show' do
    let!(:lesson){ FactoryBot.create(:lesson) }
    let(:id){ Lesson.last.id }

    subject{ get :show, params: { id: id } }

    context 'when lesson exist' do
      it 'returns status 200' do
        subject
        expect(response.code).to eq("200")
      end
      it "shows the lesson" do
        subject
        expect(json_response[:id]).to eq(lesson.id)
      end
    end

    context 'when lesson doesn\'t exist' do
      let(:id){ 1 }
      it "returns error 404" do
        subject
        expect(response.code).to eq("404")
      end
    end
  end

  describe 'POST #create' do
    let(:lesson_params){ FactoryBot.attributes_for(:lesson) }

    subject{ post :create, params: { lesson: lesson_params } }

    context 'with valid params' do
      it 'returns status 201' do
        subject
        expect(response.code).to eq("201")
      end

      it 'creates new lesson' do
        expect{ subject }.to change{ Lesson.count }.by(1)
      end
    end

    context 'with invalid params' do
      before{ lesson_params[:title] = '' }
      it 'returns status 403 without title' do
        subject
        expect(response.code).to eq("403")
      end
      it 'doesn\'t create new lesson' do
        expect{ subject }.to change { Lesson.count }.by(0)
      end
    end
  end

  describe 'POST #update' do
    let(:lesson) { FactoryBot.create(:lesson, title: 'Arthus') }
    let(:new_title){ 'Harry' }

    subject{ post :update, params: { id: lesson.id, lesson: { title: new_title } } }

    context 'with valid params' do
      before{ subject }
      it 'returns status 200' do
        expect(response.code).to eq("200")
      end
      it 'changes the title' do
        expect(json_response[:title]).to eq(new_title)
      end
    end

    context 'with invalid params' do
      let(:new_title){ '' }
      it 'returns status 403' do
        subject
        expect(response.code).to eq('403')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:lesson_id){ FactoryBot.create(:lesson).id }

    subject{ delete :destroy, params: { id: lesson_id } }

    context 'with valid params' do
      it 'returns status 204' do
        subject
        expect(response.code).to eq('204')
      end
      it 'destroys the lesson' do
        expect{ subject }.to change{ Lesson.count }.by(-1)
      end
    end

    context 'with invalid params' do
      let!(:lesson_id) { 1 }

      it 'returns status 404' do
        subject
        expect(response.code).to eq('404')
      end
      it 'doesn\'t destroy the lesson' do
        expect{ subject }.to change{ Lesson.count }.by(0)
      end
    end
  end
end
