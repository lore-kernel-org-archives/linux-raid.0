From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] md: also hot remove disk from pers when hot removing
Date: Tue, 20 Nov 2012 08:19:38 +1100
Message-ID: <20121120081938.1c49f6e8@notabene.brown>
References: <1353081849-10516-1-git-send-email-sebastian.riemer@profitbricks.com>
	<CAA9_cmcViMsVMrxyEcC9yaHPq9Xc-5Dt63fMEJ+X+kZst8O9Fg@mail.gmail.com>
	<50AA0985.6060601@profitbricks.com>
	<50AA596D.4080003@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gCSoJvPbQUllrEDvGoqDBZB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50AA596D.4080003@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: Dan Williams <djbw@fb.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/gCSoJvPbQUllrEDvGoqDBZB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Nov 2012 17:08:13 +0100 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> On 19.11.2012 11:27, Sebastian Riemer wrote:
> > On 17.11.2012 01:07, Dan Williams wrote:
> >> Hmm, how are you getting ->raid_disk set to -1 without the personality
> >> being notified?  That seems to be the source of the bug.  Otherwise it
> >> would seem the state_store("remove") path is also susceptible.
> >>
> >> --
> >> Dan
> > Thanks for your feedback!
> >
> > Perhaps it's only something for my use-case of read-only
> > raid1-replicated volumes where I never have any spares. I don't set
> > ->raid_disk to -1 when hot adding them. I have to put them directly to
> > their stored slot because I assemble read-only on read-only rdevs. So
> > the syncer never runs. Those read-only rdevs are coming from remote
> > storage. Imagine HA CD-ROM images.
> >
> > My thought was that it would be cleaner behavior if the cleanup of an
> > rdev in the personality already happens when hot removing the disk.
> >
> > You're right, the state_store("remove") path would need this change, to=
o.
> >
> > With the "slot_store" path I could trigger a panic when I hot added the
> > disk as spare, marked it insync and tried to give it the slot it belongs
> > to. I'll test this with the latest vanilla kernel and try to reproduce
> > this on rw volumes which I set to read-only. If I can also crash it that
> > way, I've got a proof that there is a bug.
>=20
> The kernel blocks most ioctls on a read-only mddev. So I guess I've got
> another custom patch. IMHO it would be still cleaner to also hot remove
> the disk from the personality when hot removing an rdev.

But you *cannot* hot-remove an rdev when it is owned by the personality.
The "remove from the personality" operation is called  "--fail".
The "remove from array" operation is call "--remove".

It would be wrong to conflate these two.

Thanks for confirming it was a local problem - I won't go hunting.

NeilBrown


--Sig_/gCSoJvPbQUllrEDvGoqDBZB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKqiajnsnt1WYoG5AQKn0RAAqP1nP+2y9GM2ztJBW6qcU2WGs2k2thqs
BkHhW6Rko7/i3uH05Yh3dKMjhaTtbq0CjSzYkagS3+TKiPGoabWL4P0qH836cuWF
AjvBGS5h04e9mt5ER6EFVLcdSXy4uKz5ab0dTVT1gwWTOAo+39vDIKmmi06vacuG
0uXTp44bvljo8A0KkPhBzJp1LWqoYyK+fcS3buHjVOiTB2DamiR9zS4AIJZSj7XO
Sy4abOynr1ZaCdK65trpuqAB5xuICrQPmj5vd3PyHk8jZAyWs0GHN2M2PyuC/teG
RXJzFJ15qtpzkB6R51L5s6nMsonwWxZ+NgoDXyLbLzVSpxI8K+Lt6k6CVMuy5dpR
wDbYdLdwmD0quaUNEHMlsImKAAMChf8sPS9XyogF/ZZmcfRYOmDxm1kcHDBacpqy
vMj6icGI7voAi7urnjBmzFyPJgV50pN1pBpUn9+zEnZiRZ/ZnzrnnUhfxGcHuvFc
XbZtB6Mda6nCsWBLZREZjjfgXX28ePxt/s6LGmhqqK/vH8iUjD3xbaLj02kwNTeP
kjQGVf6t0CI7czHSMxT7pTn+GtnNhYVuNz/eV1nJscIT6ab54BZnAXWiYBKq/yG5
aESPLDMOmn4SO2aui+m6aFHXb21CHp6Ts0ksaokhps4oCXIwyM1/321+l9kRL5yo
UQUes212rMY=
=s6hi
-----END PGP SIGNATURE-----

--Sig_/gCSoJvPbQUllrEDvGoqDBZB--
