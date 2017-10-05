From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] md: raid10: remove VLAIS
Date: Thu,  5 Oct 2017 11:28:47 -0700
Message-ID: <20171005182847.3368-1-mka@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Michael Davidson <md@google.com>, Guenter Roeck <groeck@chromium.org>, Matthias Kaehlcke <mka@chromium.org>
List-Id: linux-raid.ids

The raid10 driver can't be built with clang since it uses a variable
length array in a structure (VLAIS):

drivers/md/raid10.c:4583:17: error: fields must have a constant size:
  'variable length array in structure' extension will never be supported

Allocate the r10bio struct with kmalloc instead of using the VLAIS
construct.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 drivers/md/raid10.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 374df5796649..9616163eaf8c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4578,15 +4578,16 @@ static int handle_reshape_read_error(struct mddev *mddev,
 	/* Use sync reads to get the blocks from somewhere else */
 	int sectors = r10_bio->sectors;
 	struct r10conf *conf = mddev->private;
-	struct {
-		struct r10bio r10_bio;
-		struct r10dev devs[conf->copies];
-	} on_stack;
-	struct r10bio *r10b = &on_stack.r10_bio;
+	struct r10bio *r10b;
 	int slot = 0;
 	int idx = 0;
 	struct page **pages;
 
+	r10b = kmalloc(sizeof(*r10b) +
+	       sizeof(struct r10dev) * conf->copies, GFP_KERNEL);
+	if (!r10b)
+		return -ENOMEM;
+
 	/* reshape IOs share pages from .devs[0].bio */
 	pages = get_resync_pages(r10_bio->devs[0].bio)->pages;
 
@@ -4635,11 +4636,13 @@ static int handle_reshape_read_error(struct mddev *mddev,
 			/* couldn't read this block, must give up */
 			set_bit(MD_RECOVERY_INTR,
 				&mddev->recovery);
+			kfree(r10b);
 			return -EIO;
 		}
 		sectors -= s;
 		idx++;
 	}
+	kfree(r10b);
 	return 0;
 }
 
-- 
2.14.2.920.gcf0c67979c-goog
