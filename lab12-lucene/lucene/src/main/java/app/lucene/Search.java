package app.lucene;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.StoredFields;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.io.IOException;
import java.nio.file.Paths;

public class Search {
    public static void main(String[] args) {
        String querystr = "Lucene";

        try(Directory directory = FSDirectory.open(Paths.get(Index.INDEX_DIRECTORY))) {
            StandardAnalyzer analyzer = new StandardAnalyzer();
            try (IndexReader reader = DirectoryReader.open(directory)) {
                IndexSearcher searcher = new IndexSearcher(reader);

                Query q = new QueryParser("title", analyzer).parse(querystr);
                int maxHits = 10;
                TopDocs docs = searcher.search(q, maxHits);
                ScoreDoc[] hits = docs.scoreDocs;

                System.out.println("Found " + hits.length + " matching docs.");
                StoredFields storedFields = searcher.storedFields();
                for (int i = 0; i < hits.length; ++i) {
                    int docId = hits[i].doc;
                    Document d = storedFields.document(docId);
                    System.out.println((i + 1) + ". " + d.get("isbn") + "\t" + d.get("title"));
                }
            } catch (IOException | ParseException e) {
                throw new RuntimeException(e);
            }
        }catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
