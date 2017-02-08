require 'test_helper'

class CreateNewArticle < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "testuser", email: "testuser@example.com", password: "test123", admin: false)
  end

  test "create a new article" do
    sign_in_as(@user, "test123")
    get new_article_path
    assert_template "articles/new"
    assert_difference "Article.count", 1 do
      post_via_redirect articles_path, article: {title: "integration test title", description: "integration description"}
    end
    assert_template "articles/show"
    assert_match "integration", response.body
  end

  test "invalid article results in failure" do
    sign_in_as(@user, "test123")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference "Article.count", 1 do
      post_via_redirect articles_path, article: {title: " ", description: "integration description"}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end


end
