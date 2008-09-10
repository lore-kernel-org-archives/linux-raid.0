From: Sven Wegener <sven.wegener@stealer.net>
Subject: md: Check for memory allocation failure in faulty personality
Date: Wed, 10 Sep 2008 21:42:52 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0809102132590.19109@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

It's a fault injection module, but I don't think we should oops here.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/md/faulty.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Other personalities return -EIO, when something like this happens, but I 
don't see a reason why we shouldn't return the more appropriate -ENOMEM 
here.

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 268547d..f26c1f9 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -287,6 +287,8 @@ static int run(mddev_t *mddev)
 	int i;
 
 	conf_t *conf = kmalloc(sizeof(*conf), GFP_KERNEL);
+	if (!conf)
+		return -ENOMEM;
 
 	for (i=0; i<Modes; i++) {
 		atomic_set(&conf->counters[i], 0);
