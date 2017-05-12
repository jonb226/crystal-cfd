module BehavesLikeA
  macro behaves_like_a(type)
    {% for method in type.resolve.methods %}
      {{ method.id }}
    {% end %}
  end
end

include BehavesLikeA
