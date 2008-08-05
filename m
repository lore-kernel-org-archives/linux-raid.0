From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: [PATCH md] Speed up raid10 resync, especially for 'far' layout
Date: Tue, 5 Aug 2008 12:14:30 +0200
Message-ID: <20080805101429.GA16040@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Speed up raid10 resync, especially for 'far' layout

This patch speeds up resync for raid10, especially for the 'far' 
layout, where reading is done in 32 MiB increments and the moving of
heads is therefore much reduced compared to the previous 2 MiB size,
nd the 'far' property of striping read can be employed.

A speed up of more than 50 % has been reported.

Signed-off-by: Keld Simonsen <keld@dkuug.dk>

### Diffstat output:
 raid10.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u linux-2.6.25.10/drivers/md/raid10.c linux-2.6.25.10-ks/drivers/md/raid10.c
--- linux-2.6.25.10/drivers/md/raid10.c	2008-07-03 05:46:47.000000000 +0200
+++ linux-2.6.25.10-ks/drivers/md/raid10.c	2008-07-12 18:28:59.438235317 +0200
@@ -80,7 +80,7 @@
 //#define RESYNC_BLOCK_SIZE PAGE_SIZE
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
-#define RESYNC_WINDOW (2048*1024)
+#define RESYNC_WINDOW (2048*1024*16)
 
 /*
  * When performing a resync, we need to read and compare, so
@@ -686,7 +686,7 @@
  *    there is no normal IO happeing.  It must arrange to call
  *    lower_barrier when the particular background IO completes.
  */
-#define RESYNC_DEPTH 32
+#define RESYNC_DEPTH 32*16
 
 static void raise_barrier(conf_t *conf, int force)
 {
