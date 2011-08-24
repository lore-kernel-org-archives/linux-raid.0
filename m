From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 5 to Raid 1 (half of the data not required)
Date: Wed, 24 Aug 2011 10:46:49 +1000
Message-ID: <20110824104649.1c5696c3@notabene.brown>
References: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 Aug 2011 19:41:11 -0400 Mike Viau <viaum@sheridanc.on.ca> wr=
ote:

>=20
> Hello,
>=20
> I am trying to convert my currently running raid 5 array into a raid =
1. All the guides I can see online are for the reverse direction in whi=
ch one is converting/migrating a raid 1 to raid 5. I have intentionally=
 only allocated exactly half of the total raid 5 size is. I would like =
to create the raid 1 over /dev/sdb1 and /dev/sdc1 with the data on the =
raid 5 running with the same drives plus /dev/sde1. Is this possible, I=
 wish to have the data redundantly over two hard drive without the pari=
ty which is present in raid 5?

Yes this is possible, though you will need a fairly new kernel (late 30=
's at
least) and mdadm.

And you need to be running ext3 because I think it is the only one you =
can
shrink.

1/ umount filesystem
2/ resize2fs /dev/md0 490G
     This makes the array use definitely less than half the space.  It =
is=20
     safest to leave a bit of slack for relocated metadata or something=
=2E
     If you don't make this small enough some later step will fail, and=
=20
     you can then revert back to here and try again.

3/ mdadm --grow --array-size=3D490G /dev/md0
    This makes the array appear smaller without actually destroying any=
 data.
4/ fsck -f /dev/md0
    This makes sure the filesystem inside the shrunk array is still OK.
    If there is a problem you can "mdadm --grow" to a bigger size and c=
heck
    again.=20

Only if the above all looks ok, continue.  You can remount the filesyst=
em at
this stage if you want to.

5/ mdadm --grow /dev/md0 --raid-disks=3D2

    If you didn't make the array-size small enough, this will fail.
    If you did it will start a 'reshape' which shuffles all the data ar=
ound
    so it fits (With parity) on just two devices.

6/ mdadm --wait /dev/md0
7/ mdadm --grow /dev/md0 --level=3D1
    This instantly converts a 2-device RAID5 to a 2-device RAID1.
8/ mdadm --grow /dev/md0 --array-size=3Dmax
9/ resize2fs /dev/md0
     This will grow the filesystem up to fill the available space.

All done.

Please report success or failure or any interesting observations.

NeilBrown


>=20
> Thanks for any help in advance :)
>=20
>=20
> # mdadm -D /dev/md0
> /dev/md0:
> =A0=A0=A0=A0=A0=A0=A0 Version : 1.2
> =A0 Creation Time : Mon Dec 20 09:48:07 2010
> =A0=A0=A0=A0 Raid Level : raid5
> =A0=A0=A0=A0 Array Size : 1953517568 (1863.02 GiB 2000.40 GB)
> =A0 Used Dev Size : 976758784 (931.51 GiB 1000.20 GB)
> =A0=A0 Raid Devices : 3
> =A0 Total Devices : 3
> =A0=A0=A0 Persistence : Superblock is persistent
>=20
> =A0=A0=A0 Update Time : Tue Aug 23 11:34:00 2011
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
> =A0Active Devices : 3
> Working Devices : 3
> =A0Failed Devices : 0
> =A0 Spare Devices : 0
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
> =A0=A0=A0=A0 Chunk Size : 512K
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : HOST:0=A0 (local to host HOST)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f=
81e9
> =A0=A0=A0=A0=A0=A0=A0=A0 Events : 55750
>=20
> =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
> =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
> =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
> =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde1
>=20
>=20
> -M
>  		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
