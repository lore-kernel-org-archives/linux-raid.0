From: Bob Hillegas <bobhillegas@houston.rr.com>
Subject: Patch to rc.sysint Fedora Core 2 resolving starting raid
	auto-detect during boot....
Date: Thu, 26 Aug 2004 20:40:33 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093570833.2398.99.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

After reading through the archives re: rc.sysint and starting raids 
at boot time, I ran across a patch written by Warren Togami
<wtogami@redhat.com>. 

After looking over what Warren had written, and comparing with the 
logic in my version of rc.sysint, I came up with the following diff.
It works for me.

I'm not sure this is the forum for this or who's interested, but at 
least this documents my resolution for the next one looking through
the archive.


Enjoy, BobH


--- /etc/rc.d/rc.sysinit.FC2	2004-07-12 14:36:51.000000000 -0500
+++ /etc/rc.d/rc.sysinit	2004-08-26 19:11:16.000000000 -0500
@@ -468,7 +468,7 @@
 fi
 
 update_boot_stage RCraid
-if [ -f /etc/raidtab ]; then
+if [ -f /etc/raidtab -o -f /etc/mdadm.conf ]; then
     # Add raid devices
     [ -f /proc/mdstat ] || modprobe md >/dev/null 2>&1
 
@@ -476,7 +476,39 @@
 	echo -n $"Starting up RAID devices: " 
 
 	rc=0
-	
+#--- <mdadm addition> ---------------------------------------------------------#
+      if [ -r /etc/mdadm.conf -a -s /etc/mdadm.conf ]; then
+        # parse mdadm.conf
+	for i in `awk '{if ($1=="ARRAY") print $2}' /etc/mdadm.conf`
+	do
+		RAIDDEV=`basename $i`
+                RAIDSTAT=`LC_ALL=C grep "^$RAIDDEV : active" /proc/mdstat`
+		if [ -z "$RAIDSTAT" ]; then
+			RESULT=1
+			INFSTAB=`LC_ALL=C grep -c "^$i" /etc/fstab`
+			if [ $INFSTAB -eq 0 ] ; then
+			    RESULT=0
+			    RAIDDEV="$RAIDDEV(skipped)"
+			fi
+			NOAUTO=`LC_ALL=C grep "^$i" /etc/fstab | LC_ALL=C fgrep -c "noauto"`
+			if [ $NOAUTO -gt 0 ]; then
+			    RESULT=0
+			    RAIDDEV="$RAIDDEV(skipped)"
+			fi
+			if [ $RESULT -gt 0 -a -x /sbin/mdadm ]; then
+			    /sbin/mdadm --assemble --scan
+			    rc=$?
+			fi
+			echo -n "$RAIDDEV "
+		else
+			echo -n "$RAIDDEV "
+		fi
+	done
+      fi
+#--- </mdadm addition> --------------------------------------------------------#
+
+      if [ -r /etc/raidtab -a -s /etc/raidtab ]; then	
+        # parse raidtab
 	for i in `awk '{if ($1=="raiddev") print $2}' /etc/raidtab`
 	do
 		RAIDDEV=`basename $i`
@@ -520,7 +552,8 @@
 			echo -n "$RAIDDEV "
 		fi
 	done
-	echo
+      fi
+      echo
 
 	# A non-zero return means there were problems.
 	if [ $rc -gt 0 ]; then
-- 
Bob Hillegas <bobhillegas@houston.rr.com>
