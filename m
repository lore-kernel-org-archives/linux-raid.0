From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 1/8] mdadm/test: correct the logic operation in save_log
Date: Tue, 16 Jan 2018 17:45:02 +0800
Message-ID: <1516095909-12968-2-git-send-email-zlliu@suse.com>
References: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

1. delete the mdadm -As, keep the original testing scene intact.
2. move some actions into 'array' test, 'mdadm -D $array' would
   complain errors if $array is null.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 test | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/test b/test
index e74bbe5..eb67ef5 100755
--- a/test
+++ b/test
@@ -59,16 +59,11 @@ save_log() {
 	cp $targetdir/log $logdir/$_basename.log
 	echo "## $HOSTNAME: saving dmesg." >> $logdir/$logfile
 	dmesg -c >> $logdir/$logfile
-	$mdadm -As 2> /dev/null
 	echo "## $HOSTNAME: saving proc mdstat." >> $logdir/$logfile
 	cat /proc/mdstat >> $logdir/$logfile
 	array=($(mdadm -Ds | cut -d' ' -f2))
-	echo "## $HOSTNAME: mdadm -D ${array[@]}" >> $logdir/$logfile
-	$mdadm -D ${array[@]} >> $logdir/$logfile
 	[ "$1" == "fail" ] &&
 		echo "FAILED - see $logdir/$_basename.log and $logdir/$logfile for details"
-	# ignore saving external(external file, imsm...) bitmap
-	cat /proc/mdstat | grep -q "linear\|external" && return 0
 	if [ $DEVTYPE == 'lvm' ]
 	then
 		# not supported lvm type yet
@@ -77,6 +72,10 @@ save_log() {
 	then
 		if [ ! -z "$array" -a ${#array[@]} -ge 1 ]
 		then
+			echo "## $HOSTNAME: mdadm -D ${array[@]}" >> $logdir/$logfile
+			$mdadm -D ${array[@]} >> $logdir/$logfile
+			# ignore saving external(external file, imsm...) bitmap
+			cat /proc/mdstat | grep -q "linear\|external" && return 0
 			md_disks=($($mdadm -D -Y ${array[@]} | grep "/dev/" | cut -d'=' -f2))
 			cat /proc/mdstat | grep -q "bitmap"
 			if [ $? -eq 0 ]
-- 
2.6.6

