From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 25 Feb 2010 09:21:06 +1100
Message-ID: <20100225092106.5b7dd6ba@notabene.brown>
References: <4B67451F.8040206@tmr.com>
	<20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com>
	<20100211161444.7a0ea7bb@notabene.brown>
	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
	<4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown>
	<4B853BBF.7000607@tmr.com>
	<yq1ocjemx46.fsf@sermon.lab.mkp.net>
	<20100224185106.GA5426@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100224185106.GA5426@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bill Davidsen <davidsen@tmr.com>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Feb 2010 19:51:06 +0100
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Hi,
> 
> > So realistically both disk blocks are wrong and there's a window until
> > the new, correct block is written.  That window will only cause problems
> > if there is a crash and we'll need to recover.  My main concern here is
> > how big the discrepancy between the disks can get, and whether we'll end
> > up corrupting the filesystem during recovery because we could
> > potentially be matching metadata from one disk with journal entries from
> > another.
> 
> well, I know already people will not believe me, but
> just this evening, one of the infamous PCs with mismatch
> count going up and down, could not boot anymore.

I certainly believe you.

> 
> Reason: you must specifiy the filesystem type

This suggests that the superblock which lives at an offset of 1K
into the filesystem was sufficiently corrupted that mount couldn't
recognise it.

> 
> So, I started it with a live CD.
> 
> My first idea was a problem with the RAID (type is 10 f2).
> 
> This was assembled fine, so I tried to mount it, but mount
> returned the same error as above.
> So I tried to mount it specifying "-text3" and it was mounted.

That is really odd!  Both the kernel ext3 module (triggered by '-text3')
and the 'mount' program use exactly the same test - look for the magic
number in the superblock at 1K into the device.

It is very hard to see how 'mount' would fail to find something that the ext3
module finds.

> Everything seemed to be fine, I backup the data anyhow.
> 
> Some interesting discoveries:
> 
> tune2fs -l /dev/md/2_0 returns the FS data, no errors.
> blkid /dev/md/2_0 does not return anything.

This sounds very much like tune2fs and blkid are reading two different
things, which is strange.

Would you be able to get the first 4K from each device in the raid10:
   dd if=/dev/whatever of=/tmp/whatever bs=1K count=4

and the tar/gz those up and send them to me.  That might give some clue.
Unless the raid metadata is 1.1 or 1.2 - then I would need blocks further in
the device, as the 'data offset'.
The --detail output of the array might help too.


> 
> Running a fsck did not find anything wrong, but it did
> not repair anything too.

Did you use "fsck -f" ??

> 
> Now, I do not know if this was caused by the situation
> mentioned above, but for sure is quite fishy...
> 
> BTW, unrelated to the topic, any idea on how to fix this?
> Is there any tool that can restore the proper ID or else?
> 

Until we know what is wrong, it is hard to suggest a fix.

NeilBrown


> Thanks,
> 
> bye. 
> 

