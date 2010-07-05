From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 25/33] Man pages update with DOMAIN line description.
Date: Mon, 5 Jul 2010 11:49:47 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC425@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C4C@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C4C@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:39 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 25/33] Man pages update with DOMAIN line description.

Old spare-groups replaced by domains.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
=A0mdadm.8.in=A0=A0 |=A0=A0 23 +++++----
=A0mdadm.conf.5 |=A0 146 ++++++++++++++++++++++++++++++++++++++++++++++=
++----------
=A02 files changed, 135 insertions(+), 34 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index b2c90dc..a724e6e 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1850,7 +1850,9 @@ As well as reporting events,=A0 .I mdadm=A0 may m=
ove a spare drive from one array to another if they are in the=A0 same =
-.B spare-group
+.B domain
+and
+.B subset
=A0and if the destination array has a failed drive but no spares.
=A0
=A0If any devices are listed on the command line, @@ -1956,7 +1958,7 @@=
 notices that an array is degraded when it first sees the array.
=A0.TP
=A0.B MoveSpare
=A0A spare drive has been moved from one array in a -.B spare-group
+.B domain
=A0to another to allow a failed drive to be replaced.
=A0(syslog priority: Info)
=A0
@@ -2007,18 +2009,19 @@ the second device is the array that the spare w=
as moved from.
=A0For
=A0.I mdadm
=A0to move spares from one array to another, the different arrays need =
to -be labeled with the same -.B spare-group -in the configuration file=
=2E=A0 The -.B spare-group -name can be any string; it is only necessar=
y that different spare -groups use different names.
+belong to the same
+.B domain
+and
+.B subset.
+If there are no domains defined in configuration file, then spares can=
=20
+be shared between arrays with the same metadata type. Subsets reflect=20
+metadata specific constraints ex. hardware controllers.
=A0
=A0When
=A0.I mdadm
-detects that an array in a spare group has fewer active
+detects that an array in a domain has fewer active
=A0devices than necessary for the complete array, and has no spare -dev=
ices, it will look for another array in the same spare group that
+devices, it will look for another array in the same domain and subset=20
+that
=A0has a full complement of working drive and a spare.=A0 It will then=A0=
 attempt to remove the spare from the second drive and add it to the=A0=
 first.
diff --git a/mdadm.conf.5 b/mdadm.conf.5 index e677ba9..0b320c4 100644
--- a/mdadm.conf.5
+++ b/mdadm.conf.5
@@ -169,18 +169,6 @@ starts or when
=A0is used.
=A0
=A0.TP
-.B spare\-group=3D
-The value is a textual name for a group of arrays.=A0 All arrays with =
-the same -.B spare\-group -name are considered to be part of the same =
group.=A0 The significance of -a group of arrays is that -.I mdadm -wil=
l, when monitoring the arrays, move a spare drive from one array in -a =
group to another array in that group if the first array had a failed -o=
r missing drive but no spare.
-
-.TP
=A0.B auto=3D
=A0This option is rarely needed with mdadm-3.0, particularly if use wit=
h=A0 the Linux kernel v2.6.28 or later.
@@ -234,6 +222,122 @@ container the array is.=A0 It will usually accomp=
any a "container=3D" word.
=A0.RE
=A0
=A0.TP
+.B DOMAIN
+The
+.B domain
+line defines a set of devices determined by path and platform.
+The purpose of a domain is to guide:
+
+.B - Incremental
+mode - by specifying actions for hot-plug devices other than the defau=
lt.
+
+.B - Create
+and
+.B Manage
+modes - by identifying configurations that breach policy. Eg. to creat=
e=20
+an array with devices from two different .BR domains, or to add a=20
+device from a given .B domain to an array which doesn't contain any=20
+devices from the .BR domain, .B force- prefix in action item is=20
+required.
+
+.B - Monitor
+mode
+- by allowing spare sharing within the same .B domain and .B subset.
+This makes spare-groups in
+.B ARRAY
+line obsolete.
+
+.B Subsets
+are parts of
+.B domain
+specific for hardware controllers and metadata spare groups.
+Spare migration happens only within a subset, and adding a device in=20
+one subset to an array that does not have a member in that subset also=
=20
+requires .BR --force.
+
+The available options in
+.B domain
+line are:
+.RS 4
+
+.TP
+.B path=3D
+Each
+.B domain
+line must have at least one valid
+.B path=3D
+entry.
+.B path=3D
+entries are file patterns and are matched against devices in /dev/disk=
/by-path.
+Each
+.B domain
+line can have more than one
+.BR path.
+The list of
+.B paths
+and the
+.B platform
+determine whether a device belongs to given .BR domain.
+
+.TP
+.B platform=3D
+This is metadata type for all devices in .BR domain.
+If
+.B platform=3D
+item is missing then the line describes four .B domains using the same=
=20
+.BR paths, one for each metadata type: 0.90, 1.x, ddf, imsm.
+
+.TP
+.B action=3D
+The
+.B action
+line indicates what kind of behaviour is allowed on hot-plug.
+Each
+.B domain
+line must have one and only one
+.B action=3D
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
+Means normal incremental assembly (the default).=A0 If the device has=20
+metadata that matches an array then it is added to the array.
+
+.TP
+.B spare
+As incremental, additionally a spare record is written if it is a 'bar=
e' device.
+
+.TP
+.B same_port_bare
+If a bare device is connected to the same port as previously removed=20
+device it is added as a spare to the array that the other device belon=
ged to.
+.RE
+
+.TP
=A0.B MAILADDR
=A0The
=A0.B mailaddr
@@ -423,6 +527,12 @@ DEVICE /dev/sd[bcdjkl]1=A0 .br=A0 DEVICE /dev/hda1=
 /dev/hdb1
=A0
+# two imsm domains are defined
+.br
+DOMAIN path=3Dpci-0000:00:1f.2-scsi-[0-2]* platform=3Dimsm=20
+action=3Dincremental .br DOMAIN path=3Dpci-0000:00:1f.2-scsi-[3-5]*=20
+platform=3Dimsm action=3Dspare
+
=A0# /dev/md0 is known by its UUID.
=A0.br
=A0ARRAY /dev/md0 UUID=3D3aaa0122:29827cfa:5331ad66:ca767371
@@ -437,18 +547,6 @@ ARRAY /dev/md1 superminor=3D1=A0 .br=A0 ARRAY /dev=
/md2 devices=3D/dev/hda1,/dev/hdb1
=A0
-# /dev/md4 and /dev/md5 are a spare-group and spares -.br -#=A0 can be=
 moved between them -.br -ARRAY /dev/md4 uuid=3Db23f3c6d:aec43a9f:fd65d=
b85:369432df
-.br
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spare\-group=3Dgroup1
-.br
-ARRAY /dev/md5 uuid=3D19464854:03f71b1b:e0df2edd:246cc977
-.br
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spare\-group=3Dgroup1
-.br
=A0# /dev/md/home is created if need to be a partitionable md array=A0 =
=2Ebr=A0 # any spare device number is allocated.
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
