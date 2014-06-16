From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Mon, 16 Jun 2014 06:19:12 -0700
Message-ID: <CAK2H+ef9ATxhCrLfSEjB=pe2YbJaca_UrguDYA8qNZZBD8vbPA@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
	<539E5504.1080809@turmel.org>
	<CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jun 16, 2014 at 5:36 AM, Nuno Magalh=C3=A3es <nunomagalhaes@eu.=
ipp.pt> wrote:
<SNIP>
>
> Are there any - recommended - consumer-grade drives out there that do
> support TLER? I was going for 1TB@7200, but that can change. I starte=
d
> disliking Seagate after a ST31000528AS died on me. They bought Maxtor
> a long time ago and recently bought Samsung's disk division. I've had
> no qualms with Toshiba. I'm not so sure on WD, they used to be less
> that good; and haven't tried Hitachi. What say you?
>


I've been using WD 500GB RAID Edition drives for over 4 years now. Now
problems at all.

As for 'consumer grade' I don't know. I just purchased two WD Red 3TB
drives for a RAID1. The drives are in the box but not in use yet. They
do include the error timing feature Phil pointed out. I can say from
experience that some WD Green drives I had quite awhile ago did not
have TLER and the RAID had problems with the drives being dropped.
Listen to Phil and get a drive that supports this feature.

c2RAID6 ~ # smartctl -l scterc /dev/sda
smartctl 6.1 2013-03-16 r3800 [x86_64-linux-3.12.22-gentoo] (local buil=
d)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

c2RAID6 ~ #

BTW: I'm the OP on the RAID6 VM slow boot thread you referenced
earlier. My plan of action since then is:

1) Move system from the 5-drive SATA2 RAID6 to the new 2-drive SATA3 RA=
ID1
2) If performance is still lacking investigate using four of the
existing SATA2 500GB drives in a RAID10
3) If warranted investigate using my 120GB SSD with bcache (or
equivalent) in front of the RAID10.

My current power supply has 8 SATA drive power connectors all in use
this morning. (5 RAID6, 2 RAID1, 1 CDROM -> 2 RAID1, 4 RAID10, 1 SSD,
1 CDROM)

mark@c2RAID6 ~ $ lsblk
NAME    MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda       8:0    0   2.7T  0 disk
sdb       8:16   0   2.7T  0 disk
sdc       8:32   0 465.8G  0 disk
|-sdc1    8:33   0  54.9M  0 part
|-sdc2    8:34   0     4G  0 part  [SWAP]
`-sdc3    8:35   0 461.7G  0 part
  `-md3   9:3    0   1.4T  0 raid6 /
sdd       8:48   0 465.8G  0 disk
|-sdd1    8:49   0  54.9M  0 part
|-sdd2    8:50   0     4G  0 part  [SWAP]
`-sdd3    8:51   0 461.7G  0 part
  `-md3   9:3    0   1.4T  0 raid6 /
sde       8:64   0 465.8G  0 disk
|-sde1    8:65   0  54.9M  0 part
|-sde2    8:66   0     4G  0 part  [SWAP]
`-sde3    8:67   0 461.7G  0 part
  `-md3   9:3    0   1.4T  0 raid6 /
sdf       8:80   0 465.8G  0 disk
|-sdf1    8:81   0   4.1G  0 part
`-sdf3    8:83   0 461.7G  0 part
  `-md3   9:3    0   1.4T  0 raid6 /
sdg       8:96   0 465.8G  0 disk
|-sdg1    8:97   0   4.1G  0 part
`-sdg3    8:99   0 461.7G  0 part
  `-md3   9:3    0   1.4T  0 raid6 /
sr0      11:0    1  1024M  0 rom
mark@c2RAID6 ~ $

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
