module StaticHelper
  def success_messages
    return unless flash[:success]
    content_tag 'p', :class => "success-message" do
      flash[:success]
    end
  end

  def error_messages
    return unless flash[:errors]
    content_tag 'ul', :class => "error-messages" do
      flash[:errors].map do |error|
        content_tag 'li', error
      end.join('')
    end
  end
end
