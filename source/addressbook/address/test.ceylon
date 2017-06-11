import java.util { TreeMap }
import ceylon.interop.java { JavaComparator }
import ceylon.test { ... }
import ceylon.test.annotation { ... }
import org.jsimpledb { ... }

JavaComparator<String> stringComparator
        = JavaComparator<String>((s1, s2) => s1.compare(s2));

void inTransaction(Anything(JTransaction) func) {
    value db = JSimpleDBFactory()
        .setModelClasses(`AddressBookEntry`)
        .setSchemaVersion(-1)
        .newJSimpleDB();
    value tx = db.createTransaction(true, ValidationMode.automatic);
    try {
        func(tx);
    } finally {
        tx.rollback();
    }
}

test
void searchNoPrefixEntries() {
    value subject = TreeMap<String, String>(stringComparator);
    subject.put("b", "b");
    value actual = prefixSearch("a", subject);
    assert (actual.empty);
}

test
void searchSinglePrefixEntry() {
    value subject = TreeMap<String, String>(stringComparator);
    subject.put("a", "a");
    value actual = prefixSearch("a", subject);
    assert (actual.size == 1);
}


test
void searchSinglePrefixEntryWithMiss() {
    value subject = TreeMap<String, String>(stringComparator);
    subject.put("a", "a");
    subject.put("b", "b");
    value actual = prefixSearch("a", subject);
    assert (actual.size == 1);
}

test
void searchMultiplePrefixEntries() {
    value subject = TreeMap<String, String>(stringComparator);
    subject.put("a", "a");
    subject.put("aa", "aa");
    subject.put("aaa", "aaa");
    subject.put("ab", "ab");
    value actual = prefixSearch("a", subject);
    assert (actual.size == 4);
}

test
void searchMultiplePrefixEntriesWithMisses() {
    value subject = TreeMap<String, String>(stringComparator);
    subject.put("a", "a");
    subject.put("aa", "aa");
    subject.put("aaa", "aaa");
    subject.put("ab", "ab");
    subject.put("b", "b");
    subject.put("bb", "bb");
    value actual = prefixSearch("a", subject);
    assert (actual.size == 4);
}

test
void createNewAddressBookEntry() {
    inTransaction((tx) {
        value ab = AddressBook(() => tx);
        value entry = ab.createEntry("a", "b", "c", "d");
        assert(entry.firstName == "a");
        assert(entry.lastName == "b");
        assert(entry.email == "c");
        assert(entry.address == "d");
    });
}

test
void findAddressBookEntries() {
    inTransaction((tx) {
        value ab = AddressBook(() => tx);
        ab.createEntry("a", "b", "c", "d");
        value entries = ab.entries;
        assert(entries.size() == 1);
    });
}

test
void findAddressBookEntriesByPrefix() {
    inTransaction((tx) {
        value ab = AddressBook(() => tx);
        ab.createEntry("a", "x", "y", "z");
        ab.createEntry("aa", "x", "y", "z");
        ab.createEntry("ab", "x", "y", "z");
        ab.createEntry("ac", "x", "y", "z");
        ab.createEntry("b", "x", "y", "z");
        ab.createEntry("c", "x", "y", "z");
        ab.searchTerm = "a";
        value entries = ab.entries;
        assert(entries.size() == 4);
    });
}


shared void run() {
     print(createTestRunner([`module addressbook.address`]).run());
}