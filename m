From: Andre Majorel <aym-xunil@teaser.fr>
Subject: Man page patch (bold font for option names in MISC MODE section)
Date: Sun, 14 Jan 2007 14:56:20 +0100
Message-ID: <20070114135620.GA18756@aym.net2.nerim.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

In the MISC MODE section in mdadm(8), the names of the options
should be in bold.

-- 
André Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.

--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-2.6-man1.diff"

In the MISC MODE section in mdadm(8), the names of the options should be
in bold.

  -- AYM 2007-01-14

diff -ur mdadm-2.6/mdadm.8 mdadm-2.6-man1/mdadm.8
--- mdadm-2.6/mdadm.8	2006-12-21 07:11:01.000000000 +0100
+++ mdadm-2.6-man1/mdadm.8	2007-01-14 14:50:25.000000000 +0100
@@ -1363,14 +1363,14 @@
 MISC mode includes a number of distinct operations that
 operate on distinct devices.  The operations are:
 .TP
---query
+.B --query
 The device is examined to see if it is
 (1) an active md array, or
 (2) a component of an md array.
 The information discovered is reported.
 
 .TP
---detail
+.B --detail
 The device should be an active md device.
 .B   mdadm
 will display a detailed description of the array.
@@ -1404,7 +1404,7 @@
 .RE
 
 .TP
---examine
+.B --examine
 The device should be a component of an md array.
 .B mdadm
 will read the md superblock of the device and display the contents.
@@ -1423,27 +1423,27 @@
 config file to be examined.
 
 .TP
---stop
+.B --stop
 The devices should be active md arrays which will be deactivated, as
 long as they are not currently in use.
 
 .TP
---run
+.B --run
 This will fully activate a partially assembled md array.
 
 .TP
---readonly
+.B --readonly
 This will mark an active array as read-only, providing that it is
 not currently being used.
 
 .TP
---readwrite
+.B --readwrite
 This will change a
 .B readonly
 array back to being read/write.
 
 .TP
---scan
+.B --scan
 For all operations except
 .BR --examine ,
 .B --scan

--mYCpIKhGyMATD0i+--
