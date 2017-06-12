import java.lang {
    ByteArray
}
import java.util {
    JList = List,
    NavigableSet
}
import java.util.stream {
    Collectors {
        toList
    }
}
import org.jsimpledb { ... }
import org.jsimpledb.annotation { ... }
import org.jsimpledb.tuple { ... }
import org.jsimpledb.util {
    NavigableSets { union }
}
import ceylon.buffer.charset {
    utf8
}
import ceylon.interop.java {
    createJavaByteArray,
    javaClass
}

jSimpleClass
shared abstract class AddressBookEntry() satisfies JObject {
	// Store fields as utf8 arrays to enable prefix queries
    jField__GETTER { indexed = true; }
    shared formal variable ByteArray firstNameField;
    jField__GETTER { indexed = true; }
    shared formal variable ByteArray lastNameField;
    jField__GETTER { indexed = true; }
    shared formal variable ByteArray emailField;
    jField__GETTER { indexed = true; }
    shared formal variable ByteArray addressField;
    
    shared String firstName => utf8.decode(firstNameField.iterable);
    assign firstName {
        firstNameField = createJavaByteArray(utf8.encode(firstName));
    }

    shared String lastName => utf8.decode(lastNameField.iterable);
    assign lastName {
        lastNameField = createJavaByteArray(utf8.encode(lastName));
    }

    shared String email => utf8.decode(emailField.iterable);
    assign email {
        emailField = createJavaByteArray(utf8.encode(email));
    }
    
    shared String address => utf8.decode(addressField.iterable);
    assign address {
        addressField = createJavaByteArray(utf8.encode(address));
    }
    
    string => "AddressBookEntry(``firstName``, ``lastName``, ``email``, ``address``)";
}

shared NavigableSet<T> indexLookup<T>(
    JTransaction tx,
    String index,
    String prefix
) given T satisfies Object {
    List<Byte> fromKey = utf8.encode(prefix);
    // UTF-8 can't contain 0xFF's, so this is safe
    List<Byte> toKey = fromKey.mapElements((i, b) =>
                                                i == fromKey.size - 1
                                                then b + 1.byte
                                                else b);
    return union(tx
        .queryIndex(javaClass<T>(), index, javaClass<ByteArray>())
        .asMap()
        .subMap(createJavaByteArray(fromKey), createJavaByteArray(toKey))
        .values());
}


shared class AddressBook(JTransaction() tx) {
    Integer entriesPerPage = 10;
    shared variable String searchTerm = "";
    shared variable Integer currentPage = 1;
    
    shared JList<AddressBookEntry> entries {
        if (searchTerm == "") {
            return tx()
                    .getAll(`AddressBookEntry`)
                    .stream()
                    .skip((currentPage-1) * entriesPerPage)
                    .limit(entriesPerPage)
                    .collect(toList<AddressBookEntry>());
        } else {
            value entries = union(
                indexLookup<AddressBookEntry>(tx(), "firstNameField", searchTerm),
                indexLookup<AddressBookEntry>(tx(), "lastNameField", searchTerm),
                indexLookup<AddressBookEntry>(tx(), "emailField", searchTerm),
                indexLookup<AddressBookEntry>(tx(), "addressField", searchTerm)
            );
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