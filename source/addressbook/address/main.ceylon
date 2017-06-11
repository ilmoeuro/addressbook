import java.util { Set, NavigableMap, List, LinkedHashSet }
import java.util.stream { Collectors { toList } }
import org.jsimpledb { ... }
import org.jsimpledb.annotation { ... }
import org.jsimpledb.tuple { ... }
import org.jsimpledb.util { ... }

jSimpleClass
shared abstract class AddressBookEntry() satisfies JObject {
    jField__GETTER { indexed = true; }
    shared formal variable String firstName;
    jField__GETTER { indexed = true; }
    shared formal variable String lastName;
    jField__GETTER { indexed = true; }
    shared formal variable String email;
    jField__GETTER { indexed = true; }
    shared formal variable String address;
}

Iterable<Result> prefixSearch<Result>(
    String prefix,
    NavigableMap<String, Result> subject
) {
     object result satisfies Iterable<Result> {
         class ResultIterator() satisfies Iterator<Result> {
             variable String? key = subject.floorKey(prefix);

             shared actual Result|Finished next() {
                 if (exists k = key, k.startsWith(prefix)) {
                     key = subject.higherKey(k);
                     return subject.get(k);
                 } else {
                     return finished;
                 }
             }
         }
         iterator() => ResultIterator();
     }
     return result;
}

shared class AddressBook(JTransaction() tx) {
    Integer entriesPerPage = 10;
    shared variable String searchTerm = "";
    shared variable Integer currentPage = 1;
    
    shared List<AddressBookEntry> entries {
        void findEntries(Set<AddressBookEntry> entries, String field) {
            for (vals in prefixSearch(
                searchTerm,
                tx().queryIndex(`AddressBookEntry`, field, `String`).asMap())) {
                for (val in vals) {
                    entries.add(val);
                }
            }
        }
        
        if (searchTerm == "") {
            return tx()
                    .getAll(`AddressBookEntry`)
                    .stream()
                    .skip((currentPage-1) * entriesPerPage)
                    .limit(entriesPerPage)
                    .collect(toList<AddressBookEntry>());
        } else {
            value entries = LinkedHashSet<AddressBookEntry>();
            findEntries(entries, "firstName");
            findEntries(entries, "lastName");
            findEntries(entries, "email");
            findEntries(entries, "address");
            return entries
                    .stream()
                    .skip((currentPage-1) * entriesPerPage)
                    .limit(entriesPerPage)
                    .collect(toList<AddressBookEntry>());
        }
    }
    
    shared AddressBookEntry createEntry(
        String firstName,
        String lastName,
        String email,
        String address
    ) {
        AddressBookEntry entry = tx().create(`AddressBookEntry`);
        entry.firstName = firstName;
        entry.lastName = lastName;
        entry.email = email;
        entry.address = address;
        return entry;
    }
}