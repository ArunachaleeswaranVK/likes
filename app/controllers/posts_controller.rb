class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy,:likes]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json

  
  def create
   
    obj = S3_BUCKET.objects[params[:file].original_filename]
    
    # Upload the file
    obj.write(
      file: params[:file],
      acl: :public_read
    )
    
    # Create an object for the upload
    @post = Post.new(
			url: obj.public_url,
			name: obj.key,
			title: params[:title]
		)
    
    # Save the upload
    if @post.save
      redirect_to posts_path, success: 'File successfully uploaded'
    else
      flash.now[:notice] = 'There was an error'
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def likes
      Like.where(post_id: @post.id , user_id: current_user.id).first_or_create
      

      redirect_to(@post)
  end
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    
      
    
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title,:url,:name)
    end
end
