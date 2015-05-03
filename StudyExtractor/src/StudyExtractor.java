import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import org.apache.tika.Tika;
import org.apache.tika.io.TikaInputStream;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.parser.ParseContext;
import org.apache.tika.parser.isatab.ISArchiveParser;
import org.apache.tika.sax.BodyContentHandler;
import org.xml.sax.ContentHandler;

/**
 * StudyExtractor relies on Apache Tika in order to extract "Study Title" and 
 * "Study Description" fields from ISA-Tab files and then writes a file with 
 * the extracted contents for every study file. 
 * 
 */
public class StudyExtractor {
	public static final String ISATAB_TYPE = "application/x-isatab";

	public static void main(String[] args) throws IOException {
		if (args.length < 2) {
			System.err.println("Usage: " + StudyExtractor.class.getName() + " /path/to/input /path/to/output");
			System.exit(1);
		}
		
		File inputDir = new File(args[0]);
		File outputDir = new File(args[1]);
		
		if (!inputDir.isDirectory() || !outputDir.isDirectory()) {
			System.err.println("Error: input and output files must be directories!");
			System.exit(1);
		}
		
		processFiles(inputDir, outputDir);
	}
	
	public static void processFiles(File inputDir, File outputDir) throws IOException {
		ISArchiveParser parser = new ISArchiveParser();
		for (File file : inputDir.listFiles()) {
			if (file.isDirectory()) {
				processFiles(file, outputDir);
			}
			else {
				Tika tika = new Tika();
				if (!ISATAB_TYPE.equals(tika.detect(file))) {
					System.out.println("Skipping " + file.getName() + ". It is not a study file.");
					continue;
				}
				
				InputStream stream = TikaInputStream.get(file);
				ContentHandler handler = new BodyContentHandler();
				Metadata metadata = new Metadata();
				ParseContext context = new ParseContext();
				
				try {
					parser.parse(stream, handler, metadata, context);
				} catch (Exception e) {
					System.err.println(file.getName() + ": " + e.getMessage());
				} finally {
					stream.close();
				}
				
				String identifier = metadata.get("Study Identifier");
				String title = metadata.get("Study Title");
				String description = metadata.get("Study Description");
				
				if ((identifier == null) || (identifier.isEmpty())) {
					System.out.println("Skipping " + file.getName() + ". It does not contain a Study Identifier.");
					continue;
				}
				
				File output = new File(outputDir, identifier + ".txt");
				PrintWriter writer = new PrintWriter(output);
				writer.println(title);
				writer.print(description);
				writer.close();
			}
		}
	}
}
