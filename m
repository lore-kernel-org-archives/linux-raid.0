From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: Partitioned raid and major number
Date: Mon, 1 Mar 2004 01:42:56 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040301004256.GI14194@drinkel.cistron.nl>
References: <20040225145624.GA1513@cistron.nl> <16445.12026.812778.621025@notabene.cse.unsw.edu.au> <20040226215144.GC11831@drinkel.cistron.nl> <16446.36226.591283.495194@notabene.cse.unsw.edu.au> <16446.39583.968782.41221@notabene.cse.unsw.edu.au> <20040227165614.GO23988@traveler.cistron.net> <16450.32963.829675.526061@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16450.32963.829675.526061@notabene.cse.unsw.edu.au> (from neilb@cse.unsw.edu.au on Mon, Mar 01, 2004 at 01:16:03 +0100)
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 01 Mar 2004 01:16:03, Neil Brown wrote:
> On Friday February 27, miquels@cistron.nl wrote:
> > Now how to enable RAID1 on an existing disk... I hoped that I could create
> > an array with /dev/sda and /dev/sdb, with /dev/sdb marked as failed-disk.
> > Because initializing a RAID1 array with just one working disk doesn't
> > destroy the existing contents of the disk, right ? (I kept the last few
> > MB of the disk as free space for the raid superblock).
> > 
> > Unfortunately the current tools (or the kernel) doesn't let me do that
> > (/dev/sda is busy).
> 
> Yep.  Currently it isn't really possible while sda is mounted.  
> You need to boot off some other media and create the array there.

I hacked on it this weekend. I added a SET_ARRAY_INFO_CONFONLY ioctl
that creates an mddev, but markes it "confonly" internally. Meaning you
can configure it and add disks to it, but it can't be started/run.
The confonly array doesn't lock the disks when you add_new_disk().
I also patched raidtools2 to accept --confonly to mkraid, which uses
this new functionality. And that allows me to create a new raid array
on a disk that is currently in-use (you still have to use --really-force,
ofcourse).

What do you think of that approach ? Converting from a 1 disk setup
to a 2-disk RAID1 setup on an existing system is something that lots
of people want to do, seeing that the software raid howto even has
a few paragraphs dedicated to it.

Though it works, and I can boot from it, lilo doesn't understand it yet
so I'll have to hack on that next.

But if it works it would probably eventually be possible to add ICH5-R
etc raid1 superblock support to it. Or just write a valid ICH5-R
raid1 superblock to the disk (hopefully at another offset) so that the
BIOS knows this is a RAID1 setup and can boot when sda/hda is dead.

> > Two more minor issues - one, if partitioned MD is on (/dev/md/d0 etc)
> > the standard /dev/md0 device doesn't work anymore. For accessing the whole
> > device (management purposes / tools) shouldn't both /dev/md0 and
> > /dev/md/d0 open the same device ?
> 
> No - they are completely different devices.  Making them appear as one
> device has all sorts of problems relating to confusing bits of code
> that think they have exclusive access.  The idea as appealing but
> wasn't worth the effort.

Hmm yes, I understand. Thanks for explaining all that.

BTW, if you want to boot from a partitionable raid, you need the /dev/root
patch I posted before or you can't check the root filesystem. That patch
I think will not be accepted since stat(/dev/root) and
fd=open(/dev/root);fstat(fd) will return different things which is
inconsequent. How do you feel about applying for a static device number
for partitioned raid ? Hpa is also on this list, I noticed, and from his
reaction I think it wouldn't be a problem. Also it would be easier for
bootloaders like LILO to detect and deal with this.

Besides, if you check the current devices.txt you'll see that although
we've almost run out of majors that's only true for character devices.
There's plenty, plenty of block majors left.

Mike.
