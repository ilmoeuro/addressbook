import org.jsimpledb { ... }

shared interface TransactionProvider {
    shared formal JTransaction newTransaction();
}