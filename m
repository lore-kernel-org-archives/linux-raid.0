From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller
Date: Sun, 15 May 2016 17:31:21 +0200
Message-ID: <20160515153121.GA11365@EIS.leimen.priv>
References: <20160515124534.A42D0100879@atlas.denx.de>
 <20160515133740.85EC3100879@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160515133740.85EC3100879@atlas.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 15, 2016 at 03:37:40PM +0200, Wolfgang Denk wrote:
> Trying to follow the overlay method in [1], I run into errors; guess I
> must be missing something:
>
> [1] https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

I think you mixed two approaches to the same thing, the wiki shows
a) how to create overlays manually and b) offers some convenience 
functions that do the same thing (the overlay create remove functions, 
you define those functions once and then you can repeatedly call them, 
basically giving you two commands overlay_create and overlay_remove).

It should work if you use only this part:

> # devices="/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf"
> # overlay_create()
> > {
> >         free=$((`stat -c '%a*%S/1024/1024' -f .`))
> >         echo free ${free}M
> >         overlays=""
> >         overlay_remove
> >         for d in $devices; do
> >                 b=$(basename $d)
> >                 size_bkl=$(blockdev --getsz $d) # in 512 blocks/sectors
> >                 # reserve 1M space for snapshot header
> >                 # ext3 max file length is 2TB   
> >                 truncate -s$((((size_bkl+1)/2)+1024))K $b.ovr || (echo "Do you use ext4?"; return 1)
> >                 loop=$(losetup -f --show -- $b.ovr)
> >                 # https://www.kernel.org/doc/Documentation/device-mapper/snapshot.txt
> >                 dmsetup create $b --table "0 $size_bkl snapshot $d $loop P 8"
> >                 echo $d $((size_bkl/2048))M $loop /dev/mapper/$b
> >                 overlays="$overlays /dev/mapper/$b"
> >         done
> >         overlays=${overlays# }
> > }
> # overlay_remove()
> > {
> >         for d in $devices; do
> >                 b=$(basename $d)
> >                 [ -e /dev/mapper/$b ] && dmsetup remove $b && echo /dev/mapper/$b 
> >                 if [ -e $b.ovr ]; then
> >                         echo $b.ovr
> >                         l=$(losetup -j $b.ovr | cut -d : -f1)
> >                         echo $l
> >                         [ -n "$l" ] && losetup -d $(losetup -j $b.ovr | cut -d : -f1)
> >                         rm -f $b.ovr &> /dev/null
> >                 fi
> >         done
> > }

And then call 'overlay_create' when you want your overlays, 
and 'overlay_remove; overlay create' when an experiment 
failed and you want to reset them to their original state.

At the time you remove the overlays, all things using them 
must also be gone, so mdadm --stop before overlay_remove. 
(And make sure no raid is running for the disks you're 
overlaying...)

As for your controller, I don't know this controller. If it's a HW-RAID 
that passes individual disks through as RAID-0, usually some sectors of 
the disk are missing (controller has to keep RAID-0 metadata somewhere) 
and that alone might be enough to damage your old setup in some way.

I prefer "dumb" controllers that pass through disks the way they are.

You showed --detail output of your old RAID; that's already very good, 
is there --examine output by any chance? --detail doesn't contain some 
things such as data offsets, and the ones mdadm picks by default have 
changed a lot, so the same --create command won't actually produce 
the same RAID. If your old RAID metadata is actually lost, if you wish 
to experiment with --create on the overlay, you'll have to specify all 
variables you know and guess the variables you don't know...

Regards
Andreas Klauer
