From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Alternative to RAID... No change to Data HDDs, only one simple "modulo"-Disk
Date: Fri, 18 Jun 2004 16:19:34 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406182019.i5IKJe327151@watkins-home.com>
References: <40D31476.8020002@pRiV.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40D31476.8020002@pRiV.de>
To: =?iso-8859-1?Q?'Markus_M=FCller'?= <mm@pRiV.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How do we read about this?
Your links don't seem to do much, just search.  I can't read any articl=
es.

My guess is that you don't know what you are talking about!
Or this is some sort of SPAM for leo.org

"- REAL SECURITY: You can recover with normal rescue programs!"
Does this indicate I can use tar to do backups?  This is not better tha=
n
RAID5, RAID1 or RAID6!

I hope I am wrong, sorry if I am.

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Markus M=FCller
Sent: Friday, June 18, 2004 12:13 PM
To: linux-raid@vger.kernel.org
Subject: Alternative to RAID... No change to Data HDDs, only one simple
"modulo"-Disk

Hi Linux RAID,

I don't want Linux Software RAID, because RAID 5 itself and/or the Linu=
x=20
Software RAID has unflexibility I don=B4t want to accept. These are esp=
ecialy:

Implementation independet, logical restrictions:
- With only one working disk of a raid 5 I can=B4t do anything, not to=20
mention to mount it alone
- I must trust the RAID algorithmus, because it needs and does do=20
writing to handle the data itself
- All hdd must be have the same size, ok, you can put langer in it, but=
=20
you=B4ll waste space
Linux Software RAID restrictions:
- Putting new Disk in the RAID is BETA and forces to dataloss
<http://dict.leo.org/?p=3D2Ib6..&search=3Dmention>
The only real advantage is the increased read- and writespeed as well a=
s=20
a single partition.

And now the clou: I don=B4t care about this advantages! So I prefer the=
=20
following solution:
<http://dict.leo.org/?p=3D2Ib6..&search=3Dadvantage>
You use your hdds as you wouldn=B4t want to use anything like RAID. The=
n=20
you insert a new hdd, which have at least the size of the bigest hdd in=
=20
computer. Then you make over all hdds for each byte, starting on every=20
disk at byte 0, a modulo 255, and write it to this new disk. Each read=20
access can be done as it would be done before, on every write to one of=
=20
these involved hdds you update over all disks the modulo and write it t=
o=20
this new disk. If the disks size differs of the different involved hdds=
,=20
you simply have on the higher bytes a modulo of the remaining disks. Fo=
r=20
example, you have a 60 GB, a 80 GB and a 120 GB disk. The new disk with=
=20
the modulo data is also 120 GBs. Then from 0 byte to 60 GBs you have a=20
modulo over 3 disks, from 60 to 80 you have a modulo over 2 disks and=20
the rest is a 1:1 copy of the 120 GB drive on this new 120 GB disk.

-> If a disk dies, you can restore it using the safed modulo data on=20
this new 120 GB disk.

The benefit? See the restrictions above. None of this applys on this=20
solution! But you have the same security benefit from RAID 5! The littl=
e=20
price for this solution: You loos is speed, and you do not a single=20
partition. I have a data dump, not a high performance raid, so I don=B4=
t=20
care about the speed. (Current hdds are fast enought, also for this=20
solution!) And I see multiple partition as a benefit. (personal opinion=
!)

Special Benefits:
- REAL SECURITY: You can resize your hdd selection without having the=20
fear of dataloss! This mechanismus don=B4t change your source hdds! It=20
only does need read access! It CAN=B4T do anything wrong with your data=
!
- REAL SECURITY: You can recover with normal rescue programs!
- FLEXIBILITY:: You can take any disk out of your system and simply=20
mount it!
- FLEXIBILITY: The size of the involved hdds doesn=B4t matter; the disk=
=20
with the modulo just must have the same size than the bigest hdd or mor=
e=20
of your hdd colletion.

And now the matter of price: Does anybody  have an idear how to=20
implement this? I am appreciate for any hint or comment.

Thanks,
Markus Mueller
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
