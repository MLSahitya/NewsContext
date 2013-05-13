l=20
i=40
c=0
n=5
prev=Array(6)
nex=Array(6)
while c<=n
s=l+(c*i)
prev[c]=s
c=c+1
end
l=100
i=20
c=0
while c<=n
s=l+(c*i)
nex[c]=s
c=c+1
end

#puts prev
#puts nex
prev=nex-prev
puts prev
puts prev.length
