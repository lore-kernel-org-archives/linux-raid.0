From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: Partitioned raid and major number
Date: Sat, 28 Feb 2004 02:09:16 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040228010916.GC13404@drinkel.cistron.nl>
References: <20040225145624.GA1513@cistron.nl> <16445.12026.812778.621025@notabene.cse.unsw.edu.au> <20040226215144.GC11831@drinkel.cistron.nl> <16446.36226.591283.495194@notabene.cse.unsw.edu.au> <16446.39583.968782.41221@notabene.cse.unsw.edu.au> <20040227165614.GO23988@traveler.cistron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 27 Feb 2004 17:56:14, Miquel van Smoorenburg wrote:
> On 2004.02.27 02:17, Neil Brown wrote:
> > On Friday February 27, neilb@cse.unsw.edu.au wrote:
> > > 
> > > Right.  I missed a bit in the patch.
> > > (I assume you are still wanting to boot off /dev/sda until you copy
> > > the data into /dev/md/d0p* - then you will use root=/dev/md_d0p1)
> > 
> > Sorry, that patch was wrong.
> > This one, ontop of the original patch, works for me (I finally got
> > around to testing it).
> 
> Yes, it works! Great.
> 
> Now how to enable RAID1 on an existing disk...

Hmm. With a dynamic major, the system might fail at checking the root
file system at boot. At that time, /dev is still read-only, and
/dev/md/d0p1 might not be the correct device yet.

So either mdp needs its own partition number, or we need a /dev/root
device that's an alias for the current root (like /dev/console).

Fortunately, that's very easy. Which makes me wonder why this hasn't
been done before .. what am I overlooking ?

Patch below uses 4,1 which is just arbitrary, ofcourse. Comments ?

--- linux-2.6.3/fs/block_dev.c	2004-02-18 04:59:58.000000000 +0100
+++ linux-2.6.3-bk8-mdp/fs/block_dev.c	2004-02-28 01:58:27.000000000 +0100
@@ -339,6 +339,11 @@ struct block_device *bdget(dev_t dev)
 	struct block_device *bdev;
 	struct inode *inode;
 
+#if 1 /* XXX miquels */
+	if (dev == MKDEV(4, 1))
+		dev = current->fs->pwdmnt->mnt_sb->s_dev;
+#endif
+
 	inode = iget5_locked(bd_mnt->mnt_sb, hash(dev),
 			bdev_test, bdev_set, &dev);
 

Mike.
