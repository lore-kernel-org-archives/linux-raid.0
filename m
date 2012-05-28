From: NeilBrown <neilb@suse.de>
Subject: Re: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2
 of 3 RAIDs resync
Date: Mon, 28 May 2012 11:45:50 +1000
Message-ID: <20120528114550.417ae379@notabene.brown>
References: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
	<20120527220007.64fb230b@notabene.brown>
	<CA+sTkh67PwRkuYyXMRHUFmJUmC==9KFJNnpK+SsAhCTB-48UOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2+w6vQqSaINdOYgk6v8hHNS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh67PwRkuYyXMRHUFmJUmC==9KFJNnpK+SsAhCTB-48UOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2+w6vQqSaINdOYgk6v8hHNS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 28 May 2012 00:10:33 +0800 Igor M Podlesny <for.poige+lsr@gmail.com>
wrote:

> On 27 May 2012 20:00, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 27 May 2012 19:32:40 +0800 Igor M Podlesny <for.poige+lsr@gmail=
.com>
> > wrote:
> >> =C2=A0 =C2=A0A power outage has happened to system (which was in "susp=
end"
> >> state) with RAID-10, RAID-5 and RAID-6. Later on boot, RAID-10 was
> >> fast re-synced using bitmap, but both RAID-5 and RAID-6 were in
> >> auto-readonly mode with resync=3DDELAYED. When they flipped to
> >> Read-Write, LSR started re-syncing not using bitmaps seemingly. A bug?
> >
> > Maybe. =C2=A0But with so little detail it is hard to say.
> > What made you think the bitmaps weren't being used?
>=20
>    Well, it is reasonable to assume that host being put in suspend
> mode wouldn't have much not synced data at all. RAID-10 had been
> progressing its resync quite fast, it was obvious that it had been
> using bitmaps for that. Moreover =E2=80=94 RAID-10 was the most I/O active
> comparing to others, AFAIR.

Unfortunately vague statements about "it was obvious" or "AFAIR" don't real=
ly
help in analysing a situation to find any bugs.
I can only really work with concrete facts.  Without them I cannot help.

>=20
> > Did that arrays still have their bitmaps?
>=20
>    I still have that RAID-6, yep:
>=20
> md127 : active raid6 sdg5[2] sdf5[6] sde5[7] sda5[0] sdd5[3] sdc5[1]
>       1071984640 blocks super 1.0 level 6, 1024k chunk, algorithm 2
> [6/6] [UUUUUU]
>       bitmap: 0/1 pages [0KB], 131072KB chunk
>=20
> > Where they degraded?
>=20
>    No way.
>=20
> > How many bits were set in the bitmaps (probably too late to check now)?
>=20
>    Please see above. And the RAID-5 one was recently dismissed, alas.
>=20
> > Is it reproducable ? =C2=A0... OK, I don't really expect you to try to =
reproduce
> > it, but if you could that would be awesome!
>=20
>    Well, might be VirtualBox would allow for such kind of experiment, dun=
no. )
>=20
>    P. s. Oh, and BTW, I see 2.6.18 supplied by RedHat still has the
> bug causing kernel panic when using WIB -- couldn't you please point
> out is it due to they're missing some important bugfix you made later?

I have no time or interest for submiting bug reports to distros that I don't
use.  If the presence of the bug concerns you, I suggest you report it.

NeilBrown


>=20
> --


--Sig_/2+w6vQqSaINdOYgk6v8hHNS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8LYzjnsnt1WYoG5AQI0ORAAulLQdsV4FmQIYFE+GMQDuQfrH7c3k8b1
20lAmS7OyWutWAvHUYey16C29SUlTYEy+5MzAJlm7awAXxKawdUYAcT4RppgueKD
H93h823f/XaeY3Wk+h4acg1LbCBeCaCPJbTFtdyDWGe8Mytdww7mfQszb43yDAtw
BufxIM4WR2ysXUEwRTtuEFi0nzHKgQPlEoaIl2kdEP4F262Tuliy607Or7VTgx8J
CsQdr3Fhy0Y1qcEH0ICBspMmZpysHM9wl27T5bepPm8oG9P8dFbnYOOMwyi8VM4C
HSfBQDKUUcVnJztPQeWd6LJuZUIEHMQnHIPNRSCXouzg4T56Nx/fNjFJHgrg2vRI
5M1TedUQYjKLlr6U7L842vd7O32+TeTzJKJgmA5mT7eRpHMgSUx72UOy37zOcaPz
//gepQt+KTkMISMVPo6jJ8rlVbvhJnWkRlhtnocq5WhRJ2ukhJPJXGCuqq/g43oj
oCz5zEGTmbC334D7Rml57scBHPljkgRb84dK4Ibdvo9sidxTNf11S4jSct67mALz
uflt2y0zIsmJ7gfZRZXcFD2l8oYKLstef5DF3UdRhxJ62Z2qkqs8C7RJakgHRYot
gMtQhkz7y0jTzQNv5bGsmG8RtfUrBbP7sNDxzzuAT+hvD9n5TAQYBO0ujNiZbDFM
3k0UulxSnII=
=qd4I
-----END PGP SIGNATURE-----

--Sig_/2+w6vQqSaINdOYgk6v8hHNS--
