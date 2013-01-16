From: Charles Polisher <cpolish@surewest.net>
Subject: Re: Suboptimal raid6 linear read speed
Date: Wed, 16 Jan 2013 08:09:57 -0800
Message-ID: <20130116160957.GB10165@kevin>
References: <20130115123301.GA11948@rabbit.us>
 <50F55046.7050605@turmel.org>
 <20130115125507.GA12184@rabbit.us>
 <20130115170937.GA8831@kevin>
 <20130115195707.GA30921@www5.open-std.org>
 <20130116044335.GA10165@kevin>
 <20130116093651.GB1069@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130116093651.GB1069@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

keld@keldix.com wrote:
> Hi Charles
> 
> It really does not show below which layout you use for RAID10. This is quite
> important as the different layouts of RAID10 have quite different 
> performance characteristics. The 'far' layout tends to be the fastest.

> Which command did you use to create the RAID10 array?
 

mdadm --create /dev/md1 --chunk=64 --level=10 \
      --raid-devices=8 --spare-devices=0      \
      --parity=n2                             \
      /dev/sd[abcdefgh]1

> > # cat /proc/mdstat 
> > Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] 
> > md1 : active raid10 sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
> >       2118656 blocks 64K chunks 2 near-copies [8/8] [UUUUUUUU]
                                    ^^^^^^^^^^^^^
I will be testing far placement as well.

I very much appreciate your interest and guidance. To clarify my
goals, I am trying to demonstrate generalized RAID charac-
teristics using an experimental workbench in various config-
urations, tying the observed experimental data to expected
values. I'd like to wring out obvious errors in my experimental
technique.

The initial motivation was a glaringly poor choice of RAID level
for a performance-sensitive production system which I have to
live with for years to come. The most unsettling aspect was that
the selection process was stymied by the complexity of the
choices and an abundance of disinformation. I want to address
this pitfall by publishing an illustrated guide to performance,
cost, and reliability up and down the storage stack, helping
people to make reasoned choices in purchasing and configuring
storage. Varying the RAID level and configuration are key (but
not the only) parts of this work. I'm well along in the
literature search, workbench setup, and toolchain. I'm expecting
to put a year or two into the project and to open source
everything.
 
Best regards,
-- 
Charles

