require 'spec_helper'

describe 'routes for ApplicationReport', type: :routing do
  it 'routes /application_reports to the application_reports controller' do
    expect(get('/application_reports')).to route_to('application_reports#index')
  end

  it 'routes /application_reports/new to the application_reports controller' do
    expect(get('/application_reports/new')).to route_to('application_reports#new')
  end

  it 'routes /application_reports/10 to the application_reports controller' do
    expect(get('/application_reports/10')).to route_to('application_reports#show', id: '10')
  end

  it 'routes /application_reports to the application_reports controller' do
    expect(post('/application_reports')).to route_to('application_reports#create')
  end

  it 'routes /application_reports/5/edit to the application_reports controller' do
    expect(get('/application_reports/5/edit')).to route_to('application_reports#edit', id: '5')
  end

  it 'routes /application_reports/5 to the application_reports controller' do
    expect(put('/application_reports/5')).to route_to('application_reports#update', id: '5')
  end

  it 'routes /application_reports/5 to the application_reports controller' do
    expect(patch('/application_reports/5')).to route_to('application_reports#update', id: '5')
  end

  it 'routes /application_reports/5 to the application_reports controller' do
    expect(delete('/application_reports/5')).to route_to('application_reports#destroy', id: '5')
  end

  it 'routes /application_reports/5/download to the application_reports controller' do
    expect(get('/application_reports/5/download')).to route_to('application_reports#download', id: '5')
  end
end
