#generating sequence files from the text files
/home/newscontext/mahout/bin/mahout seqdirectory -i /home/newscontext/rails_projects/articles/classification/sskey/ -o /home/newscontext/mahout/examples/bin/clus/files-seqdir1 -ow

#generating vectors for the files
/home/newscontext/mahout/bin/mahout seq2sparse -i /home/newscontext/mahout/examples/bin/clus/files-seqdir1/ -o /home/newscontext/mahout/examples/bin/clus/files-sparse1 -wt TFIDF --maxDFPercent 85 --namedVector -ow 

#creating matrix representing vectors
/home/newscontext/mahout/bin/mahout rowid -i /home/newscontext/mahout/examples/bin/clus/files-sparse1/tfidf-vectors/part-* -o /home/newscontext/mahout/examples/bin/clus/clusmatrix

#finding similarity between files represented in matrix
/home/newscontext/mahout/bin/mahout rowsimilarity -i /home/newscontext/mahout/examples/bin/clus/clusmatrix/matrix -o /home/newscontext/mahout/examples/bin/clus/similarity -r 730 -s SIMILARITY_COSINE -m 2000 -ess --tempDir /home/newscontext/mahout/examples/bin/clus/tmp

#getting the similarity matrix of the files
/home/newscontext/mahout/bin/mahout seqdumper -s /home/newscontext/mahout/examples/bin/clus/similarity/part-* >/home/newscontext/mahout/examples/bin/clus/similaritydocs.txt

#mapping between the files and their representation in matrix
/home/newscontext/mahout/bin/mahout seqdumper -s /home/newscontext/mahout/examples/bin/clus/clusmatrix/docIndex >/home/newscontext/mahout/examples/bin/clus/docs.txt


