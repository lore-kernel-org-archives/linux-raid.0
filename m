From: NeilBrown <neilb@suse.de>
Subject: Re: Single-drive RAID0
Date: Mon, 21 Feb 2011 13:15:19 +1100
Message-ID: <20110221131519.1039f37c@notabene.brown>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
	<20110209134557.4e607451@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>
	<20110214131149.7f0655a3@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>
	<20110215110141.30d28302@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB347B@irsmsx503.ger.corp.intel.com>
	<20110216114234.0311d27b@notabene.brown>
	<BE2BFE91933D1B4089447C644860408069028F47@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408069028F47@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 16:57:06 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:

> > 
> > It looks like the 'bdev' passed to md_open keeps changing, which it
> > shouldn't.
> > 
> > If the above doesn't help, please add:
> > 
> > 	printk("bdev=%p, mddev=%p, disk=%p dev=%x\n", bdev, mddev, mddev-  
> > >gendisk, bdev->bd_dev);  
> > 
> > at the top of 'md_open', and see what it produces.  
> 
> I tried this also but I can't see any useful information that can make me some idea.
> Could you look at logs in attachment?
> 


I've made some progress.


The struct block_device is definitely getting freed and re-allocated.

This can happen if you

  mknod /dev/.tmp b 9 0
  open /dev/.tmp and do stuff, then close
  rm /dev/.tmp


If you open something in /dev which stays there, e.g. /dev/md0, then as long
as the inode for /dev/md0 remains in the inode cache it will hold a reference
to the block_device and so the same one will get reused.
But when to 'rm /dev/.tmp', the inode gets flushed from the cache and the
reference of the block_device is dropped.  If that was the only reference
then the block_device is discarded.

Each time a new block_device is created for a given block device, it will
re-do the partition scan which will mean that the partition devices get
deleted and recreated.

Maybe you are racing with this somehow and that is how the partition devices
appear to not be there - udev is removing and recreating them.

Something you could try would be to change fs/block_dev.c.
At about line 470 you should find:

static const struct super_operations bdev_sops = {
	.statfs = simple_statfs,
	.alloc_inode = bdev_alloc_inode,
	.destroy_inode = bdev_destroy_inode,
	.drop_inode = generic_delete_inode,
	.evict_inode = bdev_evict_inode,
};

If you change the 'drop_inode' line to
        .drop_inode = do_not_drop_inode,

and define a function:


static int do_not_drop_inode(struct inode *inode)
{
	return 0;
}

That will cause the block_device to remain in a cache for a while after the
last reference is dropped.
That should make your symptoms go away.

I'm not sure that is the "right" fix, but it should confirm what I suspect
is happening.

If it does, then we can explore more...
Did you say that this works better on earlier kernels?  If so, what is the
latest kernel that you have tried that you don't have this problem on?

Thanks,
NeilBrown

