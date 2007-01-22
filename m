From: Neil Brown <neilb@suse.de>
Subject: Re: change strip_cache_size freeze the whole raid
Date: Tue, 23 Jan 2007 07:23:28 +1100
Message-ID: <17845.7488.24108.298825@notabene.brown>
References: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from kyle on Monday January 22
Sender: linux-raid-owner@vger.kernel.org
To: kyle <kylewong@southa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 22, kylewong@southa.com wrote:
> Hi,
> 
> Yesterday I tried to increase the value of strip_cache_size to see if I can 
> get better performance or not. I increase the value from 2048 to something 
> like 16384. After I did that, the raid5 freeze. Any proccess read / write to 
> it stucked at D state. I tried to change it back to 2048, read 
> strip_cache_active, cat /proc/mdstat, mdadm stop, etc. All didn't return 
> back. I even cannot shutdown the machine. Finally I need to press the reset 
> button in order to get back my control.

Thanks for reporting this.

alt-sysrq-T or "echo t > /proc/sysrq-trigger" can be really helpful to
diagnose this sort of problem (providing the system isn't so badly
stuck that the kernel logs don't get stored).

It is probably hitting a memory-allocation deadlock, though I cannot
see exactly where the deadlock would be.  If you are able to reproduce
it and can get the kernel logs after 'alt-sysrq-T' I would really
appreciate it.

This patch will almost certainly fix the problem, though I would like
to completely understand it first....

NeilBrown



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-01-22 09:08:16.000000000 +1100
+++ ./drivers/md/raid5.c	2007-01-23 07:17:25.000000000 +1100
@@ -205,7 +205,7 @@ static int grow_buffers(struct stripe_he
 	for (i=0; i<num; i++) {
 		struct page *page;
 
-		if (!(page = alloc_page(GFP_KERNEL))) {
+		if (!(page = alloc_page(GFP_IO))) {
 			return 1;
 		}
 		sh->dev[i].page = page;
@@ -321,7 +321,7 @@ static struct stripe_head *get_active_st
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
-	sh = kmem_cache_alloc(conf->slab_cache, GFP_KERNEL);
+	sh = kmem_cache_alloc(conf->slab_cache, GFP_IO);
 	if (!sh)
 		return 0;
 	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
