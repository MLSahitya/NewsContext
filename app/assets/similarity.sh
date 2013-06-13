/home/newscontext/mahout/bin/mahout seqdirectory -i /home/newscontext/rails_projects/articles/classification/sskey/ -o /home/newscontext/mahout/examples/bin/clus/files-seqdir1 -ow

/home/newscontext/mahout/bin/mahout seq2sparse -i /home/newscontext/mahout/examples/bin/clus/files-seqdir1/ -o /home/newscontext/mahout/examples/bin/clus/files-sparse1 -wt TFIDF --maxDFPercent 85 --namedVector -ow 

/home/newscontext/mahout/bin/mahout rowid -i /home/newscontext/mahout/examples/bin/clus/files-sparse1/tfidf-vectors/part-* -o /home/newscontext/mahout/examples/bin/clus/clusmatrix

/home/newscontext/mahout/bin/mahout rowsimilarity -i /home/newscontext/mahout/examples/bin/clus/clusmatrix/matrix -o /home/newscontext/mahout/examples/bin/clus/similarity -r 730 -s SIMILARITY_COSINE -m 2000 -ess --tempDir /home/newscontext/mahout/examples/bin/clus/tmp

/home/newscontext/mahout/bin/mahout seqdumper -s /home/newscontext/mahout/examples/bin/clus/similarity/part-* >/home/newscontext/mahout/examples/bin/clus/similaritydocs.txt

/home/newscontext/mahout/bin/mahout seqdumper -s /home/newscontext/mahout/examples/bin/clus/clusmatrix/docIndex >/home/newscontext/mahout/examples/bin/clus/docs.txt


