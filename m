From: NeilBrown <neilb@suse.de>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Sun, 24 Aug 2014 16:45:07 +1000
Message-ID: <20140824164507.4954df45@notabene.brown>
References: <20140823163110.GE11855@bitfolk.com>
	<20140824130939.461501b4@notabene.brown>
	<E78FE8BDBAD07C43A60163E7D1716EEC0183A72805@PROSIS-W2K8-1.prosis.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/J5Yybg+E6/+D=4Z/olYsHmr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E78FE8BDBAD07C43A60163E7D1716EEC0183A72805@PROSIS-W2K8-1.prosis.local>
Sender: linux-raid-owner@vger.kernel.org
To: Craig Curtin <craigc@prosis.com.au>
Cc: Andy Smith <andy@strugglers.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/J5Yybg+E6/+D=4Z/olYsHmr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 24 Aug 2014 06:28:25 +0000 Craig Curtin <craigc@prosis.com.au> wrot=
e:

> Neil,
>=20
> I assume you would need to shrink the filesystem first before this ? or d=
oes MDADM nicely do that as part of the process also ?

mdadm is not a jack-of-all-trades.  It won't touch your filesystem.

A careful look at Andy's "mdadm --detail" shows:

> >      Array Size : 471859200 (450.00 GiB 483.18 GB)
> >   Used Dev Size : 309363520 (295.03 GiB 316.79 GB)

This is a near=3D2 6 drive RAID10, so Array Size should be 3 times Used Dev
Size.
The fact that it isn't shows that he has already explicitly set the
--array-size to something appropriate.   I'm sure he reduced the size of the
filesystem first as the man page says:

              Before  reducing the size of the array you should make sure t=
hat
              space isn't needed.  If the device holds a filesystem, you wo=
uld
              need to resize the filesystem to use less space.

If you try to resize an array to fewer drives and you haven't adjusted the
--array-size already, mdadm will tell you what --array-size you need.  This
forces you into a two (at least) step process to minimize the chance of doi=
ng
something silly.
The idea is that you "--grow --array-size" first, then use "fsck" to make
sure the filesystem is still happy.  Then use "--grow --raid-disks" to
reshape the array without changing the size.
If you change the array size and get it wrong, you can always put it back.
But once you start the reshape happening, you will have lost any data beyond
"array-size".

NeilBrown


>=20
> Craig
>=20
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.kern=
el.org] On Behalf Of NeilBrown
> Sent: Sunday, 24 August 2014 1:10 PM
> To: Andy Smith
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
>=20
> On Sat, 23 Aug 2014 16:31:10 +0000 Andy Smith <andy@strugglers.net> wrote:
>=20
> > Hi,
> >
> > I am aware that for a very long time it was not possible to change the
> > number of devices in an mdadm RAID-10. But then recently I am sure I
> > saw threads here alluding to this being possible. e.g.:
> >
> >     http://marc.info/?l=3Dlinux-raid&m=3D140768923829685&w=3D2
> >
> > I have a 6 device RAID-10 near=3D2 array that I would like to shrink
> > down to 4 devices.
> >
> > I have compiled mdadm 3.3.2 and am using kernel 3.16.0.
> >
> > $ sudo mdadm --detail /dev/md2
> > /dev/md2:
> >         Version : 0.90
> >   Creation Time : Sun Jun  4 08:18:58 2006
> >      Raid Level : raid10
> >      Array Size : 471859200 (450.00 GiB 483.18 GB)
> >   Used Dev Size : 309363520 (295.03 GiB 316.79 GB)
> >    Raid Devices : 6
> >   Total Devices : 6
> > Preferred Minor : 2
> >     Persistence : Superblock is persistent
> >
> >     Update Time : Sat Aug 23 15:23:38 2014
> >           State : active
> >  Active Devices : 6
> > Working Devices : 6
> >  Failed Devices : 0
> >   Spare Devices : 0
> >
> >          Layout : near=3D2
> >      Chunk Size : 64K
> >
> >            UUID : 3905b303:ca604b72:be5949c4:ab051b7a
> >          Events : 0.312149991
> >
> >     Number   Major   Minor   RaidDevice State
> >        0       8       51        0      active sync   /dev/sdd3
> >        1       8       67        1      active sync   /dev/sde3
> >        2       8       83        2      active sync   /dev/sdf3
> >        3       8       19        3      active sync   /dev/sdb3
> >        4       8       35        4      active sync   /dev/sdc3
> >        5       8        3        5      active sync   /dev/sda3
> >
> > $ sudo ./mdadm --grow -n4 /dev/md2 --backup-file /var/tmp/mdadm.backup
> > mdadm: Cannot set new_data_offset: RAID10 reshape not
> >        supported on this kernel
> >
> > Is that not yet possible, then?
> >
> > (Each device is 320GB so it should all fit with only four of them)
>=20
> raid10 reshape is only supported for v1.x metadata, and you have 0.90.
> This is because it needs to move the data_offset and 0.90 cannot do that.
>=20
> I see you have already adjusted the --array-size correctly - good.
>=20
> You can achieve your result by:
>=20
>  1/ stop the array and assemble with --update=3Dmetadata.  This will conv=
ert the
>     array to v1.0
>  2/ "mdadm /dev/md2 --grow --disks=3D4"  That should perform the reshape.
>     You don't need a --backup-file with RAID10 ... or with other arrays i=
f you
>     have recent tools and enough space before or after.
>=20
> I guess the error message could be better....
>=20
> NeilBrown
>=20
> Disclaimer
>=20
> CONFIDENTIAL
>=20
> This message contains confidential information and is intended only for t=
he intended recipients. If you are not the named addressee you should not d=
isseminate, distribute or copy this e-mail. Please notify the sender immedi=
ately by e-mail if you have received this e-mail by mistake and delete this=
 e-mail from your system.


--Sig_/J5Yybg+E6/+D=4Z/olYsHmr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/mJ8znsnt1WYoG5AQLpshAAjsTl11rNzuEoLRnKEuBnPEZLsQDnClHU
4URkAZ4s68tmhVdAGBCEARJdCHkjF81w41HK+TaAD3UwLjtEp1TwDooMiWdW4Aqh
WIskVz9VlXgUbtaRRaRaBkJRcqovA55d3sxXz0eiHy7gd0MCYxQUMdG+Oav7QGbJ
fGtrdaHEJv6n0Wznyk2L0pyDaTTkSawSc4JgrV6mLC4qm4etpQY2CbMZRRAJU7U0
7p42q9eIbQHvurlMmFk/7ZN//VktwquZa2QN09BS71FSTh+vOtlZDRt3Po2ptyTb
V3y4o6OpiddP4nGZbyu3JMIb55YUxYlwaCRf/v/5Dw7M9Zs5F+7bdHz7xiobgQ5A
vaTUaIwOAIFlTH+DwqL/pAPY65BazqYrHSySqnzv0ijnj1X8OMjl5qnODxeCM4zM
pTlpGHNnkF7taaKNi8drO82i/5uC4+GWejrXgSJ+QJyz6OoUXAPUMa5zptowRgWv
1PQeK7FX0Ea0BtYbTDjb6M6Gro18n8eCR8TC6TdIubQJVyQdO8VKw1oV6+qOqz8j
covaRlmMR5abCAUxg/Bx2YawzJjk7VUZNMim479nXSojiArcTPpKR4V1wggog639
avogVPheiWVtbIy1uDNI8ONHHQNfTNj7ADrjW34uJh/7nBsb1CUU22a89WqeFrdp
yt0i632tpcI=
=c8Rh
-----END PGP SIGNATURE-----

--Sig_/J5Yybg+E6/+D=4Z/olYsHmr--
