From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 25 Feb 2010 09:41:41 +0100
Message-ID: <20100225084141.GA2927@lazy.lzy>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100225092106.5b7dd6ba@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bill Davidsen <davidsen@tmr.com>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> I certainly believe you.

thank you!

> That is really odd!  Both the kernel ext3 module (triggered by '-text3')
> and the 'mount' program use exactly the same test - look for the magic
> number in the superblock at 1K into the device.

Today I tried: blkid -p /dev/md1 (this time the live CD
autoassembled the md device) and it returned something
like: ambivalent result (probably more than one filesystem...)

Strange thing is that, the HDDs were brand new, no older
partitions or filesystem were there.

Anyway, I've one small correction, the RAID is not 10 f2,
on this PC, but (due to different installation) a RAID-1
with superblock 0.9 and the device partitions are set
to 0xFD (RAID autoassemble).
 
> Would you be able to get the first 4K from each device in the raid10:
>    dd if=/dev/whatever of=/tmp/whatever bs=1K count=4
> 
> and the tar/gz those up and send them to me.  That might give some clue.
> Unless the raid metadata is 1.1 or 1.2 - then I would need blocks further in
> the device, as the 'data offset'.
> The --detail output of the array might help too.

I dumped the first 4K of each device, they're identical
(so no mismatch there, at least), I'll send them to you,
together with the detail output.
 
> > Running a fsck did not find anything wrong, but it did
> > not repair anything too.
> 
> Did you use "fsck -f" ??

Yep.
 
> Until we know what is wrong, it is hard to suggest a fix.

Thanks a lot (also because this could turn out to be unrelated
with this mailing list).

bye,

-- 

piergiorgio
