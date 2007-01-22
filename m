From: Neil Brown <neilb@suse.de>
Subject: Re: change strip_cache_size freeze the whole raid
Date: Tue, 23 Jan 2007 09:47:25 +1100
Message-ID: <17845.16125.443504.552886@notabene.brown>
References: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f>
	<17845.7488.24108.298825@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Tuesday January 23
Sender: linux-raid-owner@vger.kernel.org
To: kyle <kylewong@southa.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 23, neilb@suse.de wrote:
> 
> This patch will almost certainly fix the problem, though I would like
> to completely understand it first....


Of course, that patch didn't compile.... The "GFP_IO" should have been
"GFP_NOIO".
As below.

NeilBrown

--------------------------
Avoid possible malloc deadlock in raid5.

Due to reports of raid5 hanging when growing the stripe cache,
it is best to use GFP_IO for those allocation.  We would rather
fail than deadlock.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-01-23 09:44:22.000000000 +1100
+++ ./drivers/md/raid5.c	2007-01-23 09:44:43.000000000 +1100
@@ -205,7 +205,7 @@ static int grow_buffers(struct stripe_he
 	for (i=0; i<num; i++) {
 		struct page *page;
 
-		if (!(page = alloc_page(GFP_KERNEL))) {
+		if (!(page = alloc_page(GFP_NOIO))) {
 			return 1;
 		}
 		sh->dev[i].page = page;
@@ -321,7 +321,7 @@ static struct stripe_head *get_active_st
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
-	sh = kmem_cache_alloc(conf->slab_cache, GFP_KERNEL);
+	sh = kmem_cache_alloc(conf->slab_cache, GFP_NOIO);
 	if (!sh)
 		return 0;
 	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
