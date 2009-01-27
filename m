From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/2] md: More block -> sector conversions.
Date: Tue, 27 Jan 2009 17:39:30 +1100
Message-ID: <18814.44066.632249.862265@notabene.brown>
References: <1232982852-32747-1-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday January 26
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday January 26, maan@systemlinux.org wrote:
> These two patches against Neil's for-next tree make the internal
> representaions of mddev->size and rdev->size sector-based.
> checkpatch.pl is happy with both patches, and the patched kernel
> passes all tests of the mdadm test suite on my i386 UP box.
> 
> Please review.
> 
> BTW: This completes the block -> sector conversion of the md code base
> because all remaining block-based quantities are either user-visible
> (via sysfs) or describe on-disk formats (version 0.90 superblocks)
> and hence can not be changed without breaking user space.
> 

Thanks Andre.
These look fine.
The only problem I could find was that in the first patch, the change
log says "num_sectors" and the code says "sectors" :-)

I'll queue these for the next release.

Thanks,
NeilBrown
