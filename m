From: NeilBrown <neilb@suse.de>
Subject: Re: Help recovering an interrupted raid0 reshape
Date: Wed, 8 Apr 2015 12:09:55 +1000
Message-ID: <20150408120955.692b2564@notabene.brown>
References: <CAC_83AFDEijn-7gNmnWNNabzcuPRMabNwr8xfRFt0xacsvZfog@mail.gmail.com>
	<20150407094608.4a9dd142@notabene.brown>
	<20150407115033.1d63b65c@notabene.brown>
	<CAC_83AFo47Zfe7rMqro7_k8dR-xpMcfiwQA7a9DTKpKPuHr=fA@mail.gmail.com>
	<20150407163004.7550da77@notabene.brown>
	<CAC_83AEtgtiN-WD-U8OG_nzsoRWQmrn6mxKMhKk6cxK4ZD5yaQ@mail.gmail.com>
	<20150408071339.3295567b@notabene.brown>
	<CAC_83AGk2MK8=qy2CL-WN-ewfVzgA2D-WRkefpriXrdHSEjU-Q@mail.gmail.com>
	<20150408085635.64fa7101@notabene.brown>
	<CAC_83AF0EHVVDF7Gwdfw9WB34v+nHCFmpjLR7AQ5qOz5QATgdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/im1HDnjQmeRixbox5vEfGbH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC_83AF0EHVVDF7Gwdfw9WB34v+nHCFmpjLR7AQ5qOz5QATgdQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jonathan Harker (Jesusaurus)" <jesusaurus@gentlydownthe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/im1HDnjQmeRixbox5vEfGbH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Apr 2015 16:24:35 -0700 "Jonathan Harker (Jesusaurus)"
<jesusaurus@gentlydownthe.net> wrote:

> On Tue, Apr 7, 2015 at 3:56 PM, NeilBrown <neilb@suse.de> wrote:
> >
> >
> > Hmm... I think I see the bug.  It should be easy enough to fix, but I'd=
 like
> > to be able to test it.
> > Could you please:
> >
> >  mkdir /tmp/md.metadata
> >  mdadm --dump /tmp/md.metadata /dev/md/alpha /dev/md/beta /dev/md/gamma
> >  tar czSf /tmp/md.tgz /tmp/md.metadata
> >
> > and then send me /tmp/md.tgz, which should be tiny and contain just the
> > metadata from the array.
>=20
> I'll send that to you once tar finishes.

Thanks.  And just as well I tested as there was another problem.
I think it is all fixed now.
If you:

 cd /tmp
 git clone git://neil.brown.name/mdadm
 cd mdadm
 make
 ./mdadm -A /dev/md124 --force -vvvv /dev/md/{alpha,beta,gamma}

it should assemble the array and continue the reshape.

When it finishes it will leave the array as degraded RAID4.
Simply:
  mdadm /dev/md125 --grow --level=3D0

and it will instantly become RAID0.

NeilBrown

>=20
> >
> > [[the patch which introduced the problem has a description which starts
> >     "This is a bit of a hack and ..."
> >   Never accept hacks!
> > ]]
>=20
> I've reviewed and accepted a few hacks in my day as well. Hopefully
> the cleanup isn't too ugly.
> Thanks again for looking into this.
>=20


--Sig_/im1HDnjQmeRixbox5vEfGbH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSSN9Dnsnt1WYoG5AQKLLA/5AQg3AP+PZgImEzNbY0d3jlx0ACGh+EYg
dhTt86S6O7Xk8Eomf7XXFelqsZme7N9xUjwAAq3/4255HxLNSaYt8YoFufUUvwSj
TAX0+cErRioqIH3+G9TmSuWIQgHGwJws5uxaG80I+vMnR2moDjO9oU6ahuoXbvVz
eHXs57CWI35GEM1KeW6Yp03Yc41wLzieFu2ESuT93tCvSaqv6zF8wnFMRmhjshVx
tQg9OSmnLAx8DDRwkHvlhqq8UXK/sInJtsxuWnar3q3H0aNzFt2hqwkgfzv2Gs4C
SnITtimQ2Mog5g13fi5mdgfto20PuMohvJNP4vo4qECK/ZqpACwdphY9Jwtp1CR0
Uk29YGVtKkAWEsAiuh2DpmZQCK1/G0TgSJ3zLOZjCARCInctD8LF5GTLbK3GmHks
6pwL0FYkhwNLY8VM+Mc/0FpJgxXC5DFfzATLtTZ4RWRmeR2psNLNgfvdNX7o9ANb
LkHi9OqTI5hW6B0rx5FnCY7EAxy3LYthS6qAB41nVVXC9Fbb4pTIpvzcxCdgUMZG
tZbs8KxD+f8OYZVm6Lx5t9Fmt86ZRtg8T6II8zkMgXB+uSu8xSWd/6drGxSqIJ/C
wE5/ciFgv4WzZ67riySVgBA3i0rfOVt+HEyx48cTQjRGKMDhsMkfbxGFulPS0JZ8
82uRss9FSWs=
=e4u1
-----END PGP SIGNATURE-----

--Sig_/im1HDnjQmeRixbox5vEfGbH--
