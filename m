From: NeilBrown <neilb@suse.de>
Subject: Re: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2
 of 3 RAIDs resync
Date: Mon, 28 May 2012 12:54:36 +1000
Message-ID: <20120528125436.69e847ca@notabene.brown>
References: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
	<20120527220007.64fb230b@notabene.brown>
	<CA+sTkh67PwRkuYyXMRHUFmJUmC==9KFJNnpK+SsAhCTB-48UOg@mail.gmail.com>
	<20120528114550.417ae379@notabene.brown>
	<CA+sTkh6D8b38Bx+Xbd7iKo8j29YqYqtRr6tqgFx-j2zAGjMyJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6eKedjLfmqJVqw.rDVbDMrc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh6D8b38Bx+Xbd7iKo8j29YqYqtRr6tqgFx-j2zAGjMyJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6eKedjLfmqJVqw.rDVbDMrc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 28 May 2012 10:37:14 +0800 Igor M Podlesny <for.poige+lsr@gmail.com>
wrote:

> On 28 May 2012 09:45, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 28 May 2012 00:10:33 +0800 Igor M Podlesny <for.poige+lsr@gmail=
.com>
> > wrote:
> >
> >> On 27 May 2012 20:00, NeilBrown <neilb@suse.de> wrote:
> >> > On Sun, 27 May 2012 19:32:40 +0800 Igor M Podlesny <for.poige+lsr@gm=
ail.com>
> >> > wrote:
> >> >> =C2=A0 =C2=A0A power outage has happened to system (which was in "s=
uspend"
> >> >> state) with RAID-10, RAID-5 and RAID-6. Later on boot, RAID-10 was
> >> >> fast re-synced using bitmap, but both RAID-5 and RAID-6 were in
> >> >> auto-readonly mode with resync=3DDELAYED. When they flipped to
> >> >> Read-Write, LSR started re-syncing not using bitmaps seemingly. A b=
ug?
> >> >
> >> > Maybe. =C2=A0But with so little detail it is hard to say.
> >> > What made you think the bitmaps weren't being used?
> >>
> >> =C2=A0 =C2=A0Well, it is reasonable to assume that host being put in s=
uspend
> >> mode wouldn't have much not synced data at all. RAID-10 had been
> >> progressing its resync quite fast, it was obvious that it had been
> >> using bitmaps for that. Moreover =E2=80=94 RAID-10 was the most I/O ac=
tive
> >> comparing to others, AFAIR.
> >
> > Unfortunately vague statements about "it was obvious" or "AFAIR" don't =
really
> > help in analysing a situation to find any bugs.
> > I can only really work with concrete facts. =C2=A0Without them I cannot=
 help.
>=20
>    Well, than probably you could tell me how one does find out whether
> recovery uses WIB, or it doesn't? :-) I mean aside from vague
> estimating based on watching re-sync progressing and considering
> overall time it finally took to complete.

The best indicator is total time that it takes (which can probably be
extracted from logs as start and end are logged).  Divide that into size of=
 a
device to get average MB/sec.  If the bitmap was used, that will normally be
much less the best throughput of the device.

>=20
> >> =C2=A0 =C2=A0P. s. Oh, and BTW, I see 2.6.18 supplied by RedHat still =
has the
> >> bug causing kernel panic when using WIB -- couldn't you please point
> >> out is it due to they're missing some important bugfix you made later?
> >
> > I have no time or interest for submiting bug reports to distros that I =
don't
> > use. =C2=A0If the presence of the bug concerns you, I suggest you repor=
t it.
>=20
>    I thought you could have some recollections bout this rather nasty
> behavior. It has nothing to do with bug-reports for RedHat since
> vanilla 2.6.18 for sure has the same bug, and hopefully it has been
> fixed in later releases -- that was the only thing I was asking you
> about. But your competent suggestions are also appreciated, of course.
>=20

2.6.18 is a long time ago.  I don't really have any recollections - so many
bugs, so many releases.  I'm not even entirely sure what bug you are
referring to.  I would probably have tagged any patch for it to be included
in -stable, but I cannot be certain without looking more deeply.

NeilBrown

> --


--Sig_/6eKedjLfmqJVqw.rDVbDMrc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8Lo7Dnsnt1WYoG5AQLBHhAAt8hWfKW796BH71omK+xLXgq/se35ercx
wIy1ZfT2DJBfojfwd0SVWV5+XtYQNKn5/eD1a4VK111u2OiVJ6g1PUwhoVeib3rC
JOnfC5Zry4ZfcUE/sD0o+xqidFVlC/M4+uZ6/Bwd/Iuh6nK7O9WvF6IcSdJ2GNjx
QrhLqSeOWdzV5dDn/Dfn9Sq6giI6nVMKCTsoWFRonv0QcWcM1wg2xVlg3M5wdNl9
9ajqQYf5VCmU6RKVaMUuA7M12yzx9nSidIGQet8BPAFmCPHzelhp0ky9C8EsgU1R
QixObnlZAJ+DpGM3vFVZmI9OyAaEYRu1/1TveVin69fGcgAAEL+6+wUvoCItzpDw
AXc1qbGH4ZY5+2Vc1/VgwzDzZK5p19lSxh9UztEllLOP4fK3Q2mUDNWVhyVd59+p
wIhQQIeRgalXtF2MuPSguFoNsFNhKBV/oqp8KBgzDPIsZMdpz2pdQa7BcI1d592y
2tOzPEy8pHN4UJwWxpaF/9Cs8I200wxdVUZDiwo/vlmUVUeFMTXmkjvHc8Qslm/1
bel/lhKgbe9O++rMjWXM77+mSdCcssVCgas1FT1AF/dtvroe246yZUWnUye6dFnT
H6/ch0zuabHuOhxM4P8Mlb7bo9V+n0vkQeIPbi+Jeaqp4njv7xYDQsXhUiAnje68
GjpQ5uvxgp0=
=dKne
-----END PGP SIGNATURE-----

--Sig_/6eKedjLfmqJVqw.rDVbDMrc--
