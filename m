From: Johannes 'fish' Ziemke <fish@freigeist.org>
Subject: Re: mdadm /dev/md0 --detail returns nothing / no LUKS partition
Date: Tue, 8 Sep 2009 23:20:27 +0200
Message-ID: <20090908212027.GF2324@freigeist.org>
References: <20090908204525.GE2324@freigeist.org> <1e068e85fdd495e55ba8c55bc21f386f.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1e068e85fdd495e55ba8c55bc21f386f.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello NeilBrown

> On Wed, September 9, 2009 6:45 am, Johannes 'fish' Ziemke wrote:
> > Hi,
> >
> > i'v moved my four raid5 discs from one system to another. There is a
> > dmcrypt/luks encrypted xfs on it.
> >
> > mdadm seems to autodetect everything correctly:
> >
> > cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md0 : active raid5 sdd1[1] sdc1[3] sdb1[0] sda1[2]
> >       4395407808 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> >
> >
> > mdadm /dev/md0
> > /dev/md0: 4191.79GiB raid5 4 devices, 0 spares. Use mdadm --detail for
> > more detail.
> >
> >
> > But 'mdadm /dev/md0 --detail' outputs nothing.
> 
> You want
>    mdadm --detail /dev/md0
> 
> I guess I should fix that.


Damn, how stupid I am..
Sorry, than I guess its more an dmcrypt issue..

Thanks!
