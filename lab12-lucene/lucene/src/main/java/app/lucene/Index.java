package app.lucene;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.io.IOException;
import java.net.URI;
import java.nio.file.Paths;

public class Index {
    public static final String INDEX_DIRECTORY = "./index";

    public static void main(String[] args) {

        try (Directory directory = FSDirectory.open(Paths.get(INDEX_DIRECTORY))) {
            StandardAnalyzer analyzer = new StandardAnalyzer();
            IndexWriterConfig config = new IndexWriterConfig(analyzer);
            try (IndexWriter w = new IndexWriter(directory, config)) {
                w.addDocument(Index.buildDoc("Lucene in Action", "9781473671911"));
                w.addDocument(Index.buildDoc("Lucene for Dummies", "9780735219090"));
                w.addDocument(Index.buildDoc("Managing Gigabytes", "9781982131739"));
                w.addDocument(Index.buildDoc("The Art of Computer Science", "9781250301695"));
                w.addDocument(Index.buildDoc("Dummy and yummy title", "9780525656161"));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static Document buildDoc(String title, String isbn) {
        Document doc = new Document();
        doc.add(new TextField("title", title, Field.Store.YES));
        doc.add(new StringField("isbn", isbn, Field.Store.YES));
        return doc;
    }
}
