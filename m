From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] md-linear: use struct_size() in kzalloc()
Date: Mon, 7 Jan 2019 11:45:38 -0600
Message-ID: <20190107174538.GA7255@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-raid.ids

One of the more common cases of allocation size calculations is finding the
size of a structure that has a zero-sized array at the end, along with memory
for some number of elements for that array. For example:

struct foo {
    int stuff;
    void *entry[];
};

instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can now
use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/md/md-linear.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index d45c697c0ebe..5998d78aa189 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -96,8 +96,7 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 	int i, cnt;
 	bool discard_supported = false;
 
-	conf = kzalloc (sizeof (*conf) + raid_disks*sizeof(struct dev_info),
-			GFP_KERNEL);
+	conf = kzalloc(struct_size(conf, disks, raid_disks), GFP_KERNEL);
 	if (!conf)
 		return NULL;
 
-- 
2.20.1
