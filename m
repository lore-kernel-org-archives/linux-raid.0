From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Random bit flips - better data integrity needed
Date: Sun, 20 Sep 2009 17:48:50 -0400
Message-ID: <yq1bpl55ltp.fsf@sermon.lab.mkp.net>
References: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com>
	(Greg Freemyer's message of "Sat, 19 Sep 2009 12:10:34 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> This is all pretty new obviously.  To the best of my knowledge
Greg> filesystems have not yet been enhanced to track this value, thus
Greg> covering even more of the end-to-end transaction.

The filesystem part is pretty easy.  So far there hasn't been much point
because the window between filesystem submitting the bio and the block
layer generating the checksum is fairly small.

What's important wrt. to filesystems is to allow the checksums to be
passed through the page cache so we can get it to/from userland.  That's
on my list but it's stalled a bit waiting for aio to suck less.


Greg> I don't know how specifically, but it also seems to me the mdraid
Greg> stack could add to currently poor data integrity process even in
Greg> the absence of a supporting scsi subsystem.  Maybe by pulling out
Greg> the integrity checksum / crc info and putting it on yet another
Greg> disk, or mixing it in with the parity calculation.

Check dm-devel.  Alberto Bertogli has posted a DM target that does this.
I've only had time to do a cursory review.

However, I think the important thing here is to realize that the
strength of the data integrity infrastructure is in catching corruption
at WRITE time.  And that requires hardware participation because you
want it all the way.

If you want corruption detection and recovery at READ time the answer is
btrfs.  Really.  It was explicitly designed to do this.

I keep hearing talk about retrofitting checksums into existing
filesystems and software RAID.  Would the people that want to work on
this please stop partying like it's 1999 and go help out on btrfs
instead.  The world will be a much better place...

-- 
Martin K. Petersen	Oracle Linux Engineering
