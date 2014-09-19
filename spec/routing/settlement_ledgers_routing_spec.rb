require 'spec_helper'

describe 'routes for SettlementLedger', type: :routing do
  it 'routes /' do
    expect(get('/')).to route_to('settlement_ledgers#index')
  end

  it 'routes /settlement_ledgers to the settlement_ledgers controller' do
    expect(get('/settlement_ledgers')).to route_to('settlement_ledgers#index')
  end

  it 'routes /settlement_ledgers/10 to the settlement_ledgers controller' do
    expect(get('/settlement_ledgers/10')).not_to be_routable
  end

  it 'routes /settlement_ledgers/new to the settlement_ledgers controller' do
    expect(get('/settlement_ledgers/new')).to route_to('settlement_ledgers#new')
  end

  it 'routes /settlement_ledgers to the settlement_ledgers controller' do
    expect(post('/settlement_ledgers')).to route_to('settlement_ledgers#create')
  end

  it 'routes /settlement_ledgers/5/edit to the settlement_ledgers controller' do
    expect(get('/settlement_ledgers/5/edit')).to route_to('settlement_ledgers#edit', id: '5')
  end

  it 'routes /settlement_ledgers/5 to the settlement_ledgers controller' do
    expect(put('/settlement_ledgers/5')).to route_to('settlement_ledgers#update', id: '5')
  end

  it 'routes /settlement_ledgers/5 to the settlement_ledgers controller' do
    expect(patch('/settlement_ledgers/5')).to route_to('settlement_ledgers#update', id: '5')
  end

  it 'routes /settlement_ledgers/5 to the settlement_ledgers controller' do
    expect(delete('/settlement_ledgers/5')).to route_to('settlement_ledgers#destroy', id: '5')
  end

  it 'routes /settlement_ledgers/10/edit_for_settle to the settlement_ledgers controller' do
    expect(get('/settlement_ledgers/10/edit_for_settle')).to route_to('settlement_ledgers#edit_for_settle', id: '10')
  end

  it 'routes /settlement_ledgers/10/settle to the settlement_ledgers controller' do
    expect(put('/settlement_ledgers/10/settle')).to route_to('settlement_ledgers#settle', id: '10')
  end

  it 'routes /settlement_ledgers/download to the settlement_ledgers controller' do
    expect(get('/settlement_ledgers/download')).to route_to('settlement_ledgers#download')
  end
end
