# frozen_string_literal: true

@network = {}

def add_network_connection(line)
  from, to = line.split('-').map(&:to_sym)

  @network[from] ||= []
  @network[from] << to

  @network[to] ||= []
  @network[to] << from
end

File.readlines('input', chomp: true).each do |line|
  add_network_connection(line)
end
# 1175

# input1 = %(kh-tc
# qp-kh
# de-cg
# ka-co
# yn-aq
# qp-ub
# cg-tb
# vc-aq
# tb-ka
# wh-tc
# yn-cg
# kh-ub
# ta-co
# de-co
# tc-td
# tb-wq
# wh-td
# ta-ka
# td-qp
# aq-cg
# wq-ub
# ub-vc
# de-ta
# wq-aq
# wq-vc
# wh-yn
# ka-de
# kh-ta
# co-tc
# wh-qp
# tb-vc
# td-yn)
# # 7

# input1.split("\n").each do |line|
#   add_network_connection(line)
# end

def find_interconnected_pcs
  connected = []

  @network.each do |from, tos|
    next unless from.start_with?('t')
    next if tos.size < 2

    tos.each do |to|
      inter_connected = @network[to] & tos
      next if inter_connected.empty?

      inter_connected.each do |ic|
        connected << [from, to, ic].sort
      end
    end
  end

  connected.uniq.size
end

p "sum: #{find_interconnected_pcs}"
