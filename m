From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: [md PATCH] md: handle read-only member devices better.
Date: Sat, 15 Apr 2017 21:22:03 +0100
Message-ID: <006d05e1-2517-ca5c-00b4-c699a5bd793d@youngman.org.uk>
References: <87a87lutj7.fsf@notabene.neil.brown.name>
 <20170413054723.2spvhtze6bljkaop@kernel.org>
 <877f2muvmc.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f2muvmc.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Nanda Kishore Chinnaram <Nanda_Kishore_Chinna@dell.com>
List-Id: linux-raid.ids

On 15/04/17 05:45, NeilBrown wrote:
> So at present, callers of blkdev_get_by_dev() need to do their own
> bdev_read_only() tests before writing.
> We could discuss where in md.c is the best place to put them, but unless
> you want to take on a largish project to 'fix' (or audit) all callers of
> blkdev_get_by_dev(), they need to go in md somewhere.

anthony@crappit:~/gitstuff/linux-stable> git grep -a blkdev_get_by_dev > 
blkdev_get_by_dev.txt
anthony@crappit:~/gitstuff/linux-stable> cat blkdev_get_by_dev.txt
drivers/block/xen-blkback/xenbus.c:     bdev = 
blkdev_get_by_dev(vbd->pdevice, vbd->readonly ?
drivers/md/dm.c:        bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | 
FMODE_EXCL, _claim_ptr);
drivers/md/md.c:        bdev = blkdev_get_by_dev(dev, 
FMODE_READ|FMODE_WRITE|FMODE_EXCL,
drivers/mtd/devices/block2mtd.c:                bdev = 
blkdev_get_by_dev(devt, mode, dev);
fs/block_dev.c: * blkdev_get_by_dev - open a block device by device number
fs/block_dev.c:struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t 
mode, void *holder)
fs/block_dev.c:EXPORT_SYMBOL(blkdev_get_by_dev);
fs/ext4/super.c:        bdev = blkdev_get_by_dev(dev, 
FMODE_READ|FMODE_WRITE|FMODE_EXCL, sb);
fs/f2fs/super.c: 
blkdev_get_by_dev(sbi->sb->s_bdev->bd_dev,
fs/jfs/jfs_logmgr.c:    bdev = blkdev_get_by_dev(sbi->logdev, 
FMODE_READ|FMODE_WRITE|FMODE_EXCL,
fs/nfs/blocklayout/dev.c:       bdev = blkdev_get_by_dev(dev, FMODE_READ 
| FMODE_WRITE, NULL);
fs/reiserfs/journal.c:          journal->j_dev_bd = 
blkdev_get_by_dev(jdev, blkdev_mode,
include/linux/fs.h:extern struct block_device *blkdev_get_by_dev(dev_t 
dev, fmode_t mode,
kernel/power/swap.c:    hib_resume_bdev = 
blkdev_get_by_dev(swsusp_resume_device,
anthony@crappit:~/gitstuff/linux-stable>

So, if I'm mad enough to take this on, does that mean going through all 
of these checking/fixing them to test for a return code of -EACCESS?

No promises that I will, I keep on wanting to do this sort of stuff and 
then life gets in the way, but if I can't do it it'll go on the list of 
projects on the raid wiki.

Cheers,
Wol
