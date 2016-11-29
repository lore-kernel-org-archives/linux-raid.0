From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Is trim/discard supported on LVM RAID logical volume?
Date: Tue, 29 Nov 2016 15:21:36 -0700
Message-ID: <CAJCQCtQk01rtPa1=_XnxS3vfhP_gB88fXFayx4T_-OkbUUBGoQ@mail.gmail.com>
References: <CAEtPA0ByX8yYx8xNc_=4SP0bqXVz-D4o-bM5XZF8Y6NcnqsEKQ@mail.gmail.com>
 <CAJCQCtSpOfMvgfxOFvQtM=zcOnyoqvu3GregmW9NS5j9auRuyw@mail.gmail.com> <20161129220949.GA4035@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161129220949.GA4035@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Chris Murphy <lists@colorremedies.com>, Patrick Dung <mpatdung@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 29, 2016 at 3:09 PM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Tue, Nov 29, 2016 at 01:20:16PM -0700, Chris Murphy wrote:
>> Seen /etc/lvm/lvm.conf issue_discards is probably set to 0.
>
> It should be 0 unless you understand what it's doing and actually want it...
>
> Don't confuse LVM's issue_discards with cryptsetup's allow_discards.

Reading the documentation for both, they're functionally the same
thing in that with these options the particular layer will pass on a
trim to the next layer underneath it. So if the idea is to get trim to
to the SSD as the original poster suggests they want, then they'd have
to use the option at every logical device. Of course there are good
reasons to support trim affecting one or more layers, but not pass it
onto the physical block device.


-- 
Chris Murphy
