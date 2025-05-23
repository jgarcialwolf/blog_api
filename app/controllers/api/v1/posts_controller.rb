module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: %i[show update destroy]

      def index
        @q = Post.ransack(params[:q])
        posts = @q.result(distinct: true)
        render json: PostSerializer.many(posts)
      end

      def show
        render json: PostSerializer.one(@post)
      end

      def create
        post = Post.new(post_params)
        if post.save
          render json: PostSerializer.one(post), status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @post.update(post_params)
          render json: PostSerializer.one(@post)
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @post.destroy
        head :no_content
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :content, :category, tags: [])
      end
    end
  end
end
