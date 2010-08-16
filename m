From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 30/35] Man pages update with DOMAIN line description.
Date: Mon, 16 Aug 2010 11:01:58 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA18@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 9a769282fc4de770a877452242ac853dd2a6e051 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 10 Jun 2010 17:48:31 +0200
Subject: [PATCH 30/35] Man pages update with DOMAIN line description.

Old spare-groups replaced by domains.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 mdadm.8.in   |   23 +++++----
 mdadm.conf.5 |  146 ++++++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 135 insertions(+), 34 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index b2c90dc..a724e6e 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1850,7 +1850,9 @@ As well as reporting events,
 .I mdadm
 may move a spare drive from one array to another if they are in the
 same
-.B spare-group
+.B domain
+and
+.B subset
 and if the destination array has a failed drive but no spares.
 
 If any devices are listed on the command line,
@@ -1956,7 +1958,7 @@ notices that an array is degraded when it first sees the array.
 .TP
 .B MoveSpare
 A spare drive has been moved from one array in a
-.B spare-group
+.B domain
 to another to allow a failed drive to be replaced.
 (syslog priority: Info)
 
@@ -2007,18 +2009,19 @@ the second device is the array that the spare was moved from.
 For
 .I mdadm
 to move spares from one array to another, the different arrays need to
-be labeled with the same
-.B spare-group
-in the configuration file.  The
-.B spare-group
-name can be any string; it is only necessary that different spare
-groups use different names.
+belong to the same
+.B domain
+and
+.B subset.
+If there are no domains defined in configuration file, then spares can be
+shared between arrays with the same metadata type. Subsets reflect
+metadata specific constraints ex. hardware controllers. 
 
 When
 .I mdadm
-detects that an array in a spare group has fewer active
+detects that an array in a domain has fewer active
 devices than necessary for the complete array, and has no spare
-devices, it will look for another array in the same spare group that
+devices, it will look for another array in the same domain and subset that
 has a full complement of working drive and a spare.  It will then
 attempt to remove the spare from the second drive and add it to the
 first.
diff --git a/mdadm.conf.5 b/mdadm.conf.5
index e677ba9..0b320c4 100644
--- a/mdadm.conf.5
+++ b/mdadm.conf.5
@@ -169,18 +169,6 @@ starts or when
 is used.
 
 .TP
-.B spare\-group=
-The value is a textual name for a group of arrays.  All arrays with
-the same
-.B spare\-group
-name are considered to be part of the same group.  The significance of
-a group of arrays is that
-.I mdadm
-will, when monitoring the arrays, move a spare drive from one array in
-a group to another array in that group if the first array had a failed
-or missing drive but no spare.
-
-.TP
 .B auto=
 This option is rarely needed with mdadm-3.0, particularly if use with
 the Linux kernel v2.6.28 or later.
@@ -234,6 +222,122 @@ container the array is.  It will usually accompany a "container=" word.
 .RE
 
 .TP
+.B DOMAIN
+The
+.B domain
+line defines a set of devices determined by path and platform.
+The purpose of a domain is to guide:
+
+.B - Incremental
+mode - by specifying actions for hot-plug devices other than the default.
+
+.B - Create
+and
+.B Manage
+modes - by identifying configurations that breach policy. Eg. to create
+an array with devices from two different
+.BR domains,
+or to add a device from a given
+.B domain
+to an array which doesn't
+contain any devices from the
+.BR domain,
+.B force-
+prefix in action item is required.
+
+.B - Monitor
+mode
+- by allowing spare sharing within the same
+.B domain
+and
+.B subset.
+This makes spare-groups in
+.B ARRAY
+line obsolete.
+
+.B Subsets
+are parts of
+.B domain
+specific for hardware controllers and metadata spare groups.
+Spare migration happens only within a subset, and adding a device in one subset
+to an array that does not have a member in that subset also requires
+.BR --force.
+
+The available options in
+.B domain
+line are:
+.RS 4
+
+.TP
+.B path=
+Each
+.B domain
+line must have at least one valid
+.B path=
+entry.
+.B path=
+entries are file patterns and are matched against devices in /dev/disk/by-path.
+Each
+.B domain
+line can have more than one
+.BR path.
+The list of
+.B paths
+and the
+.B platform
+determine whether a device belongs to given
+.BR domain.
+
+.TP
+.B platform=
+This is metadata type for all devices in
+.BR domain.
+If
+.B platform=
+item is missing then the line describes four
+.B domains
+using the same
+.BR paths,
+one for each metadata type: 0.90, 1.x, ddf, imsm.
+
+.TP
+.B action=
+The
+.B action
+line indicates what kind of behaviour is allowed on hot-plug.
+Each
+.B domain
+line must have one and only one
+.B action=
+entry. In addition, each
+.B action
+may be prefixed with
+.B force-
+to indicate that we should skip certain safety checks.
+
+Valid action items are:
+.RS 8
+
+.TP
+.B ignore
+Means that any hotplugged device should be ignored.
+
+.TP
+.B incremental
+Means normal incremental assembly (the default).  If the device has
+metadata that matches an array then it is added to the array.
+
+.TP
+.B spare
+As incremental, additionally a spare record is written if it is a 'bare' device.
+
+.TP
+.B same_port_bare
+If a bare device is connected to the same port as previously removed device
+it is added as a spare to the array that the other device belonged to.
+.RE
+
+.TP
 .B MAILADDR
 The
 .B mailaddr
@@ -423,6 +527,12 @@ DEVICE /dev/sd[bcdjkl]1
 .br
 DEVICE /dev/hda1 /dev/hdb1
 
+# two imsm domains are defined 
+.br
+DOMAIN path=pci-0000:00:1f.2-scsi-[0-2]* platform=imsm action=incremental
+.br
+DOMAIN path=pci-0000:00:1f.2-scsi-[3-5]* platform=imsm action=spare
+
 # /dev/md0 is known by its UUID.
 .br
 ARRAY /dev/md0 UUID=3aaa0122:29827cfa:5331ad66:ca767371
@@ -437,18 +547,6 @@ ARRAY /dev/md1 superminor=1
 .br
 ARRAY /dev/md2 devices=/dev/hda1,/dev/hdb1
 
-# /dev/md4 and /dev/md5 are a spare-group and spares
-.br
-#  can be moved between them
-.br
-ARRAY /dev/md4 uuid=b23f3c6d:aec43a9f:fd65db85:369432df
-.br
-           spare\-group=group1
-.br
-ARRAY /dev/md5 uuid=19464854:03f71b1b:e0df2edd:246cc977
-.br
-           spare\-group=group1
-.br
 # /dev/md/home is created if need to be a partitionable md array
 .br
 # any spare device number is allocated.
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

