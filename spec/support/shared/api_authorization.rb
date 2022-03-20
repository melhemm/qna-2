shared_examples 'API ok status' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples 'API Unauthorizable' do
  context 'unauthorized' do
    it 'returns 401 status' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'return 401 status' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples 'API Authorizable' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'API contains object' do
  it 'contains object' do
    objects.each do |object|
      expect(resource_response[object]['id']).to eq resource.send(object).id
    end
  end
end

shared_examples_for 'API returns all public fields' do
  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples_for 'API returns list of resource' do
  it 'returns list of all contents' do
    resource_contents.each do |content|
      expect(resource_response[content].size).to eq resource.send(content).size
    end
  end
end
