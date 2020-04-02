From: Coly Li <colyli@suse.de>
Subject: [PATCH] raid5: use memalloc_noio_save()/restore in resize_chunks()
Date: Thu,  2 Apr 2020 16:13:12 +0800
Message-ID: <20200402081312.32709-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: linux-raid@vger.kernel.org, guoqing.jiang@cloud.ionos.com, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Michal Hocko <mhocko@suse.com>
List-Id: linux-raid.ids

Commit b330e6a49dc3 ("md: convert to kvmalloc") uses kvmalloc_array()
to allocate memory with GFP_NOIO flag in resize_chunks() via function
scribble_alloc(),
2269	err = scribble_alloc(percpu, new_disks,
2270			     new_sectors / STRIPE_SECTORS,
2271			     GFP_NOIO);

The purpose of GFP_NOIO flag to kvmalloc_array() is to allocate
non-physically continuous pages and avoid extra I/Os of page reclaim
which triggered by memory allocation. When system memory is under
heavy pressure, non-physically continuous pages allocation is more
probably to success than allocating physically continuous pages.

But as a non GFP_KERNEL compatible flag, GFP_NOIO is not acceptible
by kvmalloc_node() and the memory allocation indeed is handled with
kmalloc_node() to allocate physically continuous pages. This is not
the expected behavior of the original purpose when mistakenly using
GFP_NOIO flag.

In this patch, the memalloc scope APIs memalloc_noio_save() and
memalloc_noio_restore() are used when calling scribble_alloc(). Then
when calling kvmalloc_array() with GFP_KERNEL mask, the scope APIs
may indicatet the allocating context to avoid memory reclaim related
I/Os, to avoid recursive I/O deadlock on the md raid array itself
which is calling scribble_alloc() to allocate non-physically continuous
pages.

This patch also removes gfp_t flags from scribble_alloc() parameters
list, because the invalid GFP_NOIO is replaced by memalloc scope APIs.

Fixes: b330e6a49dc3 ("md: convert to kvmalloc")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
---
 drivers/md/raid5.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ba00e9877f02..6b23f8aba169 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2228,14 +2228,15 @@ static int grow_stripes(struct r5conf *conf, int num)
  * of the P and Q blocks.
  */
 static int scribble_alloc(struct raid5_percpu *percpu,
-			  int num, int cnt, gfp_t flags)
+			  int num, int cnt)
 {
 	size_t obj_size =
 		sizeof(struct page *) * (num+2) +
 		sizeof(addr_conv_t) * (num+2);
 	void *scribble;
+	unsigned int noio_flag;
 
-	scribble = kvmalloc_array(cnt, obj_size, flags);
+	scribble = kvmalloc_array(cnt, obj_size, GFP_KERNEL);
 	if (!scribble)
 		return -ENOMEM;
 
@@ -2250,6 +2251,7 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 {
 	unsigned long cpu;
 	int err = 0;
+	unsigned int noio_flag;
 
 	/*
 	 * Never shrink. And mddev_suspend() could deadlock if this is called
@@ -2262,16 +2264,25 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 	mddev_suspend(conf->mddev);
 	get_online_cpus();
 
+	/*
+	 * scribble_alloc() allocates memory by kvmalloc_array(), if
+	 * the memory allocation triggers memory reclaim I/Os onto
+	 * this raid array, there might be potential deadlock if this
+	 * raid array happens to be suspended during memory allocation.
+	 * Here the scope APIs are used to disable such recursive memory
+	 * reclaim I/Os.
+	 */
+	noio_flag = memalloc_noio_save();
 	for_each_present_cpu(cpu) {
 		struct raid5_percpu *percpu;
 
 		percpu = per_cpu_ptr(conf->percpu, cpu);
 		err = scribble_alloc(percpu, new_disks,
-				     new_sectors / STRIPE_SECTORS,
-				     GFP_NOIO);
+				     new_sectors / STRIPE_SECTORS);
 		if (err)
 			break;
 	}
+	memalloc_noio_restore(noio_flag);
 
 	put_online_cpus();
 	mddev_resume(conf->mddev);
@@ -6759,8 +6770,7 @@ static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu
 			       conf->previous_raid_disks),
 			   max(conf->chunk_sectors,
 			       conf->prev_chunk_sectors)
-			   / STRIPE_SECTORS,
-			   GFP_KERNEL)) {
+			   / STRIPE_SECTORS)) {
 		free_scratch_buffer(conf, percpu);
 		return -ENOMEM;
 	}
-- 
2.25.0
