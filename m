From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 02/13] mdadm/test: did basic improvement for 00names
Date: Fri,  1 Dec 2017 17:48:03 +0800
Message-ID: <1512121694-18168-3-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

1. clean the code style
2. add raid10 in test
3. delete the temp file once finish testing.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/00names | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tests/00names b/tests/00names
index 7a066d8..d0ee3e9 100644
--- a/tests/00names
+++ b/tests/00names
@@ -4,10 +4,13 @@ set -x -e
 conf=$targetdir/mdadm.conf
 echo "CREATE names=yes" > $conf
 
-for i in linear raid0 raid1 raid4 raid5 raid6
+for i in linear raid0 raid1 raid4 raid5 raid6 raid10
 do
-  mdadm -CR --config $conf /dev/md/$i -l $i -n 4 $dev4 $dev3 $dev2 $dev1
-  check $i
-  [ -d /sys/class/block/md_$i/md ]
-  mdadm -S md_$i
+	mdadm -CR --config $conf /dev/md/$i -l $i -n 4 $dev4 $dev3 $dev2 $dev1
+	check $i
+	[ -d /sys/class/block/md_$i/md ] || exit 1
+	mdadm -S md_$i
 done
+rm $conf
+
+exit 0
-- 
1.8.5.6

