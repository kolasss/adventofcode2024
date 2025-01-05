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
# 13 bw,dr,du,ha,mm,ov,pj,qh,tz,uv,vq,wq,xw

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
# # co,de,ka,ta

# input1.split("\n").each do |line|
#   add_network_connection(line)
# end

@network.each_value(&:sort!)

def find_interconnected_candidates
  connected = []

  size_min = 1
  @network.each do |from, tos|
    next unless from.start_with?('t')
    next if tos.size < 2

    tos.each do |to|
      inter_connected = @network[to] & tos
      next if inter_connected.empty?

      network_current = [from, to]
      inter_connected.each do |ic|
        in_network = @network[ic] & (inter_connected - [ic])
        next if in_network.size < size_min

        size_min = in_network.size
        connected << (network_current + [ic] + in_network).sort
      end
    end
  end

  connected.uniq
end

connected_candidates = find_interconnected_candidates
# p connected_candidates.size

max_size = connected_candidates.map(&:size).max
p max_size

connected_true = connected_candidates.select do |network_candidate|
  next unless network_candidate.size == max_size

  network_candidate.all? do |pc|
    @network[pc] & network_candidate == network_candidate - [pc]
  end
end

# p connected_true
p connected_true.first.join(',')
