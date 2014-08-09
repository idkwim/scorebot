class RedemptionController < ApplicationController
  protect_from_forgery except: :create

  def create
    tokens = params[:tokens] || []
    redemptions = tokens.inject({}) do |m, t|
      next m if t.blank?
      r = begin 
            Stats.time "#{current_team.certname}.redeem_for" do
              Redemption.redeem_for(current_team, t).uuid
            end
          rescue => e
            Scorebot.log "Redeem #{t} failed for #{current_team.try(:name)}: #{e.message}"
            "error: #{e.message}"
          end
      m[t] = r
      m
    end

    redemptions.values.each do |r|
      Event.new('redemption', r.as_event_json ).publish! rescue nil
    end

    render json: redemptions.to_json
  end
end
