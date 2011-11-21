From: NeilBrown <neilb@suse.de>
Subject: Re: Is it possible to change the wait time before a drive is
 concidered failed?
Date: Mon, 21 Nov 2011 12:58:06 +1100
Message-ID: <20111121125806.316a58e0@notabene.brown>
References: <BLU0-SMTP264257376293BB9DBCEB7B798CA0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w+s+XLrBa.w3xaGXBHdR4.O"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP264257376293BB9DBCEB7B798CA0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: wilsonjonathan <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/w+s+XLrBa.w3xaGXBHdR4.O
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Nov 2011 18:41:44 +0000 wilsonjonathan <piercing_male@hotmail.co=
m>
wrote:

> I realise that what I am attempting is not very standard in terms of
> raid, however this is my logic and reasoning...
>=20
> I am setting up a home server that while on 24/7 will only be in use
> when either myself (linux) or my son (windows) are using it, so usage
> will vary and power concerns (Electricity in the UK is extortionately
> priced!) and longevity are important.
>=20
> My set up in theory is the following using GPT partitioning.
>=20
> >sda 6 partitions
> >>free space     1MiB
> >>sda1 bios_boot 1MiB
> >>sda2 /boot     200MiB  raid1  md2
> >>sda3 /         8GiB    raid1  md3
> >>sda4 *swap     9GiB    (will be "raided" using pri=3D1)
> >>sda5 /download 40GiB   raid10 md4
> >>sda6 /thecube  ~950Gib raid6  md5
> >>free space     ~20MiB
> >
> >sdb same as sda
> >
> >sdc 1 partition
> >>free space     enough space to place sdc6 the same start as sda6
> >>sdc6 /thecube  same as sda6
> >>free space
> >
> >sd[df] same as sdc
>=20
> The reason for partitioning this way is that all w.i.p. or downloads,
> torrents, etc. will first go into /download and once complete will be
> moved into /thecube for long term read only storage
>=20
> As /thecube is going to be used less often than sd[ab] it would be
> advantages to have sd[df] power down and when the system is not in use
> at all have sd[ab] also power down.
>=20
> This should increase the lifespan of the drives... and yes I do know
> that drives are more likely to fail when powering up, but I also have
> real life evidence when I used to work on AS/400s that they fail on
> power up if they have hardly ever been turned off more often than if
> they have regular power off/on cycles :-)
>=20
> I may even look at suspend to ram and magic packets if the system is not
> accessed in say 1 hour, although this is less likely to be implemented!
>=20
> Ok so that=E2=80=99s the reasoning behind the question.
>=20
>=20
>=20
> I do have a couple of related questions...
>=20
> I have already done some testing by setting up sd[ab] for md[2-4] but
> with no file systems on top, and then pulling sdb and then putting it
> back in.
>=20
> q1, why does -add throw up the message : not performing --add, re-add
> failed, zero superblock...

Because some people seem to use "--add" when they mean "--re-add" and that
can cause data loss.  So to be safe, if want want to discard all the data on
a device and add it as a true spare, you now need to --zero-superblock
first.  Hopefully that isn't too much of a burden.

>=20
> q2, I setup md4 as a raid10 far 2, and I may not be understanding raid10
> here; when I zero the superblock to add it as I did with the other raids
> which worked ok, for some reason it causes sda4 to drop out and kills
> the whole md4 raid.

You must be running linux-3.1.  It has a bug with exactly this behaviour.
It should be fixed in the latest -stable release.  Upstream commit=20
   7fcc7c8acf0fba44d19a713207af7e58267c1179
fixes it.


>=20
> q3, Is it preferable to have a write intent bitmap, and if so should I
> put it in the meta-data as opposed to a file.

A write intent bitmap can make writes a little slower but makes resync after
a crash much master.  You get to choose which you want.
It is much more convenient in the internal metadata.  Having the bitmap in =
an
external file and reduce the performance cost a bit (if the file is on a
separate device).
I would only recommend a separate file if you have an asymmetric mirror with
one leg (the slow leg) marked write-mostly.  You don't really want the bitm=
ap
on that device, so put it somewhere else.

NeilBrown




>=20
> Thanks in advance.
>=20
> Jon.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/w+s+XLrBa.w3xaGXBHdR4.O
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsmwLjnsnt1WYoG5AQKy7RAAhQDDCdG4uTMb9Gb167OyFzrp2uGgnHO7
b1Nx/ymqK7qVKYQA2C5yoxHMBnx9r5euFBExirQCRZJu0b0mH6s/xPJSkPS/wm8k
eTOJVEOKKFrp++ULmQ/ewNy8Uy+lehNu2qxxSJ+32KYV4APUNEFjQAgkctIy29tz
zRiwP0rvcx1Su07lCjiSmhqqpMiwW28Gpu89V2J+Cmcqdo6K4gEPTLTMnBNpjS1e
WU8OU8oodTwiK0WM3GYregXN/n4qwU9jTdHoXfZNXFXr0mkVmxzTeSsHMh1I2ffB
GtGAofshy543CMhMdMqNM1166SlDU2t9Vob/iHkQBk+uuBYwYjQ4HywdNJ5k7C9v
w8L5Fo0oUqhzik8C9Tm2SSmG2EJNAwzQYCXg7MWb0ne//X8Q8gyckIWplAUDpjsw
fPMg0T6Z4rToc9DjUoRVN9rsPsXnEaxFQE+3iqU+R6Ri4NZLXs8Ct53QJD/RCYJT
HwIFrJ5URJ4TTg6b1y/b5+YhMTENQqwuIg0VyboZ98JnmLJ6fpgEZx6ZShtZbsVH
gIZAgsv8nEEVyoa1BvqdGbXIComZHPAYD2pfNKnY6jiTkjTHE/ltt0LnokHBMabq
sJK/vcG8dIr5SupATzoiAKl15HxhZCDr6kz+4zErZyfB51KBNksxE7rtpw/x+Q3t
/vlsZSuO004=
=SXnk
-----END PGP SIGNATURE-----

--Sig_/w+s+XLrBa.w3xaGXBHdR4.O--
