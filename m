From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 09:11:48 +0100
Message-ID: <20090212081148.GD9439@rap.rap.dk>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 12, 2009 at 02:10:10PM +1100, NeilBrown wrote:
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
> 
> The raid6 array created will have a somewhat unusual layout in that
> all the Q blocks will be on the last drive.  Later I'll create
> functionality to restripe the array so that the Q block is rotated
> around all the drives as you would expect.
> 
> Comments and testing very welcome.

I would rather have functionality to convert raid10 to raid5.
raid1 should be depreciated, as raid10,n2 for all purposes is the same
but better implementation and performance, and raid10,f2 and raid10,o2
are even better.  Nobody should use raid1 anymore.

Best regards
keld
