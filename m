From: NeilBrown <neilb@suse.de>
Subject: Re: RAID50, despite chunk setting, does everything in 4KB blocks
Date: Tue, 20 Dec 2011 11:08:06 +1100
Message-ID: <20111220110806.221173c6@notabene.brown>
References: <CANWz5fhEz20oi9fXVuxngywMu6mZQtghMKCBCAwm5uOVXOD__w@mail.gmail.com>
	<20111220102415.1bb30e78@notabene.brown>
	<CANWz5fg9e9A_FZDY28m38_c+EZ=NdjCBcqYhbW+8Qyyc1=BRxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0WaTiiKkGbPNCqSu4LebfQ7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANWz5fg9e9A_FZDY28m38_c+EZ=NdjCBcqYhbW+8Qyyc1=BRxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/0WaTiiKkGbPNCqSu4LebfQ7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Dec 2011 16:56:16 -0700 Chris Worley <worleys@gmail.com> wrote:

> On Mon, Dec 19, 2011 at 4:24 PM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 19 Dec 2011 15:43:13 -0700 Chris Worley <worleys@gmail.com> wro=
te:
> >
> >> It doesn't really matter what chunk sizes I set, but, for example, I
> >> create=C2=A0three RAID5's of 5 drives each with a chunk size of 32K, a=
nd
> >> create a RAID0 comprised of the three RAID5's with a chunk size of
> >> 64K:
> >>
> >> md0=C2=A0: active raid0 md27[2] md26[1] md25[0]
> >> =C2=A0 =C2=A0 =C2=A0 1885098048 blocks super 1.2 64k chunks
> >>
> >> If I write to one of the RAID5's, using:
> >>
> >> # dd of=3D/dev/md27 =C2=A0if=3D/dev/zero bs=3D1024k oflag=3Ddirect
> >>
> >> ... then "iostat -dmx 2" shows the drives being written to in 32K
> >> chunks (avgrq-sz=3D64), as you'd expect.
> >>
> >> But, writing to the RAID0 that's striping the RAID5's, shows
> >> everything being written in 4KB chunks (iostat shows=C2=A0avgrq-sz=3D8=
) to
> >> the RAID0 as well as to the RAID5's.
> >
> > When writing to a RAID5 it *always* submits request to the lower layers=
 in
> > PAGE sized units. =C2=A0This makes it much easier to keep parity and da=
ta aligned.
> >
> > The queue on the underlying device should sort the requests and =C2=A0g=
roup them
> > together and your evidence suggests that it does.
> >
> > When writing to the RAID5 through a RAID0 it will only see 64K at a tim=
e but
> > that shouldn't won't make any difference to its behaviour and should ch=
ange
> > the way the requests finally get to the device.
> >
> > So I have no idea why you see a difference.
> >
> > I suspect lots of block-layer tracing, and lots of staring at code and =
lots
> > of head scratching would be needed to understand what is really going i=
n.
>=20
> Note that "max_segments" for the raid0 =3D 1, and max_segment_size =3D
> 4096, which tells Linux that the md can only take a single 4KB page
> per IO request.

Ah, of course.  RAID5 sets a merge_bvec_fn so that there is some chance that
read requests can bypass the cache.
As RAID0 doesn't honour the merge_bvec_fn (maybe it should) it sets the max
request size to 1 page.

RAID10 sets a merge_bvec_fn too so RAID0 will be sending it requests in
1-page pieces.

>=20
> The scheduler shouldn't be involved in the transaction between the
> RAID0 and RAID5, as neither uses the scheduler, so it shouldn't merge
> there, but it also shouldn't be fragmenting.
>=20
> Not having the RAID0 send the larger chunks to the RAID5's may cause
> more fragmentation than the drive's scheduler will be able to
> re-merge.

How hard can it be to merge a few (thousand) requests??? :-)

NeilBrown


--Sig_/0WaTiiKkGbPNCqSu4LebfQ7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTu/R5jnsnt1WYoG5AQKnYBAApIGq5cuepbuj0cznZle2B0RpMfkmi70g
MSZovvxE4UaHdf+o44fJdvFPCTuBU5iHny162K85uQl3M6jEN0nMLD237HlgNPaY
wJ9qVxiN9HRTwlRlnq3WDOTj+idw5S9zl4FzvAVoiuDlKsidP/IH3F1v7kFCs8nC
VbI+QojgJyYQBNSim34ngBeoQvQuX8d7U4T1YhOSZQbQKSGaynUcSWLgHihfq5QY
T71uF1gReGuYCTRFrjUaXAH+FtOUKkY+uEOrLw9i48k5XqUzrC1WyFEriNBMVwuX
pLHWmqXkoL0TeyUsL3755nGFQ/aIf613uTk8N/N5Da7FaxkLZxAe6PO/M3HNOfnr
nyw6H8Quq7o+ivRBw16A4wOadEqQXfX5wkXHO/jPQlyDApChmh9Kp9MmQ0J/BKQL
VtxZiZlHr1y0es65dZzXdd8bMxtEXj4EuOPDH/HIF2WcwSXMf5SJfJ8B6ZEYcNZU
VpIXFsULrExRdc8Qdgf4Zb4xO3HU+pV7Xl/zZfX+7qJKbWCFYoQHOgq7AOBckPlW
izYwMfl8rIjxEPsjhphoEEBzM8/xYJ4QEYKktEsw8oiFxoAJVySzk9OrlkAgMvoc
Q6of4FG+rw4wjD4oPypk2VU1v/zUt/9+n5Zw+YPa3yMq0ehVKCjr+BrVU6kFp1mm
DAoXd1gUwQs=
=UyVX
-----END PGP SIGNATURE-----

--Sig_/0WaTiiKkGbPNCqSu4LebfQ7--
