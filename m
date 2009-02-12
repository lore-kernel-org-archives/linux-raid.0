From: Farkas Levente <lfarkas@lfarkas.org>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 10:42:04 +0100
Message-ID: <4993EEEC.2020901@lfarkas.org>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> Hi,
>  following is my current patch queue for 2.6.30, in case anyone would
> like to review or otherwise comment.
> They should show up in -next shortly.
> 
> Probably the most interesting are the last few which provide support
> for converting a raid1 into a raid5, and a raid5 into a raid6.
> I plan to do some more work here so the code might change a bit before
> final submission, as I work out how best ot factor the code.
> 
> mdadm doesn't current support these conversions, but you can
> simply
>    echo raid5 > /sys/block/md0/md/level
> to change a 2-drive raid1 into a raid5.  Similarly for 5->6

any plan for non-raid to raid1 or anything else like in windows on can
convert a normal partition into a mirrored one online.

-- 
  Levente                               "Si vis pacem para bellum!"
