From: =?UTF-8?B?TWljaGHFgg==?= Pecio <michal.pecio@gmail.com>
Subject: [PATCH] md/raid0: remove empty line printk from dump_zones
Date: Sun, 24 Apr 2016 18:11:45 +0200
Message-ID: <20160424181145.41aae9dd@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Remove the final printk. All preceding output is already properly
newline-terminated and the printk isn't even KERN_CONT to begin with,
so it only adds one empty line to the log.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
---
 drivers/md/raid0.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f8e5db0..3e51f4d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -70,7 +70,6 @@ static void dump_zones(struct mddev *mddev)
 			(unsigned long long)zone_size>>1);
 		zone_start = conf->strip_zone[j].zone_end;
 	}
-	printk(KERN_INFO "\n");
 }
 
 static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
