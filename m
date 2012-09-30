From: Chris Murphy <lists@colorremedies.com>
Subject: Re: MD RAID Bug 7/15/12
Date: Sun, 30 Sep 2012 16:16:57 -0600
Message-ID: <B09EC2F5-55B5-48A8-B427-81277CF3D136@colorremedies.com>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com> <A65170A9-BE4D-4B22-B1CE-2FFE10928DDD@colorremedies.com> <5068B4BF.6000807@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5068B4BF.6000807@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 30, 2012, at 3:08 PM, Stefan /*St0fF*/ H=FCbner wrote:


> Also off topic: 12 drives would be as "nearly unalignable" as 19 are.

I'm not sure what you mean by unalignable. A separate question is if a =
4K chunks size is a good idea, even with 24 disks, but I'm unsure of th=
e usage and workload.



On Sep 29, 2012, at 6:12 PM, Mark Munoz wrote:

> sudo mdadm --create --assume-clean /dev/md1 --level=3D6 --chunk=3D4 -=
-metadata=3D1.2 --raid-devices=3D19 /dev/sdaa /dev/sdab /dev/sdac /dev/=
sdad /dev/sdae /dev/sdaf /dev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/s=
dak /dev/sdal /dev/sdam /dev/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sd=
ar /dev/sdas
>=20
> the following error for each device.
>=20
> mdadm: /dev/sdaa appears to be part of a raid array:
>    level=3D-unknown- devices=3D0 ctime=3DWed Aug 15 16:25:30 2012
> mdadm: partition table exists on /dev/sdaa but will be lost or
>       meaningless after creating array
>=20
> I want to make sure by running this above command that I won't affect=
 any of the data of md2 when I assemble that array after creating md1. =
 Any help on this issue would be greatly appreciated.  I would normally=
 just DD copies but as you can see I would have to buy 19 more 3TB hard=
 drives as well as the time to DD each drive.  It is a production serve=
r and that kind of down time would really rather be avoided. =20


That metadata should be stored elsewhere. If I'm understanding the logi=
c correctly the RAID 6 metadata would be on all /dev/sdaX disks at offs=
et 2048. And the RAID 0 metadata would be on /dev/md0 and /dev/md1 at o=
ffset 2048. I'd make certain that /dev/md0 is not mounted, and that nei=
ther md0 nor md1 are scheduled for a repair scrubbing which would likel=
y cause problems when it comes time to marry the two RAID 6's back toge=
ther again.

Maybe not necessary, since you aren't missing any disk, but after creat=
e you could do 'echo check > /sys/block/md0/md/sync_action' and check /=
sys/block/md0/md/mismatch_cnt. If both RAID 6's are happy, then you can=
 deal with the RAID 0, and check the file system with -n or equivalent =
to report problems but not make repairs.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
