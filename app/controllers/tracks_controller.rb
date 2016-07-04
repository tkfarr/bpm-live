class TracksController < ApplicationController

  def index
    @tracks = Track.all
  end

  def new
    @track = Track.new
  end

  def create
    # DONE - when click save, prevent default and send tracks object to here.

    # DONE - create new track. send track variable from application.js to controller using Json.

    # DONE - associate track with user


    # loop through track and create new layer object for each item in array, with track_id - associate

    @track = Track.new(track_params) # (params[:track])
    respond_to do |format|
      if @track.save
        format.html  { redirect_to(root_path,
                      :notice => 'Post was successfully created.') }
        format.json  { render :json => @track,
                      :status => :created, :location => @track }

        # associate track with user
        @track.users << current_user
        puts "#{@track}***********************************************"

        # loop through track and create new layer object for each item in array, with track_id - associate
        track = params[:track].values
        track.each do |layer|
            # track index
            ti = 0
            # layer index
            li = 0
          until ti == (track.length - 1) do
            new_layer = Layer.create(track_id: @track.id)
            if new_layer
              # increase counter by 1 for each layer iteration
              li += 1
              # counter to change to next beat
              b = 0
              # how many beats in this layer
              length = track[0].length
              until b == (length) do

                x = track[li].values[b][:rest]
                y = track[li].values[b][:keypress]
                z = track[li].values[b][:color]

                new_beat = Beat.create(
                  layer_id: new_layer.id,
                  rest: x,
                  keypress: y,
                  color: z
                )

                new_layer.beats << new_beat
                b += 1
              end
            else
              li = 0
            end
            ti += 1
          end
        end
      else
        format.html  { render :action => "new" }
        format.json  { render :json => @track.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def show
    @track = Track.find(params[:id])
    p @track
    puts "+++++++++++++++++++++++++++++++++++++++++++++"
    @beat_array = []
    i = 0
    @track.layers.each do |layer|
      @beat_array << i.to_s
      i += 1
      layer.beats.each do |beat|
        @beat_array << beat.attributes
      end
    end
    p @beat_array
    puts "++++++++++++++++++++++++++++++++++++++++++++++++"
    # p JSON.parse(@beat_array.replace(/&quot;/g,'"'))
    render '/tracks/_track', layout: false
  end

  def destroy

  end

private
  def track_params
    params.require(:track).permit(:name)
  end

end
