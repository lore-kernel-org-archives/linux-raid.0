From: "Jonathan G. Underwood" <jonathan.underwood@gmail.com>
Subject: [PATCH] Add udev-md-raid-safe-timeouts.rules
Date: Fri, 26 Jan 2018 23:56:32 +0000
Message-ID: <20180126235632.8225-1-jonathan.underwood@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jonathan Underwood <jonathan.underwood@gmail.com>
List-Id: linux-raid.ids

From: Jonathan Underwood <jonathan.underwood@gmail.com>

These udev rules attempt to set a safe kernel controller
timeout for disks containing RAID level 1 or higher
partitions for commodity disks which do not have SCTERC
capability, or do have it but it is disabled.

No attempt is made to change the STCERC settings on devices
which support it.

This attempts to mitigate the problem described here:

    https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
    http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-timeouts/

where the kernel controller may timeout on a read from a
disk after the default timeout of 30 seconds and consequently
cause mdraid to regard the disk as dead and eject it from the
RAID array.

The mitigation is to set the timeout to 180 seconds for disks
which contain a RAID level 1 or higher partition.

Signed-off-by: Jonathan G. Underwood <jonathan.underwood@gmail.com>
---
 udev-md-raid-safe-timeouts.rules | 61 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 udev-md-raid-safe-timeouts.rules

diff --git a/udev-md-raid-safe-timeouts.rules b/udev-md-raid-safe-timeouts.rules
new file mode 100644
index 0000000..420c862
--- /dev/null
+++ b/udev-md-raid-safe-timeouts.rules
@@ -0,0 +1,61 @@
+# Copyright (C) 2017 by Jonathan G. Underwood
+# This file is part of mdraid-safe-timeouts.
+#
+# mdraid-safe-timeouts is free software: you can redistribute it
+# and/or modify it under the terms of the GNU General Public License
+# as published by the Free Software Foundation, either version 3 of
+# the License, or (at your option) any later version.
+#
+# Foobar is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with mdraid-safe-timeouts.  If not, see
+# <http://www.gnu.org/licenses/>.
+
+# This file causes block devices with Linux RAID (mdadm) signatures to
+# attempt to set safe timeouts for the drives involved
+# See udev(8) for syntax
+
+# Don't process any events if anaconda is running as anaconda brings up
+# raid devices manually
+ENV{ANACONDA}=="?*", GOTO="md_timeouts_end"
+
+SUBSYSTEM!="block|machinecheck", GOTO="md_timeouts_end"
+
+# "noiswmd" on kernel command line stops mdadm from handling
+# "isw" (aka IMSM - Intel RAID).
+# "nodmraid" on kernel command line stops mdadm from handling
+# "isw" or "ddf".
+IMPORT{cmdline}="nodmraid"
+ENV{nodmraid}=="?*", GOTO="md_timeouts_end"
+IMPORT{cmdline}="noiswmd"
+ENV{noiswmd}=="?*", GOTO="md_timeouts_end"
+
+# Set controller timeout for parent disk of each partition if the
+# partition is a mdraid partition of higher than raid 0, and the disk
+# doesn't have scterc turned on (i.e. if it's disabled or the disk
+# doesn't support it). We determine if the disk has SCTERC turned on
+# by examining the output of smartctl and seeing if it contains the
+# word "seconds". If the word "seconds" is found we take this to imply
+# STCERC is turned on, and take no action. Otherwise we set the drive
+# controller timeout to 180 seconds. It would be better to check the
+# exit status code of smartctl rather than grepping for "seconds", but
+# it's not clear what that will be in the three cases (supported and
+# turned on, supported but disabled, not supported).
+
+ENV{DEVTYPE}!="partition", GOTO="md_timeouts_end"
+
+IMPORT{program}="/sbin/mdadm --examine --export $devnode"
+
+ACTION=="add|change", \
+  ENV{ID_FS_TYPE}=="linux_raid_member", \
+  ENV{MD_LEVEL}=="raid[1-9]*", \
+  TEST=="/sys/block/$parent/device/timeout", \
+  TEST=="/usr/sbin/smartctl", \
+  PROGRAM!="/usr/bin/sh -c '/usr/sbin/smartctl -l scterc /dev/$parent | grep -q seconds && exit 0 || exit 1'", \
+  RUN+="/usr/bin/sh -c '/usr/bin/echo 180 > /sys/block/$parent/device/timeout && /usr/bin/logger timeout for /dev/$parent set to 180 secs'"
+
+LABEL="md_timeouts_end"
-- 
2.14.3

