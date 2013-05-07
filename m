From: NeilBrown <neilb@suse.de>
Subject: Re: --grow RAID6 gives: md: md_do_sync() got signal ... exiting +
 hang
Date: Tue, 7 May 2013 22:40:51 +1000
Message-ID: <20130507224051.1d96c130@notabene.brown>
References: <CANU9nTmqXjPFqU=p0vex2SgXjyv9L2NO5mafHoWqfH7n1kkhcw@mail.gmail.com>
	<20130507215436.46fb6857@notabene.brown>
	<CANU9nTkPUq7V5tnndE64H64jpb7yr6NMZSmcFrqUf8PmRQMsMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ILuWvKrvmjd0UzVhE2bGl=8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANU9nTkPUq7V5tnndE64H64jpb7yr6NMZSmcFrqUf8PmRQMsMg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <tange@binf.ku.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ILuWvKrvmjd0UzVhE2bGl=8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 May 2013 14:08:14 +0200 Ole Tange <tange@binf.ku.dk> wrote:

> On Tue, May 7, 2013 at 1:54 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 7 May 2013 13:36:56 +0200 Ole Tange <tange@binf.ku.dk> wrote:
> >
> >> I am expanding my 9 harddisk RAID6 to 10 harddisk RAID6:
> :
> >> It is, however, hanging the system.
> :
> >> # Do the reshape
> >> mdadm -v --grow /dev/md1 --raid-devices=3D10
> >> --backup-file=3D/root/back-md1
> >> mdadm: Need to backup 7168K of critical section..
>=20
> This completed - did not hang.
>=20
> > What does
> >   grep . /sys/block/md1/md/*
> > show? Or does it hang?
>=20
> Hangs (ctrl-c works).
>=20
> > What about "mdadm --examine /dev/sd*"
>=20
> https://gist.github.com/anonymous/5532063
>=20
> The disk box contains more drives than just the array in question. The
> interesting array is: 242d6530:e2562ecb:1dcd2a97:15a1a868
>=20
> > Did the "mdadm --grow" appear to complete, and return to the shell prom=
pt?
>=20
> Yes.
>=20
> > What kernel version?  What mdadm version?
>=20
> $ mdadm --version
> mdadm - v3.2.5 - 18th May 2012
>=20
> $ uname -r
> 3.2.0-0.bpo.1-amd64
>=20
> > A hanging /proc/mdstat is definitely not a good sign.  The "got signal =
...
> > exiting" isn't good either.  I would expect more messages with that.
> > You didn't just "grep md" in dmesg did you?  That is a complete dmesg o=
utput
> > for the entire time period that could possibly be relevant?
>=20
> dmesg of controller upgrade (after which everything worked fine)
> followed by --grow at 4328065.432267
>=20
> https://gist.github.com/anonymous/5532093
>=20
> /Ole

Thanks for the extra info.  I can't find any smoking gun unfortunately.

What does "ps axgu" show.  I'm particularly looking for processes in 'D'
state.
If there  are any, particularly if they are md related, try
  cat /proc/$PID/stack
for appropriate values of $PID

Maybe also try
   echo t > /proc/sysrq_trigger

and see what gets into 'dmesg' - hopefully your dmesg buffer is big enough =
to
hold the important stack traces.
If you get anything from either of those, please post.

NeilBrown

--Sig_/ILuWvKrvmjd0UzVhE2bGl=8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYj2Uznsnt1WYoG5AQJDWhAAvWIsU0VRyZS0OfK3OU7QC72eysbbNkfz
+qNCpV/NT8kgqTIKr9zPg97eDVVaLftg6Gs0eq0XRAl3IZubR6pGloDbK8FDzwUZ
K1P4ASvJySm8j8y1kcI1HwdW2XivvheuX6EEGYvHdrI5SXHLVhaYNSrCo2XebUBq
tby7UsoEcSWfw613lgg9aIhhHSyqI8+XTe20En8JzFChwY+qyNcJeEfDmKPFv31v
4gDdZHg/4laVQUs4ASRYCM6yv9YcQQStjJykckCa+p+DX/cLc9TmUVg9tcxr3Se7
e1AA4tL4XKsaRrKNDfw6MAgEH2x4PHI/gLG24Fuoe7VJnGvUUHssFTGjssqhM/2t
MyA+OYEe/+fiWw9tFbbHQSdfvKugjBshyWMWkhHC8u2Pt+O5sM2lpV/vyPrlia8i
S/Ezoqao53dk13bZv6ADmTgI4W8uBArzhjsKLSOAFCucwf4inkjBQwquejJ8dhBe
4sFcAHNmh0LmZj4L+Bc5qKDrOGuAMzQSvr6YBiuR5jru5Hv5fMwSXDpEiN2z7UD1
s0oyQxMDc6dcr70c2Jo9Vtf6Fh2qT8xbKzQfeFU8nyCbiqDbU/uV/S2cAUFJkt2K
AduQqLfAvf5Oo1DahzXPWj3OY2x8n4XVI5cjFjsBDmPEsEoe4LqHpHYouZg7G+nG
WRBCljcZkms=
=bSRx
-----END PGP SIGNATURE-----

--Sig_/ILuWvKrvmjd0UzVhE2bGl=8--
