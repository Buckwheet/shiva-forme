module Shiva
  class SymbolRestoration < Action
    def priority
      Priority.get(:high)
    end

    def available?
      Society.status.eql?("Order of Voln") and
      Society.rank > 20 and
      percenthealth < 90 and
      not muckled?
    end

    def apply()
      waitrt?
      fput "symbol of restoration"
      $shiva_restoration_attempted = true
    end
  end
end