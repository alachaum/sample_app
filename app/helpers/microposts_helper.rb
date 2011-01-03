module MicropostsHelper

  def micropost_title(micropost)
    from = link_to current_user?(micropost.user) ? "You" : micropost.user.name, micropost.user
    if micropost.reply?
      recipient = User.find_by_id(micropost.in_reply_to)
      to = link_to current_user?(recipient) ? "You" : recipient.name, recipient
      from + " @ " + to
    else
      from
    end
  end


  def reply_to_prefix(micropost)
    recipient = User.find_by_id(micropost.in_reply_to)
    "@ #{recipient.name} "
  end

  def wrap(content)
    raw(content.split.map{ |s| wrap_long_string(s) }.join(' '))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end
end

