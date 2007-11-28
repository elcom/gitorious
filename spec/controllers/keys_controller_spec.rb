require File.dirname(__FILE__) + '/../spec_helper'

describe KeysController, "index" do
  
  before(:each) do
    login_as :johan
  end
  
  def do_get
    get :index
  end
  
  it "requires login" do
    session[:user_id] = nil
    do_get
    response.should be_redirect
    response.should redirect_to(new_sessions_path)
  end
  
  it "GET account/keys is successful" do
    do_get
    response.should be_success
  end
  
  it "scopes to the current_users keys" do
    do_get
    assigns[:ssh_keys].should == users(:johan).ssh_keys
  end
end

describe KeysController, "new" do
  
  before(:each) do
    login_as :johan
  end
  
  def do_get()
    get :new
  end
  
  it "should require login" do
    session[:user_id] = nil
    do_get
    response.should redirect_to(new_sessions_path)
  end
  
  it "GET account/keys is successful" do
    do_get
    response.should be_success
  end
  
  it "scopes to the current_user" do
    do_get
    assigns[:ssh_key].user_id.should == users(:johan).id
  end
end

describe KeysController, "create" do
  
  before(:each) do
    login_as :johan
  end
  
  def valid_key
    <<-EOS
ssh-rsa bXljYWtkZHlpemltd21vY2NqdGJnaHN2bXFjdG9zbXplaGlpZnZ0a3VyZWFz
c2dkanB4aXNxamxieGVib3l6Z3hmb2ZxZW15Y2FrZGR5aXppbXdtb2NjanRi
Z2hzdm1xY3Rvc216ZWhpaWZ2dGt1cmVhc3NnZGpweGlzcWpsYnhlYm95emd4
Zm9mcWU= foo@example.com
EOS
  end
  
  def invalid_key
    "ooger booger wooger@burger"
  end
  
  def do_post(opts={})
    post :create, :ssh_key => {:key => valid_key}.merge(opts)
  end
  
  it "should require login" do
    session[:user_id] = nil
    do_post 
    response.should redirect_to(new_sessions_path)
  end
  
  it "scopes to the current_user" do
    do_post
    assigns[:ssh_key].user_id.should == users(:johan).id
  end
  
  it "POST account/keys/create is successful" do
    do_post
    response.should be_redirect
  end
end
