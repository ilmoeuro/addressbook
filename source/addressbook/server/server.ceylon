import ceylon.interop.java { ... }
import java.net { ... }
import java.lang { System }
import javax.servlet { ... }
import javax.servlet.annotation { ... }
import org.eclipse.jetty.annotations { ... }
import org.eclipse.jetty.util.resource { JettyResource = Resource }
import org.eclipse.jetty.plus.webapp { ... }
import org.eclipse.jetty.server { ... }
import org.eclipse.jetty.webapp { ... }

"Run the module `server`."
shared void run() {
    Integer port = 8888;
    Server server = Server(port);
    
    WebAppContext context = WebAppContext();
    context.baseResource = JettyResource.newClassPathResource("/webapp/");
    context.configurations = createJavaObjectArray<Configuration> {
        JettyWebXmlConfiguration(),
        WebInfConfiguration(), 
        WebXmlConfiguration(),
        MetaInfConfiguration(), 
        FragmentConfiguration(), 
        EnvConfiguration(),
        PlusConfiguration()
    };
        
    context.contextPath = "/";
    context.parentLoaderPriority = true;
    server.handler = context;
    server.start();
    server.dump(System.err);
    server.join();
}