From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Wed, 24 Feb 2010 19:51:06 +0100
Message-ID: <20100224185106.GA5426@lazy.lzy>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1ocjemx46.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> So realistically both disk blocks are wrong and there's a window until
> the new, correct block is written.  That window will only cause problems
> if there is a crash and we'll need to recover.  My main concern here is
> how big the discrepancy between the disks can get, and whether we'll end
> up corrupting the filesystem during recovery because we could
> potentially be matching metadata from one disk with journal entries from
> another.

well, I know already people will not believe me, but
just this evening, one of the infamous PCs with mismatch
count going up and down, could not boot anymore.

Reason: you must specifiy the filesystem type

So, I started it with a live CD.

My first idea was a problem with the RAID (type is 10 f2).

This was assembled fine, so I tried to mount it, but mount
returned the same error as above.
So I tried to mount it specifying "-text3" and it was mounted.
Everything seemed to be fine, I backup the data anyhow.

Some interesting discoveries:

tune2fs -l /dev/md/2_0 returns the FS data, no errors.
blkid /dev/md/2_0 does not return anything.

Running a fsck did not find anything wrong, but it did
not repair anything too.

Now, I do not know if this was caused by the situation
mentioned above, but for sure is quite fishy...

BTW, unrelated to the topic, any idea on how to fix this?
Is there any tool that can restore the proper ID or else?

Thanks,

bye. 

-- 

piergiorgio
