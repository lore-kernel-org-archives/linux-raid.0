From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Is trim/discard supported on LVM RAID logical volume?
Date: Wed, 30 Nov 2016 00:32:51 +0100
Message-ID: <20161129233251.GA4404@metamorpher.de>
References: <CAEtPA0ByX8yYx8xNc_=4SP0bqXVz-D4o-bM5XZF8Y6NcnqsEKQ@mail.gmail.com>
 <CAJCQCtSpOfMvgfxOFvQtM=zcOnyoqvu3GregmW9NS5j9auRuyw@mail.gmail.com>
 <20161129220949.GA4035@metamorpher.de>
 <CAJCQCtQk01rtPa1=_XnxS3vfhP_gB88fXFayx4T_-OkbUUBGoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJCQCtQk01rtPa1=_XnxS3vfhP_gB88fXFayx4T_-OkbUUBGoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Patrick Dung <mpatdung@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 29, 2016 at 03:21:36PM -0700, Chris Murphy wrote:
> Reading the documentation for both, they're functionally the same
> thing in that with these options the particular layer will pass on a
> trim to the next layer underneath it.

discard/fstrim/blkdiscard works fine with issue_discards=0.

If it doesn't work, setting issue_discards=1 won't do a thing for you. 
That flag only affects the lvm tool itself, discard freed LVM extents 
after lvreduce or pvmove. Can't undo botched resizes anymore, too bad.

Most storage layers simply don't have any setting for this at all.
It just works. Or it does not (in many cases, old/stable kernel/distro).
cryptsetup's allow-discards is the exception, the one layer where you 
have to manually enable something to make it work.

Regards
Andreas Klauer
