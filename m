From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 3/5] mdadm/test: get rid of the tests/testdev
Date: Mon, 28 Aug 2017 17:24:29 +0800
Message-ID: <1503912271-6463-4-git-send-email-zlliu@suse.com>
References: <1503912271-6463-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1503912271-6463-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

It's time to get rid of the tests/testdev due
to it has covered by testdev() in new 'test'.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/testdev | 13 -------------
 1 file changed, 13 deletions(-)
 delete mode 100644 tests/testdev

diff --git a/tests/testdev b/tests/testdev
deleted file mode 100644
index 8b6e6f0..0000000
--- a/tests/testdev
+++ /dev/null
@@ -1,13 +0,0 @@
-dev=$1
-cnt=$2
-size=$3
-chunk=$4
-mkfs -j $dev > /dev/null 2>&1 && fsck -fn $dev >&2
-dsize=$[size/chunk]
-dsize=$[dsize*chunk]
-rasize=$[dsize*2*cnt]
-if [ $rasize -ne `/sbin/blockdev --getsize $dev` ]
-then
-  echo "ERROR: size is wrong for $dev: $cnt * $size (chunk=$chunk) = $rasize, not `/sbin/blockdev --getsize $dev`"
-  exit 1;
-fi
-- 
2.6.6

