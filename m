From: "majianpeng" <majianpeng@gmail.com>
Subject: md:Add the judgement about the size of suspend_lo and  suspend_hi.
Date: Wed, 28 Mar 2012 19:49:38 +0800
Message-ID: <201203281949331251132@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 7b8db5f9559feef49859056407a7cee656bcfc45 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 28 Mar 2012 19:43:58 +0800
Subject: [PATCH] md:Add the judgement about the size of suspend_lo and
 suspend_hi.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b572e1e..7180ac3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4364,6 +4364,8 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;
+	if (new > mddev->suspend_hi)
+		return -EINVAL;
 
 	mddev->suspend_lo = new;
 	if (new >= old)
@@ -4398,6 +4400,8 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;
+	if (new < mddev->suspend_lo)
+		return -EINVAL;
 
 	mddev->suspend_hi = new;
 	if (new <= old)
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-28

