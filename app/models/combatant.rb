# frozen_string_literal: true

# A Combatant is the core component of a combat.
# A combat has many combatants and each combatant has basic stats.
# Combatants can relate to characters for more complicated scenarios
class Combatant < ApplicationRecord
  attr_accessor :count
  belongs_to :combat
  before_create :increment_name

  validates(:name, presence: true)

  private

  # Increments a number at the end of the combatant name if a duplicate exists
  # E.g.; If name is Monster, and Monster 7 exists, it's renamed to Monster 8
  def increment_name
    return nil unless combat

    names = find_similiar_names(combat.combatants)
    return nil if names.empty?

    num = names.last.scan('/\s\d/')
    index = num.empty? ? 1 : num.strip.to_i + 1
    self.name = "#{name} #{index}"
  end

  # Finds names of other combatants that start with a similiar name.
  # Combatants can have duplicate names, but not for the same combat.
  # Params:
  # +combatants+:: list of all combatants in the combat
  # @return [String[]]
  def find_similiar_names(combatants)
    matching_names = []

    combatants.each do |combatant|
      matching_names << combatant.name if combatant.name.match?("/#{name}\s/")
    end

    matching_names.sort
  end
end
