From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 41/66] drivers/md/linear.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:22 +0100
Message-ID: <1267289508-31031-42-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Neil Brown <neilb@suse.de>, Sandeep K Sinha <sandeepksinha@gmail.com>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

drivers/md/linear.h:12: ERROR: open brace '{' following struct go on the same line

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/md/linear.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/linear.h b/drivers/md/linear.h
index 0ce29b6..3860fd8 100644
--- a/drivers/md/linear.h
+++ b/drivers/md/linear.h
@@ -8,8 +8,7 @@ struct dev_info {
 
 typedef struct dev_info dev_info_t;
 
-struct linear_private_data
-{
+struct linear_private_data {
 	sector_t		array_sectors;
 	dev_info_t		disks[0];
 	struct rcu_head		rcu;
-- 
1.7.0.90.g251a4
