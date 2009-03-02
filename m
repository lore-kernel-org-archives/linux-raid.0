From: =?UTF-8?B?UsOpbWk=?= PALANCHER <remi.palancher@inria.fr>
Subject: Re: mdadm RAID5 re-assemble issue
Date: Mon, 2 Mar 2009 20:16:43 +0100
Message-ID: <20090302201643.17a2ff72@chercheurs2-241.futurs.inria.fr>
References: <20090216133450.5c700c09@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090216133450.5c700c09@laptop>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le Mon, 16 Feb 2009 13:34:50 +0100,
R=C3=A9mi PALANCHER <remi.palancher@inria.fr> a =C3=A9crit :

> Hi there,
>=20
> I've been a happy and successful mdadm user for a while now, but
> unfortunately, I met a problem recently.
>=20
> I use mdadm to manage a RAID5 array with 5 disks and 1 spare. The
> devices in the array are sda5, sdb1, sdc1, sdd1, sde1 and sdf1. Befor=
e
> things start to go wrong, sdb1 device was the spare and the other
> devices were active in the array. Here is this configuration as shown
> by the logs:
>=20
> [85054.372171] RAID5 conf printout:
> [85054.372175]  --- rd:5 wd:4
> [85054.372177]  disk 0, o:1, dev:sdc1
> [85054.372179]  disk 1, o:1, dev:sde1
> [85054.372181]  disk 2, o:1, dev:sda5
> [85054.372183]  disk 3, o:1, dev:sdd1
> [85054.372185]  disk 4, o:0, dev:sdf1
>=20
> Last thursday, a problem occured on sdf1 and mdadm started recovering
> the array with sdb1 as expected. But sdb1 have had a problem too
> during the recovery process, but the array continued to run properly
> with the last good 4 devices. I can attach logs if needed. Actually,
> sdb1 was defective, and I removed it physically from the server.
>=20
> But here is the output when I try to reassemble the array with the
> remaining devices:
> # mdadm --assemble /dev/md0 --force \
> --verbose /dev/sda5 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda5 is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot -1.
> mdadm: added /dev/sdd1 to /dev/md0 as 1
> mdadm: no uptodate device for slot 2 of /dev/md0
> mdadm: added /dev/sdc1 to /dev/md0 as 3
> mdadm: no uptodate device for slot 4 of /dev/md0
> mdadm: added /dev/sda5 to /dev/md0 as 5
> mdadm: added /dev/sde1 to /dev/md0 as -1
> mdadm: added /dev/sdb1 to /dev/md0 as 0
> mdadm: /dev/md0 assembled from 3 drives and 2 spares - not enough to
> start the array.
>=20
> I can understand why sde1 (previously sdf1) cannot take an active
> slot, but why does sda5 wanna take slot5 instead of slot2, as it was
> previously?
>=20
> Is there any way to force it?

=46YI, I finally found a (ugly) way to force sda5 to take slot2 by doin=
g
this:

# mdadm --run /dev/md0
(An error was shown here, but devices appeared in /sys regardless)
# cat /sys/block/md0/md/dev-sda5/slot
5
# echo 2 > /sys/block/md0/md/dev-sda5/slot
# mount -o ro /dev/md0

It's quite ugly and probably not the best way to do it, but fortunately
it worked!

--=20
R=C3=A9mi PALANCHER             Ing=C3=A9nieur associ=C3=A9
Administrateur syst=C3=A8mes et r=C3=A9seaux Grid'5000
INRIA Saclay                      B=C3=A2timent H
tel : 01 74 85 42 45            Bureau : 015=20
mob : 06 31 99 95 17                      =20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
