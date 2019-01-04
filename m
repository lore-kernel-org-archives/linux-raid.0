From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] md/raid10: Use struct_size() in kmalloc()
Date: Fri, 4 Jan 2019 15:11:28 -0600
Message-ID: <20190104211128.GA13343@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-raid.ids

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    void *entry[];
};

instance = kmalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kmalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/md/raid10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index abb5d382f64d..320cb430cca6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4788,8 +4788,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 	int idx = 0;
 	struct page **pages;
 
-	r10b = kmalloc(sizeof(*r10b) +
-	       sizeof(struct r10dev) * conf->copies, GFP_NOIO);
+	r10b = kmalloc(struct_size(r10b, devs, conf->copies), GFP_NOIO);
 	if (!r10b) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		return -ENOMEM;
-- 
2.20.1
