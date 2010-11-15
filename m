From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Mon, 15 Nov 2010 08:52:32 +0200
Message-ID: <4CE0D8B0.4050603@geograph.co.za>
References: <4CE00206.4000301@geograph.co.za> <20101114195036.GA23982@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101114195036.GA23982@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010-11-14 21:50, Luca Berra wrote:
> On Sun, Nov 14, 2010 at 05:36:38PM +0200, Zoltan Szecsei wrote:
>>
>> *Partition alignment?
>> Is this relevant for modern HDs (I'm using 5900rpm Seagate 2TB drive=
s)
> for modern hdds with 4k sectors it is
> new fdisk and/or parted should already know how to align
fdisk reports 512b sectors:
root@gs0:/home/geograph# fdisk -lu

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util=20
fdisk doesn't support GPT. Use GNU Parted.

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
256 heads, 63 sectors/track, 242251 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1              63  3907024127  1953512032+  fd  Linux raid=20
autodetect

(All 8 disks are as above)


> in any case, since you want to use the whole space for raid, why crea=
te
> partitions at all, md works nicely without
OK

>
>> *Chunk size:
>> After reading MANY different opinions, I'm guessing staying at the=20
>> default chunk size is optimal? Anyone want to add to this argument?
> i believe the default in newer mdadm is fine
>
>>
>> *After partitioning the 8 drives, is this the correct sequence?
>> mdadm --create /dev/md0 --metadata=3D1.2 --auto=3Dmd --chunk=3D64=20
>> --level=3Draid6=20
> why you state the chunk size here, i tought you wanted to stay with t=
he
> defauklt
because on my mdadm, 64 is the default - and I was just re-enforcing=20
that for the reader.
root@gs0:/home/geograph# mdadm -V
mdadm - v2.6.7.1 - 15th October 2008
root@gs0:/home/geograph#
>> *After this, do I mkfs ext4 first, or LVM first?
> if you want to use lvm it would be lvm first, but... do you want to?
> there is no point if the aim is allocating the whole space to a singl=
e
> filesystem.
Because I might want to join this array to another one at a later stage=
=20
- I would then have 2 boxes each with 8 drives, and each with a SiI3132=
=20
card on the same motherboard.
I might use the second box to mirror the first, or to extend it - not=20
sure of my needs yet.


>
>> *What stride and stripe values should I use?
> new toolstack should already find the correct stripe/stride for you
How would I check ?

root@gs0:/home/geograph# mkfs.ext4 -V
mke2fs 1.41.11 (14-Mar-2010)
         Using EXT2FS Library version 1.41.11
root@gs0:/home/geograph#
>
> one more note:
> for such a big array i would suggest to create a bitmap, so in case o=
f
> an unclean shutdown you do not have to wait for 27 hours for it to
> rebuild. an internal bitmap will do.
>
Nice tip - I'll look into it - Thanks,
Zoltan


--=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Zoltan Szecsei PrGISc [PGP0031]
Geograph (Pty) Ltd.
P.O. Box 7, Muizenberg 7950, South Africa.

65 Main Road, Muizenberg 7945
Western Cape, South Africa.

34=B0 6'16.35"S 18=B028'5.62"E

Tel: +27-21-7884897  Mobile: +27-83-6004028
=46ax: +27-86-6115323     www.geograph.co.za
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 10.0.1153 / Virus Database: 424/3256 - Release Date: 11/14/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
