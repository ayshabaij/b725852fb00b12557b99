# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::RobotsController, type: :controller do
  let!(:robot) { create(:robot) }
  describe 'POST Robots#orders' do
    context 'Send Commands and Move bot' do
      it 'Place the bot and run the commands' do
        request.content_type = 'application/json'
        post :orders,params:{id:1, commands:['PLACE 0,0,NORTH','LEFT','REPORT']}
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response.values.flatten.count).to be == 3
        expect(json_response[:location]).to eq [0,0,'WEST']
      end
        it 'Place the bot and run the commands' do
        request.content_type = 'application/json'
        post :orders,params:{id: 1, commands:['PLACE 1,2,EAST', 'MOVE','MOVE','LEFT','MOVE','REPORT']}
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response.values.flatten.count).to be == 3
        expect(json_response[:location]).to eq [3,3,'NORTH']
      end     
       it 'Place the bot and run the commands' do
        request.content_type = 'application/json'
        post :orders,params:{id: 1, commands:['PLACE 0,0,NORTH','MOVE','REPORT']}
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response.values.flatten.count).to be == 3
        expect(json_response[:location]).to eq [0,1,'NORTH']
      end
    end
    context 'Move bot withourt place commands' do
      it 'returns with Please give the place command before moving the bot' do
        request.content_type = 'application/json'
        post :orders,params:{id:1, commands:['ST 0,0,NORTH','MOVE','REPORT']}
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(400)
        expect(json_response[:error]).to be == 'Please give the place command before moving the bot'
      end
    end
    context 'place bot falling postion' do
      it 'returns error cannot place bot in falling position' do
        request.content_type = 'application/json'
        post :orders,params:{id:1, commands:['PLACE -1,0,NORTH','MOVE','REPORT']}
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(400)
        expect(json_response[:error]).to be == 'Cannot place bot on falling position'
      end
    end
  end
end
