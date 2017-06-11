import java.io { ... }
import java.lang { System { nanoTime } }
import javax.servlet { ... }
import javax.servlet.annotation { ... }
import org.jsimpledb { ... }
import org.jsimpledb.annotation { ... }
import org.jsimpledb.core { ... }
import org.jsimpledb.kv { ... }
import org.jsimpledb.kv.bdb { ... }
import addressbook.services.definition { TransactionProvider }

variable JSimpleDB? database = null;

service (`interface TransactionProvider`)
shared class ServletTransactionProvider() satisfies TransactionProvider {
    shared actual JTransaction newTransaction() {
        "Database is initialized"
        assert(exists db = database);
        return db.createTransaction(true, ValidationMode.automatic);
    }
}

webListener
shared class ServicesListener() satisfies ServletContextListener {
    value bdb = BerkeleyKVDatabase();
    value file = File.createTempFile("bdb-``nanoTime()``", null);
    assert(file.delete());
    assert(file.mkdir());
    bdb.directory = file;

    shared actual void contextInitialized(ServletContextEvent? event) {
        bdb.start();

        database = JSimpleDBFactory()
            .setDatabase(Database(bdb))
            .setSchemaVersion(-1)
            .newJSimpleDB();
    }

    shared actual void contextDestroyed(ServletContextEvent? event) {
        bdb.stop();
    }
}