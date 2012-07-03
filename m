From: NeilBrown <neilb@suse.de>
Subject: Re: Fatal crash/hang in scsi_lib after RAID disk failure
Date: Tue, 3 Jul 2012 17:31:45 +1000
Message-ID: <20120703173145.3825674e@notabene.brown>
References: <20120629093552.1651d3c2@batzmaru.gol.ad.jp>
	<20120703155045.570a2bee@notabene.brown>
	<20120703151038.428af28f@batzmaru.gol.ad.jp>
	<20120703164528.5b9b4a7c@notabene.brown>
	<20120703161200.2904740f@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lf/cLvepO7.kR8CJoM=yHnm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703161200.2904740f@batzmaru.gol.ad.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Balzer <chibi@gol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lf/cLvepO7.kR8CJoM=yHnm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jul 2012 16:12:00 +0900 Christian Balzer <chibi@gol.com> wrote:

> On Tue, 3 Jul 2012 16:45:28 +1000 NeilBrown wrote:
>=20
> > On Tue, 3 Jul 2012 15:10:38 +0900 Christian Balzer <chibi@gol.com> wrot=
e:
> >=20
> > > On Tue, 3 Jul 2012 15:50:45 +1000 NeilBrown wrote:
> > >=20
> [snip]
> > > > That took *way* to long to find given how simple the fix is.
> > >=20
> > > Well, given how long it takes with some OSS projects, I'd say 4 days =
is
> > > pretty good. ^o^
> >=20
> > I meant the 4 hours of my time searching, not the 4 days of your time
> > waiting :-)
> >=20
> Hehehe, if you put it that way... ^o^
>=20
> >=20
> > >=20
> > > > I spent ages staring at the code, as about to reply and so "no idea"
> > > > when I thought I should test it myself.  Test failed immediately.
> > >=20
> > > Could you elaborate a bit?=20
> > > As in, was this something introduced only very recently, since I had
> > > dozens of disks fail before w/o any such pyrotechnics.=20
> > > Or were there some special circumstances that triggered it?=20
> > > (But looking at the patch, I guess it should have been pretty
> > > universal)
> >=20
> > Bug was introduced by commit 58c54fcca3bac5bf9 which first appeared in
> > Linux 3.1.  Since then, any read error on RAID10 will trigger the bug.
> >=20
> Ouch, that's a pretty substantial number of machines I'd reckon.

Could be.  But they all seem to have very reliably disks.  Except yours :-)

>=20
> But now I'm even more intrigued, how do you (or the md code) define a read
> error then?=20

The obvious way I guess.

> Remember this beauty here, which triggered the hunt and kill of the R10
> recovery bug of uneven member sets?

Looks like that was a write error.  They are handled quite differently.

NeilBrown


> ---
> Jun 20 18:22:01 borg03b kernel: [1383357.792044] mptscsih: ioc0: attempti=
ng task abort! (sc=3Dffff88023c3c5180)
> Jun 20 18:22:01 borg03b kernel: [1383357.792049] sd 8:0:3:0: [sdh] CDB: S=
ynchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
> Jun 20 18:22:06 borg03b kernel: [1383362.317346] mptbase: ioc0: LogInfo(0=
x31140000): Originator=3D{PL}, Code=3D{IO Executed}, SubCode(0
> x0000) cb_idx mptscsih_io_done
> Jun 20 18:22:06 borg03b kernel: [1383362.317589] mptscsih: ioc0: task abo=
rt: SUCCESS (rv=3D2002) (sc=3Dffff88023c3c5180)
> Jun 20 18:22:06 borg03b kernel: [1383362.567292] mptbase: ioc0: LogInfo(0=
x31170000): Originator=3D{PL}, Code=3D{IO Device Missing Delay
>  Retry}, SubCode(0x0000) cb_idx mptscsih_io_done
> Jun 20 18:22:06 borg03b kernel: [1383362.567316] mptscsih: ioc0: attempti=
ng target reset! (sc=3Dffff88023c3c5180)
> Jun 20 18:22:06 borg03b kernel: [1383362.567321] sd 8:0:3:0: [sdh] CDB: S=
ynchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
> Jun 20 18:22:06 borg03b kernel: [1383362.568040] mptscsih: ioc0: target r=
eset: SUCCESS (sc=3Dffff88023c3c5180)
> Jun 20 18:22:06 borg03b kernel: [1383362.568068] mptscsih: ioc0: attempti=
ng host reset! (sc=3Dffff88023c3c5180)
> Jun 20 18:22:06 borg03b kernel: [1383362.568074] mptbase: ioc0: Initiatin=
g recovery
> Jun 20 18:22:29 borg03b kernel: [1383385.440045] mptscsih: ioc0: host res=
et: SUCCESS (sc=3Dffff88023c3c5180)
> Jun 20 18:22:29 borg03b kernel: [1383385.484846] Device returned, unsetti=
ng inDMD
> Jun 20 18:22:39 borg03b kernel: [1383395.448043] sd 8:0:3:0: Device offli=
ned - not ready after error recovery
> Jun 20 18:22:39 borg03b kernel: [1383395.448135] sd 8:0:3:0: rejecting I/=
O to offline device
> Jun 20 18:22:39 borg03b kernel: [1383395.452063] end_request: I/O error, =
dev sdh, sector 71
> Jun 20 18:22:39 borg03b kernel: [1383395.452063] md: super_written gets e=
rror=3D-5, uptodate=3D0
> Jun 20 18:22:39 borg03b kernel: [1383395.452063] md/raid10:md3: Disk fail=
ure on sdh1, disabling device.
> Jun 20 18:22:39 borg03b kernel: [1383395.452063] md/raid10:md3: Operation=
 continuing on 4 devices.
> ---
> That was a 3.2.18 kernel, but it didn't die and neither did the other
> cluster member with a very similar failure two weeks earlier.=20
>=20
> So I guess the device getting kicked out by the libsata layer below is
> fine, but it returning medium errors triggers the bug?
>=20
> Anyways, time to patch stuff, thankfully this is the only production
> cluster I have with a 3.2 kernel using RAID10. ^.^;
>=20
> Regards,
>=20
> Christian


--Sig_/lf/cLvepO7.kR8CJoM=yHnm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/Kf4Tnsnt1WYoG5AQJV+g/9Eht/eofks8hlaXf0Qm+uK/AU5XURtmQr
tnUPaqasSn9V1R3pSyhcNcRP01nKf/DyusqW/5+uhpB+EFUZA0BwfbHLQfJh3gcz
wGTm0JOXziutpGXsXzpO8UeNpAzN/bLgMrad3Bk46U8WOQHfgWr3MGhZJaQtrJ49
w7DU14lcx+pzhYqmWzhk6Dm/qLtQ6TVS3imvu6X93Xi9T7zHXeDSE+FmvQkbaCb+
uC2lGY9vpVdhc5I3G3Stu0UfcEu9G5wJb9fSqw6D/KSDcK4Zh4xV2/c515FK3fVL
1sDfI0bkMCqBkgCiSfBeiikEvbYYa5WswSaXr6xYBsvx1Mdo6vN+ag8IwrgX+Ez/
r8iE2jVrFSrpmMbNWenj3IkiIqU8KTaNxs4rctx9SEnlM3vWvJpOPvnj3ygJs8p8
b1QKq9O4PUgyAx4OfRLWQicHC1DASiek0Qr+yhy9gdvwOfz9sg2Sd7D0SnbQMItT
fOmjv52Jh3MIIzwse2RqJVwEjabIEkyDRJPNrnQxcxKPq41QxGoDT3h1J80ZB5ko
uQkCfv/xhQlRwWjO34pJsy7wRqsO2si9b137yKdbYwT8+snwig/h21z+YUu7+V0U
IHd4zPyn/IR/8EOwn08aNnQPlKuxt3N6JiZeELBsRuF1r3osak2nokYiGzGjG/YC
BkvsIeYHWHI=
=NeN1
-----END PGP SIGNATURE-----

--Sig_/lf/cLvepO7.kR8CJoM=yHnm--
