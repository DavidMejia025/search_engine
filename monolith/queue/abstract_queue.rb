class AbstractQueue
  def start_conection
    raise "Must override #{__method__}"
  end

  def enqueue(msg:)
    raise "Must override #{__method__}"
  end

  def retrieve
    raise "Must override #{__method__}"
  end

  def close_conection
    raise "Must override #{__method__}"
  end
end


