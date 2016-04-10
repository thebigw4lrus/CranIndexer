class Package
  def initialize(url)
    @info = {'url' => url}
  end

  def add(value)
    @info.update(value.inject(:merge))
  end

  def enrich
    # Here will be the logic for get the extra
    # info out of the compressed package
    nil
  end
end
