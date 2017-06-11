native("jvm")
module addressbook.server "1.0.0" {
	shared import java.base "8";
	shared import ceylon.interop.java "1.3.2";
    shared import maven:"javax.servlet:javax.servlet-api" "3.1.0";
	shared import maven:"org.apache.wicket:wicket-core" "7.6.0";
	shared import maven:"org.eclipse.jetty:jetty-server" "9.4.0.v20161208";
	shared import maven:"org.eclipse.jetty:jetty-plus" "9.4.0.v20161208";
	shared import maven:"org.eclipse.jetty:jetty-annotations" "9.4.0.v20161208";
	shared import maven:"org.eclipse.jetty:jetty-util" "9.4.0.v20161208";
	shared import maven:"org.eclipse.jetty:jetty-rewrite" "9.4.0.v20161208";
	shared import maven:"org.eclipse.jetty:jetty-servlets" "9.4.0.v20161208";
    shared import addressbook.webapp "1.0.0";
}
