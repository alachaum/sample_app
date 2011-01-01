module MicropostsHelper

  def reply_from_to_prefix(micropost)
    recipient = User.find_by_id(micropost.in_reply_to)
    from = link_to micropost.user.name, micropost.user
    to = link_to recipient.name, recipient
    from + " @ " + to
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

