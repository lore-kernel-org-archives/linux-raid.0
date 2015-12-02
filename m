From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 01/17] udev rules and infrastructure for /dev/disk/by-slot
Date: Tue, 1 Dec 2015 16:25:17 -0800
Message-ID: <1449015933-255689-2-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@fb.com>

/dev/disk/by-path maps the device by its sysfs path, but uses
data not necessarily guaranteed to be static.  It also takes extra work
to map where the device is physically attached.
static data for creating the path name.

For example:

pci-0000:04:00.0-sas-0x500605b005846061:1:0-0x5000cca01a7c5606:0
phy_id------------------------------------^
end_device-sas_address----------------------^

...on mpt2sas 'phy_id' is a dynamically allocated number based on when
the port comes up.  There is no differentiation based on where the end
device is attached as the end device sas address is the only indication
of the exit point from the topology.

In contrast:
enclosure-0x5f80f41f1d6a60ff-slot9

...is a static name for this physical location in an enclosure.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Makefile                  |   3 +
 ses_slot_id               | 144 ++++++++++++++++++++++++++++++++++++++++++++++
 udev-enclosure-slot.rules |  13 +++++
 3 files changed, 160 insertions(+)
 create mode 100755 ses_slot_id
 create mode 100644 udev-enclosure-slot.rules

diff --git a/Makefile b/Makefile
index fde2e63..4eb2dad 100644
--- a/Makefile
+++ b/Makefile
@@ -110,6 +110,7 @@ LDLIBS=-ldl
 INSTALL = /usr/bin/install
 DESTDIR =
 BINDIR  = /sbin
+LIBDIR	= /lib/mdadm
 MANDIR  = /usr/share/man
 MAN4DIR = $(MANDIR)/man4
 MAN5DIR = $(MANDIR)/man5
@@ -292,6 +293,8 @@ install-man: mdadm.8 md.4 mdadm.conf.5 mdmon.8
 	$(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5
 
 install-udev: udev-md-raid-arrays.rules udev-md-raid-assembly.rules
+	$(INSTALL) -D -m 655 ses_slot_id $(DESTDIR)$(LIBDIR)/ses_slot_id
+	$(INSTALL) -D -m 644 udev-enclosure-slot.rules $(DESTDIR)$(UDEVDIR)/rules.d/62-md-enclosure-slot.rules
 	@for file in 63-md-raid-arrays.rules 64-md-raid-assembly.rules ; \
 	do sed -e 's,BINDIR,$(BINDIR),g' udev-$${file#??-} > .install.tmp.1 && \
 	   $(ECHO) $(INSTALL) -D -m 644 udev-$${file#??-} $(DESTDIR)$(UDEVDIR)/rules.d/$$file ; \
diff --git a/ses_slot_id b/ses_slot_id
new file mode 100755
index 0000000..629f1d1
--- /dev/null
+++ b/ses_slot_id
@@ -0,0 +1,144 @@
+#!/bin/sh
+
+# lookup ses slot information for a given device a /dev/disk/by-slot to
+# supplement the not-always-persistent path in the sas case
+# based on the the original shell script implementation of path_id
+
+SYSFS=/sys
+RESULT=1
+TYPE=
+OPWD="`pwd`"
+full_sysfs_path=
+full_sysfs_device_path=
+
+if [ -z "$DEVPATH" -a -z "$1" ] ; then
+	exit 1
+fi
+
+if [ -z "$DEVPATH" ] ; then
+	case "$1" in
+		$SYSFS/*)
+			DEVPATH="${1#$SYSFS}"
+			;;
+		*)
+			DEVPATH=$1
+			;;
+	esac
+fi
+
+if [ ! -e $SYSFS$DEVPATH/dev ] ; then
+	exit 1
+fi
+
+case "$DEVPATH" in
+	/devices/*)
+		cd "$SYSFS$DEVPATH/subsystem";
+		TYPE="`pwd -P`"
+		cd "$OPWD"
+		TYPE="${TYPE##*/}"
+		;;
+	/class/*)
+		TYPE="${DEVPATH#/class/}"
+		TYPE="${TYPE%%/*}"
+		;;
+	/block/*)
+		TYPE=block
+		;;
+	*)
+		exit 1
+		;;
+esac
+
+handle_ses () {
+	: handle_ses $*
+	local DEV=$1
+
+	ses_dev=$(find $DEV -maxdepth 1 -name 'enclosure_device:*' -print -quit)
+	ses_dev=$(readlink -f "$ses_dev")
+	enc_dev="${ses_dev%/*}"
+
+	if [ -f "$ses_dev/slot" ]; then
+		read slot < "$ses_dev/slot"
+	fi
+
+	if [ -f "$enc_dev/id" ]; then
+		read enclosure_id < "$enc_dev/id"
+	fi
+
+	if [ -z "$slot" -o -z "$enclosure_id" ]; then
+		: no enclosure device
+		D=
+		RESULT=1
+		return
+	fi
+
+	d="enclosure-${enclosure_id}-slot${slot}"
+	D=
+	RESULT=0
+}
+
+handle_device () {
+	full_sysfs_path="$SYSFS$DEVPATH"
+	case "$DEVPATH" in
+		/devices/*)
+			# new sysfs layout
+			if [ -L $full_sysfs_path/subsystem ]; then
+				full_sysfs_path="${full_sysfs_path%/*}"
+				cd "$full_sysfs_path/subsystem";
+				subsys="`pwd -P`"
+				cd "$OPWD"
+				subsys="${subsys##*/}"
+				if [ "$subsys" = "block" ]; then
+					# parent is "block", it's a partition, move one up
+				full_sysfs_path="${full_sysfs_path%/*}"
+				fi
+				cd $full_sysfs_path
+			fi
+			;;
+		*)
+			# old sysfs layout
+			if [ ! -L $full_sysfs_path/device ] ; then
+				if [ -f $full_sysfs_path/range ] ; then return ; fi
+				full_sysfs_path="${full_sysfs_path%/*}"
+				: full_sysfs_path "$full_sysfs_path"
+				if [ ! -L $full_sysfs_path/device -o ! -f $full_sysfs_path/dev ] ; then
+					return
+				fi
+			fi
+			cd $full_sysfs_path/device
+			;;
+	esac
+	full_sysfs_device_path="`pwd -P`"
+	cd "$OPWD"
+	D=$full_sysfs_device_path
+	while [ ! -z "$D" ] ; do
+		case "$D" in
+			*/end_device-[0-9]*:[0-9]*:[0-9]*/*)
+				handle_ses "$D"
+				if [ $RESULT = 0 ]; then
+					found_ses="yes"
+				fi
+				;;
+			*/devices)
+				D=
+				;;
+			*)
+				: not handled
+				RESULT=1
+				return
+				;;
+		esac
+	done
+}
+
+case "$TYPE" in
+	block)
+		handle_device
+		echo "ID_SLOT='$d'"
+		;;
+	*)
+		RESULT=1
+		;;
+esac
+
+exit $RESULT
diff --git a/udev-enclosure-slot.rules b/udev-enclosure-slot.rules
new file mode 100644
index 0000000..75c6376
--- /dev/null
+++ b/udev-enclosure-slot.rules
@@ -0,0 +1,13 @@
+# do not edit this file, it will be overwritten on update
+
+SUBSYSTEM!="block", GOTO="ses_slot_end"
+
+ACTION!="add|change", GOTO="ses_slot_end"
+KERNEL!="sd*", GOTO="ses_slot_end"
+
+# by-slot (parent device slot)
+ENV{DEVTYPE}=="disk", IMPORT{program}="/lib/mdadm/ses_slot_id %p"
+ENV{DEVTYPE}=="disk", ENV{ID_SLOT}=="?*", SYMLINK+="disk/by-slot/$env{ID_SLOT}"
+ENV{DEVTYPE}=="partition", ENV{ID_SLOT}=="?*", SYMLINK+="disk/by-slot/$env{ID_SLOT}-part%n"
+
+LABEL="ses_slot_end"
-- 
2.4.6

