From: <robin-lists@robinbowes.com>
Subject: Raidtools vs. mdadm?
Date: Thu, 22 Jul 2004 20:05:35 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S266871AbUGVTFi/20040722190538Z+2544@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've been using mdadm to create and manage my RAID devices (RAID1 and
RAID5).

I've not really given much thought to how they are started at boot time -
they just are!

On Fedora Core 2, RAID devics are started from /etc/rc.d/rc.sysinit. The
default install used raidtools to start the arrays, but I have patched
rc.sysinit with the following patch:

--- rc.sysinit.orig     2004-02-04 01:42:10.000000000 -0600
+++ rc.sysinit  2004-02-04 02:26:45.000000000 -0600
@@ -435,6 +435,10 @@
        /etc/rc.modules
 fi

+if [ -f /etc/mdadm.conf ]; then
+       /sbin/mdadm -A -s
+fi
+
 update_boot_stage RCraid
 if [ -f /etc/raidtab ]; then
        # Add raid devices
@@ -467,6 +471,10 @@
                                RESULT=0
                                RAIDDEV="$RAIDDEV(skipped)"
                        fi
+                       if [ $RESULT -gt 0 -a -x /sbin/mdadm ]; then
+                               /sbin/mdadm -Ac partitions $i -m dev
+                               RESULT=$?
+                       fi
                        if [ $RESULT -gt 0 -a -x /sbin/raidstart ]; then
                                /sbin/raidstart $i
                                RESULT=$?


So, my question is: do I still need raidtools? Does it do anything that
mdadm can't?

Thanks,

R.

--
http://robinbowes.com 

