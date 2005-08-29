From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 001 of 7] Remove old cruft from md_k.h header file.
Date: Mon, 29 Aug 2005 17:33:39 +1000
Message-ID: <E1E9e9D-0003WX-3J@notabene.cse.unsw.edu.au>
References: <20050829172936.12848.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


These inlines haven't been used for ages, they should go.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./include/linux/raid/md_k.h |   64 --------------------------------------------
 1 file changed, 64 deletions(-)

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-08-29 15:52:25.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-08-29 15:52:38.000000000 +1000
@@ -86,70 +86,6 @@ typedef struct mdk_rdev_s mdk_rdev_t;
 #define MAX_CHUNK_SIZE (4096*1024)
 
 /*
- * default readahead
- */
-
-static inline int disk_faulty(mdp_disk_t * d)
-{
-	return d->state & (1 << MD_DISK_FAULTY);
-}
-
-static inline int disk_active(mdp_disk_t * d)
-{
-	return d->state & (1 << MD_DISK_ACTIVE);
-}
-
-static inline int disk_sync(mdp_disk_t * d)
-{
-	return d->state & (1 << MD_DISK_SYNC);
-}
-
-static inline int disk_spare(mdp_disk_t * d)
-{
-	return !disk_sync(d) && !disk_active(d) && !disk_faulty(d);
-}
-
-static inline int disk_removed(mdp_disk_t * d)
-{
-	return d->state & (1 << MD_DISK_REMOVED);
-}
-
-static inline void mark_disk_faulty(mdp_disk_t * d)
-{
-	d->state |= (1 << MD_DISK_FAULTY);
-}
-
-static inline void mark_disk_active(mdp_disk_t * d)
-{
-	d->state |= (1 << MD_DISK_ACTIVE);
-}
-
-static inline void mark_disk_sync(mdp_disk_t * d)
-{
-	d->state |= (1 << MD_DISK_SYNC);
-}
-
-static inline void mark_disk_spare(mdp_disk_t * d)
-{
-	d->state = 0;
-}
-
-static inline void mark_disk_removed(mdp_disk_t * d)
-{
-	d->state = (1 << MD_DISK_FAULTY) | (1 << MD_DISK_REMOVED);
-}
-
-static inline void mark_disk_inactive(mdp_disk_t * d)
-{
-	d->state &= ~(1 << MD_DISK_ACTIVE);
-}
-
-static inline void mark_disk_nonsync(mdp_disk_t * d)
-{
-	d->state &= ~(1 << MD_DISK_SYNC);
-}
-
-/*
  * MD's 'extended' device
  */
 struct mdk_rdev_s
