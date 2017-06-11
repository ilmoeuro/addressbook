import java.lang { ... }
import javax.servlet { ... }
import javax.servlet.annotation { ... }
import ceylon.interop.java { ... }
import org.apache.wicket { ... }
import org.apache.wicket.markup.html { ... }
import org.apache.wicket.protocol.http { ... }

shared class AddressBookPage() extends WebPage() {
    
}

shared class AddressBookApplication() extends WebApplication() {
    shared actual Class<out Page> homePage => javaClass<AddressBookPage>();
}

webFilter {
    ["/*"];
    initParams = [
        webInitParam {
            name = "applicationClassName";
            "addressbook.webapp.AddressBookFilter";
        },
        webInitParam {
            name = "filterMappingUrlPattern";
            "/*";
        }
    ];
}
shared class AddressBookFilter() extends WicketFilter() {

}