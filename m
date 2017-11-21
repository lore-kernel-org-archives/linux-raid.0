From: Santiago DIEZ <santiago.diez@caoba.fr>
Subject: Re: Impossibly level change request for RAID1
Date: Tue, 21 Nov 2017 12:18:03 +0100
Message-ID: <CAJh8RqWc_jtGQ-Sm-SJLfYcSK75NwfcvOTp09R-7ees2amtYwA@mail.gmail.com>
References: <CAJh8RqV84uXJ9hV4uSAK-GsnN=FP4fT-S0VNNkSVOay5xZqt8w@mail.gmail.com>
 <5A0C760E.9010105@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A0C760E.9010105@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Wol,

This indeed fixed the problem. What I did for the record and for any
newbie reading this post:

# Regrow the RAID1 to 5 devices (this fixed the weird removed messages)
sudo mdadm /dev/md9 --grow --raid-devices=5

# Make 3 disks faulty
sudo mdadm /dev/md9 --fail /dev/sdc9
sudo mdadm /dev/md9 --fail /dev/sdd9
sudo mdadm /dev/md9 --fail /dev/sde9

# Remove 3 disks
sudo mdadm /dev/md9 --remove /dev/sdc9
sudo mdadm /dev/md9 --remove /dev/sdd9
sudo mdadm /dev/md9 --remove /dev/sde9

# Reduce the number of devices in RAID1
sudo mdadm /dev/md9 --grow --raid-devices=2

# Re-attach the 3 disks (they become spare)
sudo mdadm /dev/md9 --add /dev/sdc9
sudo mdadm /dev/md9 --add /dev/sdd9
sudo mdadm /dev/md9 --add /dev/sde9

# Change the level of raid
sudo mdadm /dev/md9 --grow --level=5 --raid-devices=5

# Then wait about 24h for the raid to reshape!

-------------------------
Santiago DIEZ
Quark Systems & CAOBA
23 rue du Buisson Saint-Louis, 75010 Paris
-------------------------

On Wed, Nov 15, 2017 at 6:14 PM, Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 15/11/17 16:52, Santiago DIEZ wrote:
> > Hi,
> >
> > I started by mistake a raid as RAID1 with 5 disks when my desire was
> > to start it as RAID5. Technically, there is no data at all so I could
> > entirely recreate the raid but this is NOT what I want. I'm taking
> > this opportunity as an exercise to change a raid level.
> >
> > The initial state of the raid is:
> > md9 : active raid1 sda9[0] sdb9[1] sdc9[2] sdd9[3] sde9[4]
> >       5846755328 blocks super 1.2 [5/5] [UUUUU]
> >       bitmap: 0/44 pages [0KB], 65536KB chunk
> >
> > # I tried to change the level with:
> > mdadm /dev/md9 --grow --level=5
> > # But got the error :
> > mdadm: Impossibly level change request for RAID1
>
> I'll leave the rest for someone else (or maybe me later :-) but just to
> explain the "impossible level change", you cannot change a mirror with
> more than two active devices. You need to have two active, three spares,
> before it will change.
>
> Cheers,
> Wol
