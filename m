From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Mon, 4 Aug 2003 13:06:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030804170620.GA3159@willow.seitz.com>
References: <3F2D1FAC.9030905@shaolinmicro.com> <1059929757.6751.60.camel@ralph.plexio.private> <3F2E8B0E.6060007@shaolinmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3F2E8B0E.6060007@shaolinmicro.com>
To: David Chow <davidchow@shaolinmicro.com>
Cc: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 05, 2003 at 12:34:22AM +0800, David Chow wrote:
> >Did you try:
> >mdadm /dev/md2 -a /dev/sda3
> >mdadm /dev/md3 -a /dev/sda5
> >mdadm /dev/md4 -a /dev/sda6
> > 
> >
> Already tried. I notice this problem happens in Redhat distributions 
> since 7.3 to 9 . When attempting to hot add disks, it doesn't rebuild. I 
> am wondering are there ioctls that I can call the md to start rebuild 
> without having to wait for an auto rebuild action.

I wonder - have you accidently created a mirror and then added a
hot-spare?  I've run into this problem before when switching to mdadm,
and it confused me pretty well.

What's your /etc/raidtab look like?


-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
