From: NeilBrown <neilb@suse.de>
Subject: Re: After RAID0 grow: inconsistent superblocks and /proc/mdstat
Date: Mon, 13 Jan 2014 16:03:24 +1100
Message-ID: <20140113160324.189c96bd@notabene.brown>
References: <CABR0jETBgOtu8EbR0oT0TNP_ixg0-vBQUyPZbrDTFBYU3KTL4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u3ey381o5D1NRrB+was=aBZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABR0jETBgOtu8EbR0oT0TNP_ixg0-vBQUyPZbrDTFBYU3KTL4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael@edgeofthenet.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/u3ey381o5D1NRrB+was=aBZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Jan 2014 23:37:57 -0500 Richard Michael
<rmichael@edgeofthenet.org> wrote:

> Hello list,
>=20
> I grew a RAID0 by one-disk, and it re-shaped via RAID4 as expected.
>=20
> However, the component superblocks still RAID4, while /proc/mdstat,
> /sys/block/md0/md/level and "mdadm -D" all indicate RAID0.
>=20
> I am reluctant to stop the array, in case auto-assemble can't put it
> back together.  (I suppose I could create a new array, but I'd want to
> be quite confident about the layout of the disks.)
>=20
>=20
> Is this a bug?  Should/can I re-write the superblock(s)?
>=20
>=20
> # cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
> md0 : active raid0 sdc1[2] sdd1[0]
>       5860268032 blocks super 1.2 512k chunks
>=20
> # cat /sys/block/md0/md/level
> raid0
>=20
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Fri Jan 10 13:02:25 2014
>      Raid Level : raid0
>      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sun Jan 12 20:08:53 2014
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>      Chunk Size : 512K
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        2       8       33        1      active sync   /dev/sdc1
>=20
>=20
>=20
> But,
>=20
>=20
> # mdadm -E /dev/sd[cd]1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 8f51352a:610d0ecd:a1e28ddd:86c8586c
>            Name : anvil.localdomain:0  (local to host anvil.localdomain)
>   Creation Time : Fri Jan 10 13:02:25 2014
>      Raid Level : raid4
>    Raid Devices : 3
>=20
>  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
>      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>     Data Offset : 260096 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D260008 sectors, after=3D2959 sectors
>           State : clean
>     Device UUID : ad6e6c88:0f897bc1:1f6ec909:f599bc01
>=20
>     Update Time : Sun Jan 12 20:08:53 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 1388a7b - correct
>          Events : 9451
>=20
>      Chunk Size : 512K
>=20
>    Device Role : Active device 1
>    Array State : AA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 8f51352a:610d0ecd:a1e28ddd:86c8586c
>            Name : anvil.localdomain:0  (local to host anvil.localdomain)
>   Creation Time : Fri Jan 10 13:02:25 2014
>      Raid Level : raid4
>    Raid Devices : 3
>=20
>  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
>     Data Offset : 260096 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D260008 sectors, after=3D2959 sectors
>           State : clean
>     Device UUID : b3cda274:547919b1:4e026228:0a4981e7
>=20
>     Update Time : Sun Jan 12 20:08:53 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : e16a1979 - correct
>          Events : 9451
>=20
>      Chunk Size : 512K
>=20
>    Device Role : Active device 0
>    Array State : AA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
>=20
>=20
>=20
> Somewhat aside, I grew the array with:
>=20
> "mdadm --grow /dev/md0 --raid-devices=3D2 --add /dev/sdc1"

That is the correct command.

>=20
> I suspect I should not have used "--add".  Looking at the superblock,
> there is a 3rd unknown device, which I did not intend to add.
>=20
> Did I convince mdadm to add two devices at the same time, sdc1 *and* a
> missing device?  (This surprises me a bit, in the sense that
> --raid-devices=3D2 would pertain to the added devices, rather than the
> total devices in the array.)
>=20
> Or, perhaps mdadm add a "dummy" device as part of the temporary RAID4
> conversion?

Exactly.  The RAID4 had 1 more device than the RAID0.  What is what you are
seeing.

I'm a bit confused ... did you grow this from a 1-device RAID0 to a 2-device
RAID0?  That seems like an odd thing to do, but it should certainly work.

This should work and I think I've tested it.  However looking at the code I
cannot see how it ever would have done.  I cannot see anything that would
write out the new metadata to the RAID0 after the reshape completes.
Normally md will never write to the metadata of a RAID0 so it would need
special handling which doesn't seem to be there.

I just tried testing it on the current mainline kernel and it crashes  :-(

So it looks like I need to do some fixing here.

Your array should continue to work.  If you reboot, it will be assembled as=
 a
RAID4 with the parity disk missing.   This will work perfectly but may not =
be
as fast as RAID0.  You can "mdadm --grow /dev/md0 --level=3D0" to convert i=
t to
RAID0 though it probably won't cause the metadata to be updated.

Thanks for the report.

NeilBrown

--Sig_/u3ey381o5D1NRrB+was=aBZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtNznDnsnt1WYoG5AQKg8A//So56O6cQ+Mfox8BGc3FnyT0dDbsrYfIx
XO6zwqugthTN6qQ6K05yprQma+ieEWrAlOpbBobTZGRxjz6YKUYwcJnFJt+FICsU
Z4MYvCgEAZflyQmfvsEmCiS7FioyTf11sNEBO/ps/VrzqpnBw85t5mf5k/kYgb8D
Rjr8UiQiqRo+Rq4kRH8N5nd7/LSOKTp63YcG8U3ZBYN85sosRrwr7TZBjUDp9qTq
ho5wtjS5Sv9hPgf/Q05vfHM8OY4ynJM5DEM6lWpGb6f7xpKGZKZDvsDIpmNAwgty
yaNvuM0+p/ojCS2tjAV10pYJmmXhPRpOFXACZdSP0oFaL17ZwFvCRfl4Gf0QifPk
kyzWGACCPCTVm7Y+4I+VKWWQR11izp6kuDHZ0zzQey1e4tUIs6vNbDszevwuXJHj
P2txndwD1krOM3plr1Jmr0W5p4twU4que8l77jjn2UivcBGCu/KLKM4DMhKL1j0o
fcz0mpsjkXfTaQDnGIjOVd7+yUdSbBE+yc9ndRBA4vxuCakSbT3jiODe86wQKNYk
wiKRgMYtKC6GYYyyOi0jMdtvpphJ4qGHLCSOvKkORacKMfgV2Plm5PuXfz3KzIGX
5JYTnI62Lqzr4obInA61c6vvfKPm/tr9JVlX1DphZsZConq3YPLfoterwLLqPVGN
xPdko2BiN9c=
=drcC
-----END PGP SIGNATURE-----

--Sig_/u3ey381o5D1NRrB+was=aBZ--
