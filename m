From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Mon, 18 Jul 2011 00:11:01 +0200
Message-ID: <ivvmh4$iqt$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>	<BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>	<alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk> <20110629204519.419474d2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110629204519.419474d2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> Trim support for md is a long way down my list of interesting projects (and
> no-one else has volunteered).

That's a pity.

Actually, we were desperate enough about being able to discard unused 
sectors from our SSDs "behind" MD that we implemented a user-space 
work-around (using fallocate and BLKDISCARD ioctls after finding out 
which physical devices are hidden behind the RAID), but that is awkward 
in comparison to just using "fstrim" or alike, as this means that during 
the discards, the filesystem appears "almost full", and the work-around 
supports only RAID-1.

> It is not at all straight forward to implement.

For RAID5/6, I understand that. But supporting RAID 0/1, and maybe even 
RAID 10, should not be that difficult. (dm-raid does support this, 
though we don't like dm-raid too much for several other reasons.)

If today somebody is investing into SSDs, it is for speed. So if you are 
setting up an SSD based RAID, it's unlikely that you'll aim for RAID5/6, 
anyway.

> For copying RAID (RAID1, RAID10) you really need the same bitmap.  There
> isn't the same risk of reading and trusting discarded parity, but a resync
> which didn't know about discarded ranges would undo the discard for you.

That is true, but not really a problem. Yes, the write-performance will 
suffer until the next "fstrim" is done, but the performance suffers from 
the resync anyway, so that's not something extra, and SSD users will 
certainly issue "fstrim" periodically, anyway.

I guess you would make many people happy if MD-raid supported passing 
through discards, even if it was only for RAID 0/1, and even if a resync 
meant you'd have to issue an additional "fstrim".

Regards,

Lutz Vieweg



