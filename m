From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: 4 partition raid 5 with 2 disks active and 2 spare, how to force?
Date: Thu, 25 Mar 2010 04:37:00 -0700
Message-ID: <4877c76c1003250437r346e18en8da0f6f804bef634@mail.gmail.com>
References: <S1753093Ab0CYHZE/20100325072504Z+37@vger.kernel.org>
	 <2E4545D6-8F4E-4779-9103-960C52983A72@brillgene.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2E4545D6-8F4E-4779-9103-960C52983A72@brillgene.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman@brillgene.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 25, 2010 at 2:30 AM, Anshuman Aggarwal
<anshuman@brillgene.com> wrote:
> All, thanks in advance...particularly Neil.
>
> My raid5 setup has 4 partitions, 2 of which are showing up as spare a=
nd 2 as active. The mdadm --assemble --force gives me the following err=
or:
> 2 active devices and 2 spare cannot start device
>
> it is a raid 5, with superblock 1.2, 4 devices in the order sda1, sdb=
5, sdc5, sdd5. I have lvm2 on top of this with other devices ...so as y=
ou all know data is irreplaceable blah blah.
>
> I know that this device has not been written to for a while, so the d=
ata can be considered intact (hopefully all) if I can get the device to=
 start up...but I'm not sure of the best way to coax the kernel to asse=
mble it. Relevant information follows:
>
> =3D=3D=3D This device is working fine =3D=3D=3D
> mdadm --examine =A0-e1.2 /dev/sdb5
> /dev/sdb5:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
> =A0 =A0 =A0 =A0 =A0 Name : GATEWAY:127 =A0(local to host GATEWAY)
> =A0Creation Time : Sat Aug 22 09:44:21 2009
> =A0 =A0 Raid Level : raid5
> =A0 Raid Devices : 4
>
> =A0Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
> =A0 =A0 Array Size : 1758296832 (838.42 GiB 900.25 GB)
> =A0Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
> =A0 =A0Data Offset : 272 sectors
> =A0 Super Offset : 8 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : f8ebb9f8:b447f894:d8b0b59f:ca8e98eb
>
> Internal Bitmap : 2 sectors from superblock
> =A0 =A0Update Time : Fri Mar 19 00:56:15 2010
> =A0 =A0 =A0 Checksum : 1005cfbc - correct
> =A0 =A0 =A0 =A0 Events : 3796145
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 Device Role : Active device 2
> =A0 Array State : .AA. ('A' =3D=3D active, '.' =3D=3D missing)
>
> =3D=3D=3D This device is marked spare, can be marked active (IMHO) =3D=
=3D=3D
> mdadm --examine =A0-e1.2 /dev/sdd5
> /dev/sdd5:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
> =A0 =A0 =A0 =A0 =A0 Name : GATEWAY:127 =A0(local to host GATEWAY)
> =A0Creation Time : Sat Aug 22 09:44:21 2009
> =A0 =A0 Raid Level : raid5
> =A0 Raid Devices : 4
>
> =A0Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
> =A0 =A0 Array Size : 1758296832 (838.42 GiB 900.25 GB)
> =A0Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
> =A0 =A0Data Offset : 272 sectors
> =A0 Super Offset : 8 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : 763a832f:1a9a7ea8:ce90d4a3:32e8ae54
>
> Internal Bitmap : 2 sectors from superblock
> =A0 =A0Update Time : Fri Mar 19 00:56:15 2010
> =A0 =A0 =A0 Checksum : c78aab46 - correct
> =A0 =A0 =A0 =A0 Events : 3796145
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 Device Role : spare
> =A0 Array State : .AA. ('A' =3D=3D active, '.' =3D=3D missing)
>
>
> =3D=3D=3D This is the completely failed device (needs replacement) =A0=
 =A0=3D=3D=3D
> mdadm --examine =A0-e1.2 /dev/sda1
> [HANGS!!]
>
>
>
> I already have the replacement drive available as sde5 but want to be=
 able to reconstruct as much as possible)
>
> Thanks again,
> Anshuman Aggarwal--
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

You have a raid 5 array.

(drives then data+parity per drive as an example)
1234

123P
45P6
7P89
=2E..

You are missing two drives, meaning you lack parity and 1 data stripe
and have NO parity to recover it with.

It's like seeing:

=2E23.
=2E5P.
=2EP8.

and expecting to somehow recover the missing data when it is no longer
within the clean information.

Your only hope is to assemble the array in read only mode with the
other devices, if they can still even be read.  In that case you might
at least be able to recover nearly all of your data; hopefully any
missing areas are in unimportant files or non-allocated space.

At this point you should be EXTREMELY CAREFUL, and DO NOTHING, without
having a good solid plan in place.  Rushing /WILL/ cause you to loose
data that might still potentially be recovered.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
