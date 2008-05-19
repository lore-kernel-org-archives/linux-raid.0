From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 10] md: proper extern for mdp_major
Date: Mon, 19 May 2008 11:10:17 +1000
Message-ID: <1080519011017.7639@suse.de>
References: <20080519110910.7473.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>
List-Id: linux-raid.ids


From: Adrian Bunk <bunk@kernel.org>

This patch adds a proper extern for mdp_major in include/linux/raid/md.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/raid/md.h |    2 ++
 ./init/do_mounts_md.c     |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff .prev/include/linux/raid/md.h ./include/linux/raid/md.h
--- .prev/include/linux/raid/md.h	2008-05-19 11:02:06.000000000 +1000
+++ ./include/linux/raid/md.h	2008-05-19 11:02:24.000000000 +1000
@@ -72,6 +72,8 @@
  */
 #define MD_PATCHLEVEL_VERSION           3
 
+extern int mdp_major;
+
 extern int register_md_personality (struct mdk_personality *p);
 extern int unregister_md_personality (struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread (void (*run) (mddev_t *mddev),

diff .prev/init/do_mounts_md.c ./init/do_mounts_md.c
--- .prev/init/do_mounts_md.c	2008-05-19 11:02:06.000000000 +1000
+++ ./init/do_mounts_md.c	2008-05-19 11:02:24.000000000 +1000
@@ -24,7 +24,6 @@ static struct {
 
 static int md_setup_ents __initdata;
 
-extern int mdp_major;
 /*
  * Parse the command-line parameters given our kernel, but do not
  * actually try to invoke the MD device now; that is handled by
