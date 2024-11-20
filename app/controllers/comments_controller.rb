class CommentsController < ApplicationController
    before_action :set_article, only: [:edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]

    def create
        @article = Article.find(params[:article_id])
        @comment = @article.comments.new(comment_params)
        @comment.user = current_user  # Associate the comment with the current user
        if @comment.save
            redirect_to article_path(@article)
        else
            render :new
        end
    end
    def edit
        @comment = @article.comments.find(params[:id])
    end

    def update
        @comment = @article.comments.find(params[:id])
        if @comment.update(comment_params)
            redirect_to article_path(@article)
        else
            render :edit
        end
    end

    def destroy
        @comment = @article.comments.find(params[:id])
        @comment.destroy
        redirect_to article_path(@article)
    end

    private

    def comment_params
        params.require(:comment).permit(:commenter, :body)
    end

    def set_article
        @article = Article.find(params[:article_id])
    end

    def authorize_user!
        @comment = @article.comments.find(params[:id])
        if @comment.user != current_user
            redirect_to articles_path, alert: "No tienes permiso para realizar esta acción."
        end
    end
end