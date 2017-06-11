native("jvm")
module addressbook.webapp "1.0.0" {
	import ceylon.interop.java "1.3.2";

	shared import java.base "8";
    shared import maven:"javax.servlet:javax.servlet-api" "3.1.0";
	shared import maven:"org.apache.wicket:wicket-core" "7.6.0";
}
