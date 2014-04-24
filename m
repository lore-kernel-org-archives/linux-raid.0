From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH 1/3] md/isrt: base infrastructure and metadata
 loading
Date: Thu, 24 Apr 2014 18:02:52 +1000
Message-ID: <20140424180252.490434c6@notabene.brown>
References: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
	<20140424061849.3187.48229.stgit@viggo.jf.intel.com>
	<20140424172450.7ec9452b@notabene.brown>
	<CAA9_cmcfGvBVTbxbBKBsgsnkyAux_VyKcM3V6v+tY5quQTotkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.lXVWGk9ih0CN2fDgjmaK6H"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcfGvBVTbxbBKBsgsnkyAux_VyKcM3V6v+tY5quQTotkQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, jes.sorensen@redhat.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

--Sig_/.lXVWGk9ih0CN2fDgjmaK6H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Apr 2014 00:38:01 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Thu, Apr 24, 2014 at 12:24 AM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 23 Apr 2014 23:18:49 -0700 Dan Williams <dan.j.williams@intel.c=
om>
> > wrote:
> >
> >> Initial md / block boilerplate for the Intel (R) Smart Response
> >> Technology compatibility driver.  Supports reading the packed  metadata
> >> and parsing it into a cache lookup tree.
> >>
> >> Cc: Dave Jiang <dave.jiang@intel.com>
> >> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >
> > It would really help in reviewing this to have a glossary.
> >
> > There are frames and segments and sectors and pages.
> >
> > I hope sectors are 512 bytes and pages are PAGE_SIZE, which may or may =
not be
> > 4096.
> >
> > And there are 16 sectors per frame, so I guess space is allocated in the
> > cache in 8K aligned frames ??
> >
> > There are 64 segments per page so if pages did happen to be 4096 bytes,=
 that
> > makes 64 bytes per segment.  What are they?
> >
> > There is a list somewhere of 32byte frame descriptors which is read int=
o a
> > single vmalloced region (why? you keep page pointers, so why not read i=
t into
> > separate pages?)
> > How is this organised?  I might be able to work that out from the code,=
 but
> > I'd rather not.
> >
> > Please don't make me guess, I'm not good at it.
> >
> > I guess it didn't help that diff out the header after the code.  I got =
bored
> > before I got there and didn't read all to words, so maybe some answers =
are in
> > there.  They don't really stand out though.
>=20
> No, they don't.  Let me throw together a proper cheat sheet.

Thanks.


>=20
> > You've chosen '8' for the 'level' number.
>=20
> Hmm, ok.  I use -12 in the mdadm bits, I neglected to go back and fix
> up the kernel.
>=20
> > As this is an array which doesn't have redundancy, I'd rather a number =
<=3D 0.
> > I think there are places where I assume >=3D1 has redundancy and unders=
tands
> > spares etc.
> >
> > Should conf->count be a kref??? Just a thought, not a requirement.
>=20
> Doesn't kref =3D=3D 0 imply object destroyed?  It's a count of pending
> metadata events.

kref means that in a kobject.  Elsewhere it means whatever you want.

mpb_read_endio would kref_put(&conf->ref, release)

where release would get the conf and wake_up(&conf->eventq);

It probably isn't a big win..

NeilBrown

--Sig_/.lXVWGk9ih0CN2fDgjmaK6H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1jFLDnsnt1WYoG5AQK11Q//dC9Z4+eqYEWzPZGXBJs+DqsN81SG2ua9
HLKuu00zaX5tLo6gFt2zHBIP4FC2p4shuSwB0lERZP31Xki3PgoSASx209DPfYky
MkN+jAsv4NCa7uUykDvgFXurzZ3eofQGVvBD9bq+Pwli3lqQxCXh2zWywBlRnzQ5
fFA+eknQV8VknkF1M11KcZxeaEG/bSzhkXSYWYsoGCOceZdoEGQbCcZODHkWjVAz
qhPSm7CRx+kQe6AuEZNv6UB78OA+V31IcMewTiY47Pd20PqxT1TUt7THJUI3ZdDV
pR7MPWXxz8AVB7pyiMkWj/EE3y0WvF9mF9Lpr96RAHIaiiWGi8ROl0cs9Xr7IoBE
Tgyq8jgzjvakZA4PKoCXmCr37ocUHwGNc56g4pIk9JD2S3ZhgzhSy3kjRSgJqbNt
d3Rv4azqYJSpvXM5c+Y+H7usnFNKKhNEn5NdKaGBNB56vsZ0NRxALrjpQD5qDUZd
kVzo0238uqGHnqThUu6VYww4+086jP26wDedA5Tizpi65fpoXNs8zlCCtYCqwpbu
sfyQB5kyh5OTu+LdEacTCXwD2JQaOkzenBYcmNjjTKCuB1MYI7L2CZwBvQEZ2tyf
z/hKIX9Nzl5gK87N3SsC5uSDo6QHRE6LhuB9iRRoDdHlY/c141mgUdAGMOzrN1M1
gCRNpZnWlKM=
=uZxC
-----END PGP SIGNATURE-----

--Sig_/.lXVWGk9ih0CN2fDgjmaK6H--
