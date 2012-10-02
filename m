From: NeilBrown <neilb@suse.de>
Subject: Re: MD RAID Bug 7/15/12
Date: Tue, 2 Oct 2012 12:25:52 +1000
Message-ID: <20121002122552.7ba6fbb6@notabene.brown>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com>
	<20121001130242.745b7ca3@notabene.brown>
	<42BA87F6-C5A3-4321-A4C7-0DCF0A9DF79D@rightthisminute.com>
	<FB3CC1EE-F6BD-4446-ADBA-0DC792AAA3DC@rightthisminute.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U2kY0e2lJjKDSpiz15M5Ipt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FB3CC1EE-F6BD-4446-ADBA-0DC792AAA3DC@rightthisminute.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Munoz <mark.munoz@rightthisminute.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/U2kY0e2lJjKDSpiz15M5Ipt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Oct 2012 18:51:09 -0700 Mark Munoz <mark.munoz@rightthisminute.co=
m>
wrote:

> Neil,
>=20
> Thank you again so much for taking time out of your day to personally hel=
p me it really means a lot.  I have ran the command and have successfully r=
ecreated my md1  Now however md2 will not assemble.  I get this error.
>=20
> sudo mdadm --assemble --force /dev/md2 /dev/md0 /dev/md1
> mdadm: superblock on /dev/md1 doesn't match others - assembly aborted
>=20
> Would I be correct in thinking that I just need to recreate md2 now as we=
ll?

Maybe, but probably not.
I would think it more likely that md1 wasn't created quite right - otherwise
it should have the right metadata.

What does:
  mdadm -E /dev/md1
display now?  How does that compare with "mdadm -E /dev/md0" ?

What about
   mdadm -E /dev/sdaf
(or any other device in md1)?  How does that compare to what was displayed
previously?

NeilBrown


>=20
> I assume with this command?
>=20
> sudo mdadm --create --assume-clean /dev/md2 --level=3D0 --chunk=3D64 --me=
tadata=3D1.2 --raid-devices=3D2 /dev/md0 /dev/md1
>=20
> Mark Munoz
>=20
> On Oct 1, 2012, at 2:00 PM, Mark Munoz <mark.munoz@rightthisminute.com> w=
rote:
> >=20
> >> On Sat, 29 Sep 2012 17:12:40 -0700 Mark Munoz
> >> <mark.munoz@rightthisminute.com> wrote:
> >>=20
> >>> Hi I appear to have been affected by the bug you found on 7/15/12.  T=
he data I have on this array is really important and I want to make sure I =
get this correct before I actually make changes.
> >>>=20
> >>> Configuration:
> >>> md0 is a RAID 6 volume with 24 devices and 1 spare.  It is working fi=
ne and was unaffected.
> >>> md1 is a RAID 6 volume with 19 devices and 1 spare.  It was affected.=
  All the drives show as unknown raid level and 0 devices.  With the except=
ion of device 5.  It has all the information.
> >>>=20
> >>> Here is the output from that drive:
> >>>=20
> >>> serveradmin@hulk:/etc/mdadm$ sudo mdadm --examine /dev/sdaf
> >>> /dev/sdaf:
> >>>         Magic : a92b4efc
> >>>       Version : 1.2
> >>>   Feature Map : 0x0
> >>>    Array UUID : 6afb3306:144cec30:1b2d1a19:3a56f0d3
> >>>          Name : hulk:1  (local to host hulk)
> >>> Creation Time : Wed Aug 15 16:25:30 2012
> >>>    Raid Level : raid6
> >>>  Raid Devices : 19
> >>>=20
> >>> Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
> >>>    Array Size : 99629024416 (47506.82 GiB 51010.06 GB)
> >>> Used Dev Size : 5860530848 (2794.52 GiB 3000.59 GB)
> >>>   Data Offset : 2048 sectors
> >>>  Super Offset : 8 sectors
> >>>         State : clean
> >>>   Device UUID : 205dfd9f:9be2b9ca:1f775974:fb1b742c
> >>>=20
> >>>   Update Time : Sat Sep 29 12:22:51 2012
> >>>      Checksum : 9f164d8e - correct
> >>>        Events : 38
> >>>=20
> >>>        Layout : left-symmetric
> >>>    Chunk Size : 4K
> >>>=20
> >>>  Device Role : Active device 5
> >>>  Array State : AAAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D mis=
sing)
> >>>=20
> >>> Now I also have md2 which is a striped RAID of both md0 and md1.
> >>>=20
> >>> When I type:
> >>>=20
> >>> sudo mdadm --create --assume-clean /dev/md1 --level=3D6 --chunk=3D4 -=
-metadata=3D1.2 --raid-devices=3D19 /dev/sdaa /dev/sdab /dev/sdac /dev/sdad=
 /dev/sdae /dev/sdaf /dev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/sdak /dev=
/sdal /dev/sdam /dev/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sdar /dev/sdas
> >>>=20
> >>> the following error for each device.
> >>>=20
> >>> mdadm: /dev/sdaa appears to be part of a raid array:
> >>>   level=3D-unknown- devices=3D0 ctime=3DWed Aug 15 16:25:30 2012
> >>> mdadm: partition table exists on /dev/sdaa but will be lost or
> >>>      meaningless after creating array
> >>>=20
> >>> I want to make sure by running this above command that I won't affect=
 any of the data of md2 when I assemble that array after creating md1.  Any=
 help on this issue would be greatly appreciated.  I would normally just DD=
 copies but as you can see I would have to buy 19 more 3TB hard drives as w=
ell as the time to DD each drive.  It is a production server and that kind =
of down time would really rather be avoided. =20
> >>=20
> >> Running this command will only overwrite the 4K of metadata, 4K from t=
he
> >> start of the devices.  It will not write anything else to any device.
> >>=20
> >> so yes, it is safe.
> >>=20
> >> NeilBrown
> >>=20
> >>=20
> >>=20
> >>>=20
> >>> Thank you so much for your time.
> >>>=20
> >>> Mark Munoz
> >>> 623.523.3201--
> >>> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>=20
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/U2kY0e2lJjKDSpiz15M5Ipt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGpQsDnsnt1WYoG5AQK80g//ZlZe0xCat4NHnrbhjTycyIR59aqgXrkk
cvNC591jdiha5eQ2/tIeat6VhnQurX68a4z1OqhZx+FiJBBG2QcYWOl+ECs8u0SA
8VBYAJ+qUZbmjxn5WVIoHGAbL+valXDz0aVztfYcvCMuB0+HXtfOHz/4ai0cJlee
NvbCWjrIpW6P4fNh/jx26jRJDncBLF3pAXzEZTljO9tAUmGWseRoAfLPlnvsi74h
udEHebBx29o1AlWjHzmDALgQwvpUMGA+v/YJ42TPKacFFJkYl6dOYH2/OUyxvdzV
vYBOfoKLWRHjSEsjFfONj/1DbQINgB+TNpIS3GkUTne3dpS59SgOc2gI5gnFyiL1
hKNb8jLCDAWiJaZyesWJqL+Ies/6GOqBtbmICPj985Yc+b0gRFXXZBuU93/Yn+OI
Lz8PP3dpeupAw+lWM21M7WT34UwyoyL09sZC4bhRK7Bet+jJXqlJIU/XlT8wUMO/
/uQ2t5cDTNTsvwXSbQr+fCVMdFJshqkSBT7GzbpnGo4AVjnKeqlgc+PV9hplmVKK
2frJRK5O1v0aLdStiQnj39Ipkf4UGrBoSpRElSZh2pGWPhE2Doq+/7s8Sw70Z1mM
GTOLnAfy+K4bL6SCdbqLozP9pDxDCDeXlgK208NyLjVRZP7rf6/WokJLbRkt3yrF
tygKcBOdr68=
=cDVb
-----END PGP SIGNATURE-----

--Sig_/U2kY0e2lJjKDSpiz15M5Ipt--
