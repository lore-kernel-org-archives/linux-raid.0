From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Tue, 2 Mar 2010 15:57:00 +1100
Message-ID: <20100302155700.68236f28@notabene.brown>
References: <4B684087.50001@tmr.com>
	<20100211161444.7a0ea7bb@notabene.brown>
	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
	<4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown>
	<4B853BBF.7000607@tmr.com>
	<yq1ocjemx46.fsf@sermon.lab.mkp.net>
	<20100224185106.GA5426@lazy.lzy>
	<20100225092106.5b7dd6ba@notabene.brown>
	<20100225084141.GA2927@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100225084141.GA2927@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bill Davidsen <davidsen@tmr.com>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Feb 2010 09:41:41 +0100
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Hi,
> 
> > I certainly believe you.
> 
> thank you!
> 
> > That is really odd!  Both the kernel ext3 module (triggered by '-text3')
> > and the 'mount' program use exactly the same test - look for the magic
> > number in the superblock at 1K into the device.
> 
> Today I tried: blkid -p /dev/md1 (this time the live CD
> autoassembled the md device) and it returned something
> like: ambivalent result (probably more than one filesystem...)
> 
> Strange thing is that, the HDDs were brand new, no older
> partitions or filesystem were there.
> 
> Anyway, I've one small correction, the RAID is not 10 f2,
> on this PC, but (due to different installation) a RAID-1
> with superblock 0.9 and the device partitions are set
> to 0xFD (RAID autoassemble).
>  
> > Would you be able to get the first 4K from each device in the raid10:
> >    dd if=/dev/whatever of=/tmp/whatever bs=1K count=4
> > 
> > and the tar/gz those up and send them to me.  That might give some clue.
> > Unless the raid metadata is 1.1 or 1.2 - then I would need blocks further in
> > the device, as the 'data offset'.
> > The --detail output of the array might help too.
> 
> I dumped the first 4K of each device, they're identical
> (so no mismatch there, at least), I'll send them to you,
> together with the detail output.

Thanks.  I finally had a look at these (sorry for delay).

If you run "file" on one of the dumps, it tells you:

$ file disk1.raw 
disk1.raw: Minix filesystem

Which isn't expected.  I would expect something like
$ file xxx
xxx: Linux rev 1.0 ext3 filesystem data, UUID=fe55fe6f-0412-4a0a-852d-a0e21767aa35 (needs journal recovery) (large files)

for an ext3 filesystem.

Looking at /usr/share/misc/magic, it seems that a Minix filesystem is defined
by:
0x410	leshort		0x137f		Minix filesystem

i.e. the 2 bytes at 0x410 into the device are 0x137f, which exactly what we
find in your dump.

0x410 in an ext3 superblock is the lower bytes of "s_free_inodes_count", the
count of free inodes.
Your actual number is 14881663, which is 0x00E3137F.

So if you just add or remove a file, the number of free inodes should change,
and your filesystem will no longer look like a Minix filesystem and
your problems should go away.

I guess libblkid et-al should do more sanity checks on the superblock before
deciding that it really belongs to some particular filesystem.

But I'm happy - this clearly isn't a raid problem.

NeilBrown

