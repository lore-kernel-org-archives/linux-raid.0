From: Neil Brown <neilb@suse.de>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 21:38:18 +1000
Message-ID: <17965.60458.702567.463105@notabene.brown>
References: <462CC91B.8030008@dgreaves.com>
	<16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>
	<17965.18112.135843.417561@notabene.brown>
	<462DE0A2.6000701@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Tuesday April 24
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 24, david@dgreaves.com wrote:
> Neil Brown wrote:
> > This problem is very hard to solve inside the kernel.
> > The partitions will not be visible until the array is opened *after*
> > it has been created.  Making the partitions visible before that would
> > be possible, but would be very easy.
> > 
> > I think the best solution is Mike's solution which is to simply
> > open/close the array after it has been assembled.  I will make sure
> > this is in the next release of mdadm.
> > 
> > Note that you can still access the partitions even though they do not
> > appear in /proc/partitions.  Any attempt to access and of them will
> > make them all appear in /proc/partitions.  But I understand there is
> > sometimes value in seeing them before accessing them.
> > 
> > NeilBrown
> 
> For anyone else who is in this boat and doesn't fancy finding somewhere in mdadm
>  to hack, here's a simple program that issues the BLKRRPART ioctl.
> This re-reads the block device partition table and 'works for me'.

blockdev --rereadpt /dev/md_d0
does the same thing.

> 
> I think partx -a would do the same job but for some reason partx isn't in
> utils-linux for Debian...
> 
> Neil, isn't it easy to just do this after an assemble?

Yes, but it should not be needed, and I'd like to understand why it
is.
One of the last things do_md_run does is
   mddev->changed = 1;

When you next open /dev/md_d0, md_open is called which calls
check_disk_change().
This will call into md_fops->md_media_changed which will return the
value of mddev->changed, which will be '1'.
So check_disk_change will then call md_fops->revalidate_disk which
will set mddev->changed to 0, and will then set bd_invalidated to 1
(as bd_disk->minors > 1 (being 64)).

md_open will then return into do_open (in fs/block_dev.c) and because
bd_invalidated is true, it will call rescan_partitions and the
partitions will appear.

Hmmm... there is room for a race there.  If some other process opens
/dev/md_d0 before mdadm gets to close it, it will call
rescan_partitions before first calling  bd_set_size to update the size
of the bdev.  So when we try to read the partition table, it will
appear to be reading past the EOF, and will not actually read
anything..

I guess udev must be opening the block device at exactly the wrong
time. 

I can simulate this by holding /dev/md_d0 open while assembling the
array.  If I do that, the partitions don't get created.
Yuck.

Maybe I could call bd_set_size in md_open before calling
check_disk_change..

Yep, this patch seems to fix it.  Could you confirm?

Thanks,

NeilBrown

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-04-17 11:42:15.000000000 +1000
+++ ./drivers/md/md.c	2007-04-24 21:29:51.000000000 +1000
@@ -4485,6 +4485,8 @@ static int md_open(struct inode *inode, 
 	mddev_get(mddev);
 	mddev_unlock(mddev);
 
+	if (mddev->changed)
+		bd_set_size(inode->i_bdev, mddev->array_size << 1);
 	check_disk_change(inode->i_bdev);
  out:
 	return err;

