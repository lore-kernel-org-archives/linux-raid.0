From: NeilBrown <neilb@suse.de>
Subject: Re: software raid and ERC
Date: Wed, 18 Apr 2012 13:52:10 +1000
Message-ID: <20120418135210.24ff8db5@notabene.brown>
References: <CAAevFRRuGc6x4hJax-kM8ncW9=873aRnjN-WWkoheYD7r6jimA@mail.gmail.com>
	<CAAevFRQw97xTgpct9ML_SWAyw-Zc=9fuioigVBpg7HpZ89kQxg@mail.gmail.com>
	<CAAevFRRh2YiQOe1cbEFc+wY8UnBCEMAvrLdBsQLzfWt-6URpXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nFukQ_tFB7sJfE37j+jcBvS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAevFRRh2YiQOe1cbEFc+wY8UnBCEMAvrLdBsQLzfWt-6URpXA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "." <desire@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/nFukQ_tFB7sJfE37j+jcBvS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 11:12:57 +0800 "." <desire@gmail.com> wrote:


> Apart from the behaviour of the SCSI layer, does the linux software
> raid layer have any concept of timeouts that would cause a drive to be
> kicked when performing a deep recovery cycle?  A storagereview forum
> thread [3] claims that the linux software raid layer does not have a
> concept of timeouts and does not care about ERC.  In a web article [4]
> the major NAS manufacturers that use software raid seem to agree with
> this stance.

Linux software RAID does not have a concept of timeouts.

>=20
> On the other hand, how I interpret a previous post from Stefan [5] is
> that the linux raid layer does have its own timeout mechanism that
> will kick a non-responding drive.

That aspect of that post is inaccurate.

>=20
> > Without ERC-timeout, the drive tries to correct the error on
> > its own (not reacting on any requests), mdraid assumes an error after a
> > while and tries to rewrite the "missing" sector (assembled from the
> > other disks).  But the drive will still not react to the write request
> > as it is still doing its internal recovery procedure.  Now mdraid
> > assumes the disk to be bad and kicks it.
>=20
> Since I can't read code, I'm hoping that this list where software raid
> development takes place would be able to clear up whether
>=20
> a.  Do delays caused by deep recovery cycles actually have any direct
> impact on the linux software raid layer, or does it simply issue a
> command to the underlying storage/scsi subsystem and block until there
> is a response?

md/raid in linux simply issues a command and waits for it to complete, eith=
er
with success or failure.

NeilBrown


--Sig_/nFukQ_tFB7sJfE37j+jcBvS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT446ajnsnt1WYoG5AQK2kw//clbeFGHlJso8xlS/fbWDNoktNVpGsHTu
k2LdItG2GjjozBv0LDms5CKcMdpUz11LnKYuXo+Poeyqu21pM8HSRmc3lx2+PC2C
M8prWV21jcz6Bud7jmOaCyzPdzxsGtIoBRDWyz5gzOEhHhByjb4T1GtewU1O8hmf
sigHEh6TUjovHe19u3p8moXyiXTL9FsdBujWJtRv3mwYWRIncFogL5nVWxYVGbkB
zQjBJV56mKr+e5GCScqXYVgOdr6dtjH+0wjxgeqksD2yWelhRhu2urOUW5Le80qQ
6jswHr6MbbacQ24EbQdRapOx2kvZ4xKnNqYqImhLK7ckpxuA0zo2HUScv+E7eFBr
BjGJrg+tVF2TgndBrcJ6Fir3MaZrjJ2LI3lzisQYSy0P5ZtwoS101Tec8ZdFOTBw
ekEdvtPEtyfBl9NYrBMLlAgaoYFQ3AT7rKiG72SucXwCqdbMdqUegkSGmK5KCLaM
hc6rueUGiNf6O1qIBingpR9hgg1Hh65+lNA3pTGrB4jOa1/FDVZB9rNxAZLe7Knr
vsizaZ3FnObPzjzmj5XFfL2UajvzvW2NPtROfPqMft+v94iGDGmffvGuFIBWFXl+
s5K+jlWFi4Qi77gIE6vktGmC4eJnb55qFgEQoFW483bh3M7UhIkKSxrCixtzTSxx
7KPt8efE+co=
=JsSJ
-----END PGP SIGNATURE-----

--Sig_/nFukQ_tFB7sJfE37j+jcBvS--
