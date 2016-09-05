describe ActiveRecord::ConnectionAdapters::SchemaStatements do
  describe "#index_name_with_simple" do
    context "When auto_shorten is enabled" do
      include_context :setup_database, auto_shorten: true

      context "When single column index" do
        it_is_asserted_by { index_name_of(:articles, [:user_id]) == "user_id" }
      end

      context "When multiple columns index" do
        it_is_asserted_by { index_name_of(:user_stocks, [:user_id, :article_id]) == "user_id_and_article_id" }
      end

      context "When specified index name" do
        it_is_asserted_by { index_name_of(:comments, :user_id) == "comment_index" }
      end

      context "When index name of renamed table" do
        it_is_asserted_by { index_name_of(:new_table, :anonymous_name) == "anonymous_name" }
      end
    end

    context "When auto_shorten is disabled" do
      include_context :setup_database, auto_shorten: false

      context "When single column index" do
        it_is_asserted_by { index_name_of(:articles, [:user_id]) == "index_articles_on_user_id" }
      end

      context "When multiple columns index" do
        it_is_asserted_by { index_name_of(:user_stocks, [:user_id, :article_id]) == "index_user_stocks_on_user_id_and_article_id" }
      end

      context "When specified index name" do
        it_is_asserted_by { index_name_of(:comments, :user_id) == "comment_index" }
      end

      context "When index name of renamed table" do
        it_is_asserted_by { index_name_of(:new_table, :anonymous_name) == "index_new_table_on_anonymous_name" }
      end
    end

    context "When auto_shorten is either enabled or disabled" do
      [true, false].each do |auto_shorten|
        context "When auto_shorten is #{auto_shorten}" do
          include_context :setup_database, auto_shorten: auto_shorten

          context "When has DisableShorten in migration" do
            it_is_asserted_by { index_name_of(:user_stocks, :article_id) == "index_user_stocks_on_article_id" }
          end

          context "When has EnableShorten in migration" do
            it_is_asserted_by { index_name_of(:articles, :category_id) == "category_id" }
          end
        end
      end
    end

    def table_indexes(table)
      ActiveRecord::Base.connection.indexes(table)
    end

    def index_name_of(table, columns)
      columns = Array.wrap(columns).map(&:to_s)
      table_indexes(table.to_s).find { |index| index.columns == columns }.try(:name)
    end
  end
end
