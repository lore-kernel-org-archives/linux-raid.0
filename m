From: "A. James Lewis" <james@fsck.co.uk>
Subject: bizarre data corruption...
Date: Sat, 11 Dec 2004 16:27:14 -0000 (GMT)
Message-ID: <43305.212.158.231.74.1102782434.squirrel@mail.fsck.co.uk>
Reply-To: james@fsck.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have a little story to tell, which I hope will ring a bell with some =
of
you folk, perhaps somone knows how this could happen, or has had it hap=
pen
to you!

A little while ago, I built a box to host a large raid array, 8x200Gb
ATA100 disks... I first set it up as RAID5 and 2 disks failed in the sa=
me
day I'm cursed!.. So on the second attempt I used RAID6 (With the patch
which was posted here a few weeks ago to avoid corruption when partiall=
y
degraded).

All was well, or so it seemed, and I had a lovely new array of 1.14Tb t=
o
store files on...

But when populating with files from various sources, I noticed that som=
e
files which should show up as duplicates were not, and on further
investication I discovered that about once per 1Gb written to the array=
, 1
bit was inverted when the file was read back...

I syspected the machine, since it was a Dual Athlon 2200+ built from pa=
rts
I had left over from other projects, and it was in need of a BIOS upgra=
de
despirately... So I bought a nice new Supermicro/Serverworks XEON board
and transplanted that...

I noticed that now, in the logs I was getting occasional DMA status err=
ors
on 1 of the busses... So I thanked my lucky stars that the Serverworks
shipset/driver had spotted what the AMD chipset did not, and replaced
those 2 disks with spares...   After the resync fsck was a complete mes=
s,
and I decided that the best thing to do would be to try and get an easi=
ly
repeatable scenerio where the problem could be demonstrated...

The machine has 4 IDE busses and 8 drives... 2 onboard and 2 using HPT3=
71
single channel IDE cards...  each drive has a 1Gb swap partition... so =
I
turned the swap off... and wrote random data from /dev/urandom to the
first swap partition, and then back into a file... (So as to get the si=
ze
right).. This file was then written to each of the swap partitions and
those were then checked with cksum... 10 times... no errors.

Next I tried writing the file to all the swap partitions concurrently..=
=2E
same result, no corruption...

So I tried reading the data back from each drive concurrently... this
yielded a consistently corrupted file (only by a few bytes, but still
corrupted)... from the disks on the secondary onboard IDE bus.

At this point, I have changed the motherboard, the disks, the cable...
well, ALL the hardware.... I eventually solved the imediate problem wit=
h
another HPT371 controller for that bus... but it seems that anything on
the secondary onboard controller will be randomly corrupted in a raid
configuration where all the drives are read at the same time...

This happened with 2 motherboards using 2 different chipsets, but ALL t=
he
hardware was changed, even the brand of the replacement disks was
different... so I am left wondering if this could be a kernel bug??  I
can't say for 100% sure if the problem was identical before with the
previous motherboard, but the chances of getting 1 or 2 bits corrupted =
per
Gb of data  using 2 completely different motherboard/disk combinations
(even the PSU was changed!) is pretty remote, leaving me to ask if it
could have been the kernel?

It would have to be common to the Serverworks, and AMD 760 MP chipsets.=
=2E.
which seems unbelievably unlikley, but I am running out of ideas..

Otherwise, I love RAID6... I would have lost a whole lot of data over t=
his
if I'd still been using RAID5...

--=20
=AF=B7.=B8=B8.=B7=B4=AF=B7.=B8=B8.-> A. James Lewis (james@fsck.co.uk)
http://www.fsck.co.uk/personal/nopistons.jpg
MAZDA - World domination through rotary power.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
