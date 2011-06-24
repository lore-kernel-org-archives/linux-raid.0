From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/2] md.4: fix possible typos
Date: Fri, 24 Jun 2011 13:26:50 +0900
Message-ID: <1308889610-8210-2-git-send-email-namhyung@gmail.com>
References: <1308889610-8210-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308889610-8210-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 md.4 |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/md.4 b/md.4
index 5e79639..378ecc9 100644
--- a/md.4
+++ b/md.4
@@ -128,7 +128,7 @@ have special-purpose uses and is supported.
 From release 2.6.28, the
 .I md
 driver supports arrays with externally managed metadata.  That is,
-the metadata is not managed by the kernel by rather by a user-space
+the metadata is not managed by the kernel but rather by a user-space
 program which is external to the kernel.  This allows support for a
 variety of metadata formats without cluttering the kernel with lots of
 details.
@@ -468,7 +468,7 @@ scrub starts and is incremented whenever a sector is
 found that is a mismatch.
 .I md
 normally works in units much larger than a single sector and when it
-finds a mismatch, it does not determin exactly how many actual sectors were
+finds a mismatch, it does not determine exactly how many actual sectors were
 affected but simply adds the number of sectors in the IO unit that was
 used.  So a value of 128 could simply mean that a single 64KB check
 found an error (128 x 512bytes = 64KB).
@@ -661,7 +661,7 @@ to this file will cause the system-wide setting to have effect.
 This is the partner of
 .B md/sync_speed_min
 and overrides
-.B /proc/sys/dev/raid/spool_limit_max
+.B /proc/sys/dev/raid/speed_limit_max
 described below.
 
 .TP
-- 
1.7.5.2

