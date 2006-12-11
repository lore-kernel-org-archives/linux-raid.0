From: Neil Brown <neilb@suse.de>
Subject: Re: oops on 2.6.19-rc6-mm2: deref of 0x28 at permission+0x7
Date: Mon, 11 Dec 2006 13:11:40 +1100
Message-ID: <17788.48732.53210.631230@cse.unsw.edu.au>
References: <457A0F4C.9060601@gmail.com>
	<Pine.LNX.4.64.0612102027350.1665@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jiri Kosina on Sunday December 10
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Kosina <jikos@jikos.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 10, jikos@jikos.cz wrote:
> On Sat, 9 Dec 2006, Jiri Slaby wrote:
> 
> > I got this oops on 2.6.19-rc6-mm2 when starting the system. It happened 
> > only once -- when echo "raidautorun /dev/md0" | nash --quiet was 
> > executed. 
> 
> Hi,
> 
> this nash thing is exactly the command which triggers a bit different oops 
> in my case. On my side, the oops is fully reproducible. If you manage to 
> make your case also reproducible, could you please try to revert 
> md-change-lifetime-rules-for-md-devices.patch? This made the oops vanish 
> in my case. I think Neil is working on it.

Trying to work on it - not making a lot of progress.   I find it hard
to see how anything in md can cause the inode for a block-device file
to disappear...

It is a bit of a long-shot, but this patch might change things.  It
changes the order in which things are de-allocated.

Jiri and Jiri: would either of both of you see if you can reproduce
the bug with this patch on 2.6.19-rc6-mm2 ???

Thanks,
NeilBrown


### Diffstat output
 ./drivers/md/md.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-12-11 13:04:23.000000000 +1100
+++ ./drivers/md/md.c	2006-12-11 13:07:28.000000000 +1100
@@ -224,16 +224,20 @@ static inline mddev_t *mddev_get(mddev_t
 
 static void mddev_put(mddev_t *mddev)
 {
+	request_queue_t *q;
+	struct gendisk *disk;
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
 	list_del(&mddev->all_mddevs);
 	spin_unlock(&all_mddevs_lock);
 
-	del_gendisk(mddev->gendisk);
-	mddev->gendisk = NULL;
-	blk_cleanup_queue(mddev->queue);
-	mddev->queue = NULL;
+	disk = mddev->gendisk;
+	q = mddev->queue;
+
 	kobject_unregister(&mddev->kobj);
+	if (disk)
+		del_gendisk(disk);
+	blk_cleanup_queue(q);
 }
 
 static mddev_t * mddev_find(dev_t unit)
