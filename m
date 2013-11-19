From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 19 Nov 2013 14:34:21 -0800
Message-ID: <CAGRSmLubN0dMAyQBYFNQuL1ym9vjDBUeVymHZJqZON8WQd87cw@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<CAGRSmLufpZV5qYa-jq17n_MTWY0oc9yX4USoc0PZsb1LJheGcQ@mail.gmail.com>
	<528BCC4A.5070201@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528BCC4A.5070201@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For cisco's server:

> mdadm --examine --scan
ARRAY metadata=ddf UUID=7ab254d0:fae71048:404edde9:750a8a05
ARRAY container=7ab254d0:fae71048:404edde9:750a8a05 member=0
UUID=5337ab03:86ca2abc:d42bfbc8:23626c78

> mdadm --assemble --scan --no-degraded -v >
mdadm: looking for devices for further assembly
mdadm: /dev/md/ddf0 is a container, but we are looking for components
mdadm: no RAID superblock on /dev/sdf
mdadm: no RAID superblock on /dev/md/MegaSR2
mdadm: no RAID superblock on /dev/md/MegaSR1
mdadm: no RAID superblock on /dev/md/MegaSR
mdadm: cannot open device /dev/sr0: No medium found
mdadm: /dev/sdd is busy - skipping
mdadm: /dev/sdc is busy - skipping
mdadm: /dev/sdb is busy - skipping
mdadm: /dev/sda is busy - skipping
mdadm: /dev/sde is busy - skipping
mdadm: looking for devices for further assembly
mdadm: looking in container /dev/md/ddf0
mdadm: member /md127/0 in /dev/md/ddf0 is already assembled
mdadm: Cannot assemble mbr metadata on /dev/sdf
mdadm: Cannot assemble mbr metadata on /dev/md/MegaSR2
mdadm: Cannot assemble mbr metadata on /dev/md/MegaSR1
mdadm: Cannot assemble mbr metadata on /dev/md/MegaSR
mdadm: cannot open device /dev/sr0: No medium found
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sde has wrong uuid.



On Tue, Nov 19, 2013 at 12:38 PM, Martin Wilck <mwilck@arcor.de> wrote:
> The question I have is why is there IMSM meta data on sdc2 at all?
> IMSM metadata sit at the end of a block device. So I figure that sdc2 is
> the last partition, and by some wird circumstance it's so large that it
> includes the last sectors of the physical disk where the metadata
> resides. That would be a bad idea, a dd if=/dev/zero of=/dev/sdc2 would
> wipe not only the partition but also the RAID meta data.
>
> Martin
>
