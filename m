From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: why the kernel and mdadm report differently
Date: Tue, 6 Sep 2005 11:18:49 +1000
Message-ID: <17180.61049.345848.794914@cse.unsw.edu.au>
References: <431C0968.10301@bppiac.hu>
	<17180.3031.193961.445535@cse.unsw.edu.au>
	<431C30E3.2040404@bppiac.hu>
	<431C487F.3010908@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Farkas Levente on Monday September 5
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 5, lfarkas@bppiac.hu wrote:
> Farkas Levente wrote:
> >>> and one more stange thing that it's currently not working, kernel 
> >>> report inactive while mdadm said it's active, degraded. what's more 
> >>> we cant put this array into active state.
> >>
> >>
> >>
> >> Looks like you need to stop in (mdadm -S /dev/md2) and re-assemble it
> >> with --force:
> >>   mdadm -A /dev/md2 -f /dev/sd[abcefgh]1
> >>
> >> It looks like the computer crashed and when it came back up it was
> >> missing a drive.  This situation can result in silent data corruption,
> >> which is why md won't automatically assemble it.  When you do assemble
> >> it, you should at least fsck the filesystem, and possibly check for
> >> data corruption if that is possible.  At least be aware that some data
> >> could be corrupt (there is a good chance that nothing is, but it is by
> >> no means certain).
> > 
> > 
> > it works. but shouldn't it have to be both inactive or active?
> 
> or seems to works, but now do nothing?!:
> --------------------------------------------------------
> [root@kek:~] cat /proc/mdstat
> Personalities : [raid1] [raid5]
> md1 : active raid1 hdc1[0] hda1[1]
>        1048704 blocks [2/2] [UU]
> 
> md2 : active raid5 sdc1[7] sda1[0] sdh1[8] sdg1[6] sdf1[5] sde1[4] sdb1[1]
>        720321792 blocks level 5, 128k chunk, algorithm 2 [7/5] [UU__UUU]

Looks like you've either got some really sick drives, or a sick
controller or drivers.  Try a newer kernel, and see if you can run
some tests in the drives.

NeilBrown
