native("jvm")
module addressbook.services.servlet "1.0.0" {
	shared import java.base "8";
    shared import maven:"javax.servlet:javax.servlet-api" "3.1.0";
	shared import maven:"org.jsimpledb:jsimpledb-main" "3.4.0";
    shared import "addressbook.services.definition" "1.0.0";
}
