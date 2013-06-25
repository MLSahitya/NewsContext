MAHOUT_PATH="/home/newscontext/mahout" 
PROJECT_PATH="/home/newscontext/rails_projects/articles"

#generating sequence files from the text files
$MAHOUT_PATH/bin/mahout seqdirectory -i $PROJECT_PATH/app/assets/classification/sskey/ -o $PROJECT_PATH/clus/files-seqdir -ow

#generating vectors for the files
$MAHOUT_PATH/bin/mahout seq2sparse -i $PROJECT_PATH/clus/files-seqdir/ -o $PROJECT_PATH/clus/files-sparse -wt TFIDF --maxDFPercent 85 --namedVector -ow 

#creating matrix representing vectors
$MAHOUT_PATH/bin/mahout rowid -i $PROJECT_PATH/clus/files-sparse/tfidf-vectors/part-* -o $PROJECT_PATH/clus/clusmatrix

#finding similarity between files represented in matrix
$MAHOUT_PATH/bin/mahout rowsimilarity -i $PROJECT_PATH/clus/clusmatrix/matrix -o $PROJECT_PATH/clus/similarity -r 730 -s SIMILARITY_COSINE -m 2000 -ess --tempDir $PROJECT_PATH/clus/tmp

#getting the similarity matrix of the files
$MAHOUT_PATH/bin/mahout seqdumper -s $PROJECT_PATH/clus/similarity/part-* >$PROJECT_PATH/clus/similaritydocs.txt

#mapping between the files and their representation in matrix
$MAHOUT_PATH/bin/mahout seqdumper -s $PROJECT_PATH/clus/clusmatrix/docIndex >$PROJECT_PATH/clus/docs.txt


