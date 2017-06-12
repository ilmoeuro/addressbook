import ceylon.test {
    ...
}
import ceylon.test.annotation {
    ...
}
import org.jsimpledb {
    ...
}

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