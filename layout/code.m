def distance(p1, p2):
    return ((p2.x - p1.x) ** 2 + (p2.y - p1.y) ** 2) ** 0.5

line_segments = vertical_segments + horizontal_segments
max_distance = 20
chains = []
used_segments = []

for segment1 in line_segments:
    if segment1 in used_segments:
        continue
    chain = [segment1]
    used_segments.append(segment1)
    chain_growing = True

    while chain_growing:
        chain_growing = False
        for segment2 in line_segments:
            if segment2 in used_segments:
                continue
            for chain_segment in chain:
                if (
                    distance(chain_segment.p1, segment2.p1) <= max_distance or
                    distance(chain_segment.p1, segment2.p2) <= max_distance or
                    distance(chain_segment.p2, segment2.p1) <= max_distance or
                    distance(chain_segment.p2, segment2.p2) <= max_distance
                ):
                    chain.append(segment2)
                    used_segments.append(segment2)
                    chain_growing = True
                    break
            if chain_growing:
                break
    chains.append(chain)

print(f"Found {len(chains)} chains")

# Find endpoints of chains

chain_endpoints = []
for chain in chains:
    endpoints = []
    for segment in chain:
        for point in segment:
            if all(distance(point, other_point) > max_distance for other_segment in chain for other_point in other_segment if point != other_point):
                endpoints.append(point)
    chain_endpoints.append(endpoints)

print(f"Found {sum(len(endpoints) for endpoints in chain_endpoints)} endpoints")

# Sort chains

sorted_chains = []
for index, chain in enumerate(chains):
    if not chain_endpoints[index]:
        sorted_chains.append(chain)
        continue
    start_point = chain_endpoints[index][0]
    sorted_chain = [start_point]
    remaining_segments = chain[:]

    while remaining_segments:
        last_point = sorted_chain[-1]
        next_segment = min(
            remaining_segments,
            key=lambda seg: min(distance(last_point, seg.p1), distance(last_point, seg.p2))
        )
        remaining_segments.remove(next_segment)
        if distance(last_point, next_segment.p1) < distance(last_point, next_segment.p2):
            if next_segment.p1 != last_point:
                sorted_chain.append(next_segment.p1)
            sorted_chain.append(next_segment.p2)
        else:
            if next_segment.p2 != last_point:
                sorted_chain.append(next_segment.p2)
            sorted_chain.append(next_segment.p1)
    sorted_chains.append(sorted_chain)