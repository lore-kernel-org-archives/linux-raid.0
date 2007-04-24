From: Doug Ledford <dledford@redhat.com>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 11:39:10 -0400
Message-ID: <462E249E.6080202@redhat.com>
References: <462CC91B.8030008@dgreaves.com>	<16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>	<17965.18112.135843.417561@notabene.brown>	<462DE0A2.6000701@dgreaves.com> <17965.60458.702567.463105@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17965.60458.702567.463105@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>
> Yes, but it should not be needed, and I'd like to understand why it
> is.
> One of the last things do_md_run does is
>    mddev->changed = 1;
> 
> When you next open /dev/md_d0, md_open is called which calls
> check_disk_change().
> This will call into md_fops->md_media_changed which will return the
> value of mddev->changed, which will be '1'.
> So check_disk_change will then call md_fops->revalidate_disk which
> will set mddev->changed to 0, and will then set bd_invalidated to 1
> (as bd_disk->minors > 1 (being 64)).
> 
> md_open will then return into do_open (in fs/block_dev.c) and because
> bd_invalidated is true, it will call rescan_partitions and the
> partitions will appear.

Yuck.  The md stack should populate the partition information on device 
creation *without* needing someone to open the resulting device.  That 
you can tweak mdadm to open the device after creation is fine, but 
unless no other program is allowed to use the ioctls to start devices, 
and unless this is a documented part of the API, waiting until second 
open to populate the device info is just flat wrong.  It breaks all 
sorts of expectations people have regarding things like mount by label, etc.

> Hmmm... there is room for a race there.  If some other process opens
> /dev/md_d0 before mdadm gets to close it, it will call
> rescan_partitions before first calling  bd_set_size to update the size
> of the bdev.  So when we try to read the partition table, it will
> appear to be reading past the EOF, and will not actually read
> anything..
> 
> I guess udev must be opening the block device at exactly the wrong
> time. 
> 
> I can simulate this by holding /dev/md_d0 open while assembling the
> array.  If I do that, the partitions don't get created.
> Yuck.
> 
> Maybe I could call bd_set_size in md_open before calling
> check_disk_change..
> 
> Yep, this patch seems to fix it.  Could you confirm?
> 
> Thanks,
> 
> NeilBrown
> 
> diff .prev/drivers/md/md.c ./drivers/md/md.c
> --- .prev/drivers/md/md.c	2007-04-17 11:42:15.000000000 +1000
> +++ ./drivers/md/md.c	2007-04-24 21:29:51.000000000 +1000
> @@ -4485,6 +4485,8 @@ static int md_open(struct inode *inode, 
>  	mddev_get(mddev);
>  	mddev_unlock(mddev);
>  
> +	if (mddev->changed)
> +		bd_set_size(inode->i_bdev, mddev->array_size << 1);
>  	check_disk_change(inode->i_bdev);
>   out:
>  	return err;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford

Infiniband specific RPMs can be found at
http://people.redhat.com/dledford/Infiniband
