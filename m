From: NeilBrown <neilb@suse.de>
Subject: Re: LVM RAID1 syncing component
Date: Tue, 2 Dec 2014 10:28:11 +1100
Message-ID: <20141202102811.2e93ff9f@notabene.brown>
References: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
	<20141127074158.2a3472f3@notabene.brown>
	<21625.58812.321750.229562@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/tO=w_mq/+B618M9mJBeme=z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21625.58812.321750.229562@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/tO=w_mq/+B618M9mJBeme=z
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 29 Nov 2014 15:26:52 +0000 pg@lxra2.for.sabi.co.UK (Peter Grandi)
wrote:

> [ ... ]
>=20
> > During a resync (after an unclean shutdown) the devices are
> > indistinguishable. RAID1 reads all drives and if there is a
> > difference it chooses one data block to write to the others -
> > always the one with the lowest index number.
>=20
> Uhhhhh "indistinguishable" and "lowest index number"?
>=20
> Shouldn't that be "lowest index number among those with the
> highest event count"?
>=20
> Put another way, couldn't it happen that in a 5-way RAID1 for
> example an unclean shutdown results in 2 drives with the same
> highest event count and 3 drives with lower event counts, and
> then the data page to write is that from the one of the 2 with
> the lowest index number and is written only to the 3 with the
> lower event count?
>=20
> Also, in case of an =C2=ABunclean shutdown=C2=BB resulting in all members
> of a RAID1 set having the same event count, is the resync still
> done?  Is it necessary? Or is =C2=ABunclean shutdown=C2=BB used here as an
> alias for "not all event counts are the same".
>=20
> I am asking as to what RAID1 actually does mostly, but also
> perhaps as to what it ought to be doing.

I've told you what it actually does.  I think that is what it ought to do.
If you think that maybe it ought to do something differently from what it
does, I suggest you try to come up with a specific scenario where what
actually happens is not optimal, and  give clear reasons for why you think
something else is optimal.

To be specific, after an unclean shutdown, the array is assembled from all
devices which have an uptodate event count, and then all blocks are compared
and where a difference is found, data is copies from the lowest index number
block to the  others.

"uptodate" in the context of event counts means the event count is equal to,
or one less than, the highest event count found.

NeilBrown

--Sig_/tO=w_mq/+B618M9mJBeme=z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHz5jDnsnt1WYoG5AQKiBxAAn98n8lNm98E7G6HRmI5/eZSM+7vBs8Yu
dituS2gFKCyrtalihP8ZwdFVLhSUN5L9wuhrsTfQe55btdQmVlHURONbwBE/sSLM
PM0VI+aQ8sdxe61LhwHMEW5no/Jz8pxqU1dhvB/dpj5HhAhFW4H+u6fZ4JmgOOZl
M1nf/ZDnlLkMFoIZn+hHgv3fBF73Wfm+mR50IgH47eFLZ0aXr1DVcluESF5oG5Gd
Eb+IWO4/xHTI3g/F2PrGclU6275A3e7XPrp8PlIjtrELMz2rlGdwHHqISv9Apf3j
+KVtw4ggvRluLGyN1ZgByYxDfwb7u7jRk4pjHxN4MtUCS5P6rnp0A/XFnDrKIw+E
xQnT/I8lTh/OZWTN/fl3O6A36IKgzkGGvUnejKh+Sxz2c+bM8qaR7OKCkBJ0uIeW
Uy3o4uDQ2KZrrrmDqfw3yKdgRyR0fbjp2sDxVEgkDqzCSvUy121/ybNWwy6YVtVW
f62SuWD+8yIk1H8YhOcTG+RwFrtAnkzM8zeCzcY79V4ZpDICa+Xmul4H1r/Iqxsf
0Ldho8VSmFM73v3OA0tFeO4GZ9qfH+A64yoLGqvOB9mTESBDG3qli3BcursESzw5
vQjLqxHNvGXgWJgzyqaffk/RP77OTo07vZ1Z1TGkmiv1UaqXc0x0mCVVPio0Qawc
p4/2fDHOOAI=
=trwZ
-----END PGP SIGNATURE-----

--Sig_/tO=w_mq/+B618M9mJBeme=z--
