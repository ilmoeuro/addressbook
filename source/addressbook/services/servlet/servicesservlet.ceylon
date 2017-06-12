import java.io { ... }
import java.lang { System { nanoTime } }
import javax.servlet { ... }
import javax.servlet.annotation { ... }
import org.jsimpledb { ... }
import org.jsimpledb.annotation { ... }
import org.jsimpledb.core { ... }
import org.jsimpledb.kv { ... }
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
    shared actual void contextInitialized(ServletContextEvent? event) {
        database = JSimpleDBFactory()
            .setSchemaVersion(-1)
            .newJSimpleDB();
    }

    shared actual void contextDestroyed(ServletContextEvent? event) {
    }
}