From: Patrick Dung <mpatdung@gmail.com>
Subject: Re: Is trim/discard supported on LVM RAID logical volume?
Date: Wed, 30 Nov 2016 16:25:40 +0800
Message-ID: <CAEtPA0AouO3pp343QNz3=aAcX6oXzSL_pwhG9p=WEqmCv5Ve9w@mail.gmail.com>
References: <CAEtPA0ByX8yYx8xNc_=4SP0bqXVz-D4o-bM5XZF8Y6NcnqsEKQ@mail.gmail.com>
 <CAJCQCtSpOfMvgfxOFvQtM=zcOnyoqvu3GregmW9NS5j9auRuyw@mail.gmail.com>
 <20161129220949.GA4035@metamorpher.de> <CAJCQCtQk01rtPa1=_XnxS3vfhP_gB88fXFayx4T_-OkbUUBGoQ@mail.gmail.com>
 <20161129233251.GA4404@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161129233251.GA4404@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I got a reply in linux-lvm that there should be problem, and Heinz
from Redhat is looking into it.
related message:
https://www.redhat.com/archives/linux-lvm/2016-November/msg00041.html

For your information, I have issue_discards set to 1.
If I create a non-RAID LVM, the fstrim works.

Thanks and regards,
Patrick

On Wed, Nov 30, 2016 at 7:32 AM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Tue, Nov 29, 2016 at 03:21:36PM -0700, Chris Murphy wrote:
>> Reading the documentation for both, they're functionally the same
>> thing in that with these options the particular layer will pass on a
>> trim to the next layer underneath it.
>
> discard/fstrim/blkdiscard works fine with issue_discards=0.
>
> If it doesn't work, setting issue_discards=1 won't do a thing for you.
> That flag only affects the lvm tool itself, discard freed LVM extents
> after lvreduce or pvmove. Can't undo botched resizes anymore, too bad.
>
> Most storage layers simply don't have any setting for this at all.
> It just works. Or it does not (in many cases, old/stable kernel/distro).
> cryptsetup's allow-discards is the exception, the one layer where you
> have to manually enable something to make it work.
>
> Regards
> Andreas Klauer
