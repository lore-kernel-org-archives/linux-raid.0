From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 2/4] mdadm/test: Fixed the condition parsing error for array[]
Date: Wed, 19 Jul 2017 19:11:13 +0800
Message-ID: <1500462675-6463-3-git-send-email-zlliu@suse.com>
References: <1500462675-6463-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1500462675-6463-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

it complains too many arguments when array[] has few
members, it's proper to check whether or not array[0]
is zero.

Reported-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 test | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test b/test
index 87e2df2..25268a0 100755
--- a/test
+++ b/test
@@ -75,7 +75,7 @@ save_log() {
 		echo
 	elif [ "$DEVTYPE" == 'loop' -o "$DEVTYPE" == 'disk' ]
 	then
-		if [ ! -z ${array[@]} -a ${#array[@]} -ge 1 ]
+		if [ ! -z "$array" -a ${#array[@]} -ge 1 ]
 		then
 			md_disks=($($mdadm -D -Y ${array[@]} | grep "/dev/" | cut -d'=' -f2))
 			cat /proc/mdstat | grep -q "bitmap"
-- 
1.8.3.1

