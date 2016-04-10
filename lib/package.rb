class Package
  def initialize(url)
    @info = {'url' => url}
  end

  def add(value)
    @info.update(value.inject(:merge))
  end
end
