class ArticlesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]
    
    def new
        @article = Article.new
    end
    
    def create
        @article = current_user.articles.build(article_params)  # Usamos build en lugar de new para asociarlo con el usuario.
        
        if @article.save
            redirect_to @article
        else
            render 'new'
        end
    end
    
    def show
        @article = Article.find(params[:id])
    end
    
    def index
        @articles = Article.all
    end
    
    def edit
        # Ya no es necesario buscar @article aquí, ya lo hace el before_action
    end
    
    def update
        if @article.update(article_params)
            redirect_to @article
        else
            render 'edit'
        end
    end
    
    def destroy
        @article.destroy
        flash[:notice] = "Artículo eliminado correctamente."
        redirect_to articles_path
    end
    
    private
    
    def article_params
        params.require(:article).permit(:title, :text)
    end
    
    def set_post
        @article = Article.find(params[:id])
    end
    
    def authorize_user!
        if @article.user != current_user
            redirect_to articles_path, alert: "No tienes permiso para realizar esta acción."
        end
    end
end
