import difflib as dl

s1 = 'evil'
s2 = 'live'
seq_matcher = dl.SequenceMatcher(None, s1, s2)
seq_matcher2 = dl.SequenceMatcher(None, s2, s1)

print(seq_matcher)
print(seq_matcher2)
