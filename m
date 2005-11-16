From: Ville Herva <vherva@vianova.fi>
Subject: Re: 3-disk RAID1 - only two disks active
Date: Wed, 16 Nov 2005 05:23:09 +0200
Message-ID: <20051116032309.GT6966@vianova.fi>
References: <20051115152622.A2237@turing.netspan.fi> <17274.26806.260020.822459@cse.unsw.edu.au>
Reply-To: vherva@netspan.fi, linux-raid@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17274.26806.260020.822459@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Samuli =?iso-8859-1?Q?K=E4rkk=E4inen?= <Samuli.Karkkainen@netspan.fi>
List-Id: linux-raid.ids

On Wed, Nov 16, 2005 at 10:01:10AM +1100, you [Neil Brown] wrote:
> On Tuesday November 15, vherva@turing.netspan.fi wrote:
> > I had two disks taken off from the three-disk raid set (hda,hdb,hdc - hdc
> > failed by itself, hdb was marked bad with raidsetfaulty). When the new disks
> > were added back to the set (with raidhotadd), only two of them became active
> > and one remained as a hot spare.
> > 
> > I there a way to reconfigure all three to become active again?
> 
> It looks from the details you gave that it never was a three-disk
> set.  It was only ever two-disk, possibly with a spare.

I can't dig up any hard evidence, but my impression is that it _was_ [UUU]
back when I had three disks in it the last time. That was in 2003, though.
It was created with the mentioned raidtab and 0.90 raidttools - shouldn't
that result into three active disks? 

Later one disk was removed, and later one broken. Now two have been added
back.

Anyway, you may well be right, perhaps I misremember and it was 2 active + 1
one spare.

> > This is kernel 2.4.32-rc1.
> 
> With a recent 2.6 kernel, you could
>    mdadm --grow --raid-disk=3 /dev/md1
> but with a 2.4 kernel, the only option is to re-create the array:
> 
>   mdadm --stop /dev/md1
>   mdadm --create /dev/md1 --level=1 --raid-disks=3 /dev/hda1 /dev/hdc1 missing
>   mdadm /dev/md1 --add /dev/hdb1

Ok, thanks. One of the md's is rootfs, so I'll have to wait for a reboot to
try that.



-- v -- 

v@iki.fi

