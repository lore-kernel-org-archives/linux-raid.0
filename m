From: NeilBrown <neilb@suse.de>
Subject: Re: RAID50, despite chunk setting, does everything in 4KB blocks
Date: Tue, 20 Dec 2011 10:24:15 +1100
Message-ID: <20111220102415.1bb30e78@notabene.brown>
References: <CANWz5fhEz20oi9fXVuxngywMu6mZQtghMKCBCAwm5uOVXOD__w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cM4zXRHrHi8UoH2tV03WPUP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANWz5fhEz20oi9fXVuxngywMu6mZQtghMKCBCAwm5uOVXOD__w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/cM4zXRHrHi8UoH2tV03WPUP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Dec 2011 15:43:13 -0700 Chris Worley <worleys@gmail.com> wrote:

> It doesn't really matter what chunk sizes I set, but, for example, I
> create=C2=A0three RAID5's of 5 drives each with a chunk size of 32K, and
> create a RAID0 comprised of the three RAID5's with a chunk size of
> 64K:
>=20
> md0=C2=A0: active raid0 md27[2] md26[1] md25[0]
> =C2=A0 =C2=A0 =C2=A0 1885098048 blocks super 1.2 64k chunks
>=20
> If I write to one of the RAID5's, using:
>=20
> # dd of=3D/dev/md27 =C2=A0if=3D/dev/zero bs=3D1024k oflag=3Ddirect
>=20
> ... then "iostat -dmx 2" shows the drives being written to in 32K
> chunks (avgrq-sz=3D64), as you'd expect.
>=20
> But, writing to the RAID0 that's striping the RAID5's, shows
> everything being written in 4KB chunks (iostat shows=C2=A0avgrq-sz=3D8) to
> the RAID0 as well as to the RAID5's.

When writing to a RAID5 it *always* submits request to the lower layers in
PAGE sized units.  This makes it much easier to keep parity and data aligne=
d.

The queue on the underlying device should sort the requests and  group them
together and your evidence suggests that it does.

When writing to the RAID5 through a RAID0 it will only see 64K at a time but
that shouldn't won't make any difference to its behaviour and should change
the way the requests finally get to the device.

So I have no idea why you see a difference.

I suspect lots of block-layer tracing, and lots of staring at code and lots
of head scratching would be needed to understand what is really going in.


>=20
> Why is that? =C2=A0Note that this is true for reading too. =C2=A0Note I d=
on't
> see the same problem when using RAID10 (via striped RAID1's) or
> RAID100 (via striped RAID10's).

RAID1 and RAID10 don't split things into pages so I can imagine that they
might life easier for the scheduler.

But the scheduler should  still get it right for RAID5 ....


So - its a mystery.  Sorry.

NeilBrown


>=20
> ... this is on SLES11 using a=C2=A02.6.32.43-0.5 kernel.
>=20
> Thanks,
>=20
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/cM4zXRHrHi8UoH2tV03WPUP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTu/Hpjnsnt1WYoG5AQJJ9g//TZCA9weQm3/3E6h7DTTs8IH1Q8RFImFV
RO+Y/tAJ7ysGhBSzIkjxL90g5IogzSex1oG86vejzk+68YnvjFNoyQZu8gm58Gby
0I/TdBaQBM5mb4SCqIdgO9HR6e4Wlg9xodfvcQmM8ME+FkE6l0H5KF7GQuFKp7CV
Sk2KqjUoTw5Djc4qaZZ8hPQbPSRJ0R6xMvzRvw4C5Hwd+SBnSZNPYva5qxMbqTqE
JfKhcQ9uyKjbzW+d3UvS1ytLCG/layCGfAKKuRi2rXaSHoWTrqAbI4vodoxKRfb0
yn+XFBCtgis84hLPFX1qD/NjGTCfy+uIzSaW7zfUi+p1GOz83zL2q2WGB5C0I3fO
zabplR+tA0qoLnrHirpXqb+v5hpiMwvkgD/ELFt5kyEJrQoRM0xc/QJZG8ln15ZG
9dx+sOPaJ426GgASuOstZEfWJrCnzFfQt2Nx5h40YwlFn0lqi2S0IX8wWxbCPBO+
n79seq7r0lHGAwshb/e6lF9s8YXFhfsyWrgRZb5NKdQxvDZhwZE4hDJzliBynvrk
jUgl1n2RlpjMW1wGHlSGquNC+wDs2Scs7BMbg72JZ8VNpcB6iCiXr4yYs4zaAKxY
NHmbvnBrnV8/Xm+S5ARDQ+ApLUJ/GfK1ORDDAnWx20/5awHL0Kq77aGLMeT4fYVP
eGWGP9dOSHU=
=eC78
-----END PGP SIGNATURE-----

--Sig_/cM4zXRHrHi8UoH2tV03WPUP--
