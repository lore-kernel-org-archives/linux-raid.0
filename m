From: Mike Perry <mikepery@fscked.org>
Subject: Re: Hot adding active disk to RAID1?
Date: Tue, 10 Feb 2004 01:54:06 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040210075406.GB15112@fscked.org>
References: <20040207152948.GA17368@fscked.org> <20040207173716.GA10996@fscked.org> <1076178191.3328.32.camel@picard.intra.techwiz.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1076178191.3328.32.camel@picard.intra.techwiz.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thus spake Peter Sj?berg (peters@techwiz.ca):

> On Sat, 2004-02-07 at 12:37, Mike Perry wrote:
> > Thus spake Mike Perry (mikepery@fscked.org):
> > Anyways, sorry for the spam, but I imagine at least one other poor sap
> > out there will find this useful ;)
> I'm that one.
> I ended up at the same place but for another reason. I was in a hurry to
> build my system and knew that converting a ext3 to raid would cause some
> problem because of some extra raid info, so I defined a raid1 with only
> one disk. Later I bought the other disk and tried to add it by changing
> /etc/raidtab but that did of course not work and it was at this point I
> started to actually read the doc...

Yeah, this sounds like my exact scenario, give or take a few details.

> I saw reference to an old version of mkraid that would reinitialize the
> superblock only (--superblock-only) and keep the data, but newer
> raidtools doesn't do that. If that been there or some manpage in the
> later version describing it a bit clearer I could dear to do mkraid -f
> but with all incarnations of the raid software I no longer know what is
> safe in my version

I concur. The manpages really should clear up that raidhotadd (and mdadm
-a) only add spares. And they should further clarify that spares are
essentially useless and lie dormant.. The names of these
commands/options are very deceptive to the new user...

> My current state is that I have root mounted as /dev/md0 created with
> one disk (/dev/hda5) as disk 0. I have since then added another disk and
> partitioned it equal. I now want to add /dev/hdc5 to md0 (was never
> mentioned before). If I add that to raidtab as failed-disk and do
> "mkraid -f", will I loose anything?

I would put your data on both just in case. But yes, this should work
just fine. The sync should start as soon as you raidhotadd a failed
disk.


Sorry for the late reply.. Was away for the weekend (which was the cause
of my original impatience and need to quickly find a solution..) 

-- 
Mike Perry
Mad Computer Scientist
fscked.org evil labs
