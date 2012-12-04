Build Status Screen Saver
=========================

This is a simple screen saver that reads an XML file from a continuous
integration server.

This has been created to fulfill a need at a previous employer (IOOF).
We were running big visible wall, but our security policies would start
screen saver after 5 minutes and hide the status of the build.

As a solution, I built this simple screen saver in Delphi.

The screen saver reads an XML file via HTTP or file URL to display the
current status and most recent success or failure of your build
projects. The initial version uses an XML file conforming to the ccTray
format.

The design of this has been kept to the minimum of basic Delphi controls.
The only third party libraries used are OmniXML and FastMM4.
