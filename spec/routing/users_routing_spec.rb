require 'spec_helper'

describe 'routes for User', type: :routing do
  it 'routes /users/sign_in to the devise/sessions controller' do
    expect(get('/users/sign_in')).to route_to('devise/sessions#new')
  end

  it 'routes /users/sign_in to the devise/sessions controller' do
    expect(post('/users/sign_in')).to route_to('devise/sessions#create')
  end

  it 'routes /users/sign_out to the devise/sessions controller' do
    expect(delete('/users/sign_out')).to route_to('devise/sessions#destroy')
  end

  it 'routes /users/password to the devise/passwords controller' do
    expect(get('/users/password/new')).to route_to('devise/passwords#new')
  end

  it 'routes /users/password to the devise/passwords controller' do
    expect(post('/users/password')).to route_to('devise/passwords#create')
  end

  it 'routes /users/password to the devise/passwords controller' do
    expect(get('/users/password/edit')).to route_to('devise/passwords#edit')
  end

  it 'routes /users/password to the devise/passwords controller' do
    expect(put('/users/password')).to route_to('devise/passwords#update')
  end

  it 'routes /users/password to the devise/passwords controller' do
    expect(patch('/users/password')).to route_to('devise/passwords#update')
  end

  it 'routes /users/confirmation to the devise/confirmations controller' do
    expect(get('/users/confirmation')).to route_to('devise/confirmations#show')
  end

  it 'routes /users/confirmation to the devise/confirmations controller' do
    expect(get('/users/confirmation/new')).to route_to('devise/confirmations#new')
  end

  it 'routes /users/confirmation to the devise/confirmations controller' do
    expect(post('/users/confirmation')).to route_to('devise/confirmations#create')
  end

  it 'routes /users/edit to the devise/registrations controller' do
    expect(get('/users/edit')).to route_to('devise/registrations#edit')
  end

  it 'routes /users to the devise/registrations controller' do
    expect(put('/users')).to route_to('devise/registrations#update')
  end

  it 'routes /users to the users controller' do
    expect(get('/users')).to route_to('users#index')
  end

  it 'routes /users/show to the users controller' do
    expect(get('/users/show')).to be_routable
  end

  it 'routes /users/new to the users controller' do
    expect(get('/users/new')).to route_to('users#new')
  end

  it 'routes /users to the users controller' do
    expect(post('/users')).to route_to('users#create')
  end

  it 'routes /users/5/edit to the susers controller' do
    expect(get('/users/5/edit')).to route_to('users#edit', id: '5')
  end

  it 'routes /users/5 to the users controller' do
    expect(put('/users/5')).to route_to('users#update', id: '5')
  end

  it 'routes /users/5 to the users controller' do
    expect(patch('/users/5')).to route_to('users#update', id: '5')
  end

  it 'routes /users/5 to the users controller' do
    expect(delete('/users/5')).to route_to('users#destroy', id: '5')
  end
end
