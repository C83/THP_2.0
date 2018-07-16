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
      create_list(:lesson, 2)
      subject
    end

    it 'returns status 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'lists 2 lessons' do
      expect(json_response.count).to eq(2)
    end
  end

  describe 'GET #show' do
    let(:lesson_id){ create(:lesson).id }

    subject{ get :show, params: { id: lesson_id } }

    context 'when lesson exist' do
      before { subject }
      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end
      it "shows the lesson" do
        expect(json_response[:id]).to eq(lesson_id)
      end
    end

    context 'when lesson doesn\'t exist' do
      let(:lesson_id){ 1 }
      it "returns error 404" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    let(:lesson_params){ attributes_for(:lesson) }

    subject{ post :create, params: { lesson: lesson_params } }

    context 'with valid params' do
      it 'returns status 201' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'creates new lesson' do
        expect{ subject }.to change{ Lesson.count }.by(1)
      end
    end

    context 'with invalid params' do
      it 'returns status 403 without title' do
        lesson_params[:title] = ''
        subject
        expect(response).to have_http_status(:forbidden)
      end
      it 'doesn\'t create new lesson' do
        lesson_params[:title] = ''
        expect{ subject }.to_not(change{ Lesson.count })
      end
      it 'returns status 403 with title so long' do
        lesson_params[:title] = Faker::Lorem.characters(51)
        subject
        expect(response).to have_http_status(:forbidden)
      end
      it 'returns status 403 with description so long' do
        lesson_params[:description] = Faker::Lorem.characters(301)
        subject
        expect(response).to have_http_status(:forbidden)
      end
      it 'returns status 403 with no title' do
        lesson_params[:title] = ''
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #update' do
    let(:lesson) { create(:lesson, title: 'Arthus') }
    let(:new_params){ attributes_for(:lesson).merge(title: 'Harry') }

    subject{ post :update, params: { id: lesson.id, lesson: new_params } }

    context 'with valid params' do
      before{ subject }
      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end
      it 'changes the title' do
        expect(json_response[:title]).to eq(new_params[:title])
      end
    end

    context 'with invalid params' do
      it 'returns status 403 without title' do
        new_params[:title] = ''
        subject
        expect(response).to have_http_status(:forbidden)
      end
      it 'returns status 403 with title so long' do
        new_params[:title] = Faker::Lorem.characters(51)
        subject
        expect(response).to have_http_status(:forbidden)
      end
      it 'returns status 403 with description so long' do
        new_params[:description] = Faker::Lorem.characters(301)
        subject
        expect(response).to have_http_status(:forbidden)
      end
      it 'returns status 403 with no title' do
        new_params[:title] = ''
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:lesson_id){ create(:lesson).id }

    subject{ delete :destroy, params: { id: lesson_id } }

    context 'with valid params' do
      it 'returns status 204' do
        subject
        expect(response).to have_http_status(:no_content)
      end
      it 'destroys the lesson' do
        expect{ subject }.to change{ Lesson.count }.by(-1)
      end
    end

    context 'with invalid params' do
      let!(:lesson_id) { 1 }

      it 'returns status 404' do
        subject
        expect(response).to have_http_status(:not_found)
      end
      it 'doesn\'t destroy the lesson' do
        expect{ subject }.to_not(change{ Lesson.count })
      end
    end
  end
end
