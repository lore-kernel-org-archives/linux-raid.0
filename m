From: Robert Washburne <rcwash3@comcast.net>
Subject: Re: new raid system for home use
Date: Wed, 21 Apr 2004 09:24:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.3.0.1.20040421090309.01ad88b0@mail.comcast.net>
References: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca>
 <Pine.LNX.4.58.0404181253470.24065@spoon.loc>
 <4083F865.7070803@chemie.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4083F865.7070803@chemie.uni-erlangen.de>
References: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca>
 <Pine.LNX.4.58.0404181253470.24065@spoon.loc>
 <4083F865.7070803@chemie.uni-erlangen.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Grettengs!  This is my first post to the list.

On my system (a dedicated fileserver running gentoo Linux) I partition =
all=20
of my drives the same way:
P1 - 1 cyl - /boot
P2 - swap
P3 - 2G/RAID 5 - /
L5 - 4G/ext2 - / alternate
L* - 35G/RAID 5 - Storage partitions

I use lilo with a duel boot.
Default boot uses the RAID 5 root.
Secondary boot uses the ext2 root.  This partition is copied onto every=
 drive.

This way, I have all of the advantages of RAID 5 for my OS, but I can b=
oot=20
to a mundane partition if the RAID should break or needs maintanence (l=
ike=20
adding another drive).
If the boot drive dies, I can boot from CD and chroot to any of the=20
remaining drive's L5 partition.
I have tested both boots and it works quite well.  The cost in space is=
 4G=20
from a 250G drive.  About a 2% overhead.

It could be argued that this layout would be more efficient if root wer=
e=20
placed closer to the center of the cylinders.  But this is not a very=20
active machine.  It basicly holds my large multimedia files while they =
wait=20
their turn for processing (takes 100G to filter and process 1 hour of=20
video).  No data streaming applications.  So I took the mental shortcut=
=2E

Hope this is useful.

Bob W.

At 12:03 PM 4/19/2004, you wrote:
>Hi Paul!
>
>Paul Phillips schrieb:
>
>>I was under the impression that I can't boot off raid-5, but if that
>>information is dated then all the better.
>>Thanks again.
>
>Afaik, that=B4s still true. The reason is that the two (or more) drive=
s of a=20
>raid 1 essentially hold the same data, and if you do everything right,=
 the=20
>complete boot mechanism is on all disks, so that you can boot with any=
 of=20
>them. On raid 5 disks, you would never have the complete data on any o=
f=20
>the disks.
>
>Norman.
>
>--


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
