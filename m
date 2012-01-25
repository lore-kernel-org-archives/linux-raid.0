From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Wed, 25 Jan 2012 22:37:17 +1100
Message-ID: <20120125223717.156d6c64@notabene.brown>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
	<1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com>
	<20120122221758.412b18d4@notabene.brown>
	<4F1D358C.9070508@redhat.com>
	<4F1DBF6F.40209@redhat.com>
	<1327351849.6323.9.camel@mop>
	<4F1FDF41.6000909@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.gVdxjLDrwZT93s+ADnAPbI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1FDF41.6000909@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Kay Sievers <kay@redhat.com>, Lennart Poettering <lpoetter@redhat.com>, linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

--Sig_/.gVdxjLDrwZT93s+ADnAPbI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Jan 2012 11:53:53 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> On 01/23/12 21:50, Kay Sievers wrote:
> > On Mon, 2012-01-23 at 21:13 +0100, Lennart Poettering wrote:
> >> On 23.01.2012 11:25, Jes Sorensen wrote:
> >>> I was trying to come up with a better name, and I think --preboot is =
the
> >>> best I have seen so far. Other ideas I had were:
> >>>   --systemd-root
> >>>   --no-shutdown
> >>> however I like --preboot better, so I will go with that, unless someo=
ne
> >>> starts throwing things at me.
> >>
> >> I figure it's a bit of bike-shedding, but I'd like to ask you to stick=
=20
> >> to --initramfs or so if possible, simply because we're interested to=20
> >> reuse the same name for that switch for all storage daemons which need=
=20
> >> this, and the spec currently suggests --initramfs, and I'd prefer to=20
> >> avoid notifying all users of that change if we change it...
> >=20
> > Last time you and I decided to rename it to --initrd, so the document
> > does not say --initramfs.
> >=20
> > Back to square one. :)
>=20
> Neil,
>=20
> In the light of the discussion so far, do you have any preference for
> --preboot/--preroot/--initrd/--offroot
>=20

How about
   -@

A single-character which reflects what it actually does :-)

I don't like --initrd because it is just wrong.

I can live with the others.

I think --offroot is closest to the right meaning (it is both pre and post).
I confess a little discomfort with the word "off" as it can mean both "not =
on"
and "was on".

"Did you run mdadm off root, or off /usr ??  Neither, I ran it from initram=
fs
which is off root."

But I agree with Doug that the term is sufficiently unusual that people are
unlikely to assume anything about it, so it should be safe.

I'm tempted to suggest something completely different that starts with --no=
-,
like
  --no-session-manage
but the word 'manage' already has a couple of meaning for mdadm.

So I'm leaning towards --offroot  though I'd go for --outside-root if it we=
re
a bit shorter.

Maybe we need a name for this thing that exists before root is mounted and
remains until after root is unmounted.  If we had a name for that which
reflected its reality, that would work for me.
 --initial-root
isn't too bad but probably could be better.
 --outer-root
??


Yes, I know - you wanted a decision and I've just created more options !!

 --offroot

then.
(maybe)

NeilBrown

--Sig_/.gVdxjLDrwZT93s+ADnAPbI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTx/pbTnsnt1WYoG5AQLkrw//RVrPxD5aJA4P02YeOZ7ozN0OB2iZazSN
VCHXhYoKIgqHnTbePYrVWZl5cq/aX0OiECg4dHM/E0GhH3fz6g5zz71Jzolj83hp
x47Be6Hb2NWDy9/pp3j3Cs0smgO2rGYTVD4NcYzruyIrjiFP+G/mcuazveIXTwJA
zTO4flMpOzCs5dC2lU755UIoK8hun0Xgvs+T/mJcrZgQoue2YloP2rcoBSf/Yei7
I3Z2WxS9+LsChdZz9e06GSS4Bns6oLXe70173yPnnfjtulhKzJtkWOVJvE3G9nD/
GPIkQTEaDGmr4zS4X67D8yeC6Plu3bNIeA+QhepDVfpcJXjDuH/CFk5Oed8Td3k1
qHW5qoehoUj5uzksDRModX/aCN3vv/E+WuI9IF+R2PmBRJIh2SHtxF6e0gm7c1PQ
PCAOS27RqbcgAhRBena47NH4JjOot+JtZAbpv8VAzXb53teaplOWi4rYvIZbYlw6
ich1iDxlgxGMn9puUJODPDBtZamZ3qVoLg3z8KAoN/VtGwZ+pyFTm/ClXmzzuOvS
9XnpHIyP0uW6VO6dm7os9eFebR7lQKobMuqax4b3sWJwwSgVr2/+WmHhP+kvHVnf
7NxxpKL4jg0MdB55PhaoWpOjF/ZT+ejfni84FLutJ/oWurS2iNOmyYKjNT/dIC/l
7DuqkRzhldk=
=doTG
-----END PGP SIGNATURE-----

--Sig_/.gVdxjLDrwZT93s+ADnAPbI--
