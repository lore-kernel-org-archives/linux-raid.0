From: NeilBrown <neilb@suse.de>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch
 checksum
Date: Tue, 25 Nov 2014 09:50:52 +1100
Message-ID: <20141125095052.51f8eadc@notabene.brown>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
	<20141029200501.1f01269d@notabene.brown>
	<CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
	<CAK-d5dYm7tEY855w1CdkvPz22ukkg1DwGz_mQ_9-JRV0M=O6Rw@mail.gmail.com>
	<20141103165217.3bfd3d3e@notabene.brown>
	<CAK-d5daq+-PbX1s81h01x7GdVDCijyzzPaeRAOCctEXTNideCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GkF2atd6HvrPp54yULRwFnb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5daq+-PbX1s81h01x7GdVDCijyzzPaeRAOCctEXTNideCw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/GkF2atd6HvrPp54yULRwFnb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Nov 2014 12:59:47 +0530 Anshuman Aggarwal
<anshuman.aggarwal@gmail.com> wrote:

> On 3 November 2014 at 11:22, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 30 Oct 2014 20:30:40 +0530 Anshuman Aggarwal
> > <anshuman.aggarwal@gmail.com> wrote:
> >
> >> Would chunksize=3D=3Ddisksize work? Wouldn't that lead to the entire
> >> parity be invalidated for any write to any of the disks (assuming md
> >> operates at a chunk level)...also please see my reply below
> >
> > Operating at a chunk level would be a very poor design choice.  md/raid5
> > operates in units of 1 page (4K).
>=20
> It appears that my requirement may be met by a partitionable md raid 4
> array where the partitions are all on individual underlying block
> devices not striped across the block devices. Is that currently
> possible with md raid? I dont' see how but such an enhancement could
> do all that I had outlined earlier
>=20
> Is this possible to implement using RAID4 and MD already?

Nearly.  RAID4 currently requires the chunk size to be a power of 2.
Rounding down the size of your drives to match that could waste nearly half
the space.  However it should work as a proof-of-concept.

RAID0 supports non-power-of-2 chunk sizes.  Doing the same thing for
RAID4/5/6 would be quite possible.

>   can the
> partitions be made to write to individual block devices such that
> parity updates don't require reading all devices?

md/raid4 will currently tries to minimize total IO requests when performing
an update, but prefer spreading the IO over more devices if the total number
of requests is the same.

So for a 4-drive RAID4, Updating a single block can be done by:
  read old data block, read parity, write data, write parity - 4 IO requests
or
  read other 2 data blocks, write data, write parity - 4 IO requests.

In this case it will prefer the second, which is not what you want.
With 5-drive RAID4, the second option will require 5 IO requests, so the fi=
rst
will be chosen.
It is quite trivial to flip this default for testing

-	if (rmw < rcw && rmw > 0) {
+	if (rmw <=3D rcw && rmw > 0) {


If you had 5 drives, you could experiment with no code changes.
Make the chunk size the largest power of 2 that fits in the device, and then
partition to align the partitions on those boundaries.

NeilBrown


>=20
> To illustrate:
> -----------------RAID - 4 ---------------------
> |
> Device 1       Device 2       Device 3       Parity
> A1                 B1                 C1                P1
> A2                 B2                 C2                P2
> A3                 B3                 C3                P3
>=20
> Each device gets written to independently (via a layer of block
> devices)...so Data on Device 1 is written as A1, A2, A3 contiguous
> blocks leading to updation of P1, P2 P3 (without causing any reads on
> devices 2 and 3 using XOR for the parity).
>=20
> In RAID4, IIUC data gets striped and all devices become a single block de=
vice.
>=20
>=20
> >
> >
> >>
> >> On 29 October 2014 14:55, Anshuman Aggarwal <anshuman.aggarwal@gmail.c=
om> wrote:
> >> > Right on most counts but please see comments below.
> >> >
> >> > On 29 October 2014 14:35, NeilBrown <neilb@suse.de> wrote:
> >> >> Just to be sure I understand, you would have N + X devices.  Each o=
f the N
> >> >> devices contains an independent filesystem and could be accessed di=
rectly if
> >> >> needed.  Each of the X devices contains some codes so that if at mo=
st X
> >> >> devices in total died, you would still be able to recover all of th=
e data.
> >> >> If more than X devices failed, you would still get complete data fr=
om the
> >> >> working devices.
> >> >>
> >> >> Every update would only write to the particular N device on which i=
t is
> >> >> relevant, and  all of the X devices.  So N needs to be quite a bit =
bigger
> >> >> than X for the spin-down to be really worth it.
> >> >>
> >> >> Am I right so far?
> >> >
> >> > Perfectly right so far. I typically have a N to X ratio of 4 (4
> >> > devices to 1 data) so spin down is totally worth it for data
> >> > protection but more on that below.
> >> >
> >> >>
> >> >> For some reason the writes to X are delayed...  I don't really unde=
rstand
> >> >> that part.
> >> >
> >> > This delay is basically designed around archival devices which are
> >> > rarely read from and even more rarely written to. By delaying writes
> >> > on 2 criteria ( designated cache buffer filling up or preset time
> >> > duration from last write expiring) we can significantly reduce the
> >> > writes on the parity device. This assumes that we are ok to lose a
> >> > movie or two in case the parity disk is not totally up to date but a=
re
> >> > more interested in device longevity.
> >> >
> >> >>
> >> >> Sounds like multi-parity RAID6 with no parity rotation and
> >> >>   chunksize =3D=3D devicesize
> >> > RAID6 would present us with a joint device and currently only allows
> >> > writes to that directly, yes? Any writes will be striped.
> >
> > If the chunksize equals the device size, then you need a very large wri=
te for
> > it to be striped.
> >
> >> > In any case would md raid allow the underlying device to be written =
to
> >> > directly? Also how would it know that the device has been written to
> >> > and hence parity has to be updated? What about the superblock which
> >> > the FS would not know about?
> >
> > No, you wouldn't write to the underlying device.  You would carefully
> > partition the RAID5 so each partition aligns exactly with an underlying
> > device.  Then write to the partition.
> >
> >> >
> >> > Also except for the delayed checksum writing part which would be
> >> > significant if one of the objectives is to reduce the amount of
> >> > writes. Can we delay that in the code currently for RAID6? I
> >> > understand the objective of RAID6 is to ensure data recovery and we
> >> > are looking at a compromise in this case.
> >
> > "simple matter of programming"
> > Of course there would be a limit to how much data can be buffered in me=
mory
> > before it has to be flushed out.
> > If you are mostly storing movies, then they are probably too large to
> > buffer.  Why not just write them out straight away?
> >
> > NeilBrown
> >
> >
> >
> >> >
> >> > If feasible, this can be an enhancement to MD RAID as well where N
> >> > devices are presented instead of a single joint device in case of
> >> > raid6 (maybe the multi part device can be individual disks?)
> >> >
> >> > It will certainly solve my problem of where to store the metadata. I
> >> > was currently hoping to just store it as a configuration file to be
> >> > read by the initramfs since in this case worst case scenario the
> >> > checksum goes out of sync and is rebuilt from scratch.
> >> >
> >> >>
> >> >> I wouldn't use device-mapper myself, but you are unlikely to get an=
 entirely
> >> >> impartial opinion from me on that topic.
> >> >
> >> > I haven't hacked around the kernel internals much so far so will have
> >> > to dig out that history. I will welcome any particular links/mail
> >> > threads I should look at for guidance (with both yours and opposing
> >> > points of view)
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/GkF2atd6HvrPp54yULRwFnb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHO2TDnsnt1WYoG5AQJDEw//bQvpJ9r03uJcTSLboP2oupA5GUvoTJSy
+Nj5JZleZvlR2v3iCMN8iHJPQoohgF5ebGyqHBy8hyNieYy4lfyDB/RZjNkBPcmS
PKe5wkBIzOWfNCoYKtAhtaDfI8K321PMXgKzofJSNGG0c+b+HWeHstlIq6I8fp97
XLzu3qpvWnJi5ZUj9k1uUYaIgzFANunMyJtNPU2M+jsORjMrTDgleoPmk7IFJXNF
dCTOaKCfX1jXyAzWFVRQ4uMuYv1fHRFyxbpyG5Mv1gdLnaL+b2SyJIY3ikHN+grD
8+B6N4fba1ccwbkBZAPRYsa4xttgp3thsk8vmQFMX0u8zKCqyn6qhxXt0wP66Hb0
rSZ3MM/Am/M3lAgaWEedw25XHLHosa9hQQYUMguYzlAqeTF6OigfF6jY8Q1DAjoe
LCf+IvKgIYBCa6tHitN0Y/AViJAYOUuveXcRpwKKH37N8dsnn4POgc1zo5h8Clmj
Ns2kzmgs9IgygCxwRyrWzBs6b0VCnDoRXg4yAnP3JWGuoM9Yx6tqNxmnLspeaO9H
+tC6ONTmBz4vzJbaKrrilw0f/MBhYGhCXCLUS53zFq0WzKt+K7FpJgwnKMJoNW7c
gesS1Hw6T4EM3sPzRDcPmemE83+FrgETHmE6Pi9vTocF+AVlsup/ieOLpHwVcO2Q
yLhsZh4PLDc=
=rbwc
-----END PGP SIGNATURE-----

--Sig_/GkF2atd6HvrPp54yULRwFnb--
