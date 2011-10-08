From: NeilBrown <neilb@suse.de>
Subject: Re: Thought about delayed sync
Date: Sun, 9 Oct 2011 09:36:41 +1100
Message-ID: <20111009093641.4cfa79c9@notabene.brown>
References: <20111008180309.GA14979@animx.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lEe3Pzs8_AO9zYmwDDu5IgV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111008180309.GA14979@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lEe3Pzs8_AO9zYmwDDu5IgV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Oct 2011 14:03:10 -0400 Wakko Warner <wakko@animx.eu.org> wrote:

> A few days ago, I thought about creating raid arrays w/o syncing.  I
> understand why sync is needed.  Please correct me if I'm wrong in any of =
my
> statements.
>=20
> Currently, if someone uses large disks (1tb or larger), the initial sync =
can
> take a long time and until it has completed, the array isn't fully
> protected.  I noted on a raid1 of a pair of 1tb disks took hours to compl=
ete
> when there was no activity.
>=20
> Here is my thought.  There is already a bitmap to indicate which blocks a=
re
> dirty.  Thus by using that, a drop of a disk (accidental or intentional),=
 a
> resync only syncs those blocks that the bitmap knows were dirtied.
>=20
> What if another bitmap could be utilized.  This would be an "in use" bitm=
ap.=20
> The purpose of this could be that there would never be an initial sync.=20
> When data is written to an area that has not been synced, a sync will hap=
pen
> of that region.  Once the sync is complete, that region will be marked as
> synced in the bitmap.  Only the parts that have been written to will be
> synced.  The other data is of no consequence.  As with the current bitmap,
> this would have to be asked for.
>=20
> Lets say someone has been using this array for some time and a disk dropp=
ed
> out and had to be replaced.  Lets also say that the actual usage was about
> 25-30% of the array (of course, that would be wasted space).  With the "in
> use" bitmap, they would replace the disk and only the areas that had been
> written to would be resynced over to the new disk.  The rest, since it had
> not been used, would not need to be.
>=20
> A side effect of this would be that a check or a resync could use this to
> check the real data (IE on a weekly basis) and take less time.
>=20
> Over all, depending on the usage, this can keep the wear and tear on a di=
sk
> down.  I'm speaking of personal experience with my systems.  I have arrays
> that are not 100% or even 80% used.  I have some production servers that
> have extra space for expansion and not fully used.
>=20
> I'm sure this would take some time to implement if someone does this.  As=
 I
> mentioned at the beginning, this was just a thought, but I think it could
> benefit people if it were implemented.
>=20
> I am on the list, but feel free to keep me in the CC.
>=20

I think you are suggesting this:

 http://neil.brown.name/blog/20110216044002#5

??
Patches welcome :-)

NeilBrown

--Sig_/lEe3Pzs8_AO9zYmwDDu5IgV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpDQgjnsnt1WYoG5AQLFGw/+JxdXtAGrP/N2gl68iH1aLjYCsGEXuFOD
+CdRkFHiVxCFwOlhrKF3vcIKjZ4kA30pl6YNkZzIk5vtord2/N2kWMKupfPQbFZ9
9JQgllzHZow0u7IH3VKUe1jshbj+1IX5CX+Pn4DUUoNDCxlQyyxJX+Qc1I1z9txa
FALLSE4D9MiPcsu8R300QOYqQ68HEKf6wLEbWD2a0M1lRFAFt+05tc8bFCs1PhVd
8W859qFTnBAt/fTJabrza//+5xqZo/OtjWNce8pLfAfSqrfFPEJc6NVIzGS7jgcr
ysy7ApoMFGjlDc1rlZEF8A9jPNb/AybJXwWYa0INM27wPH50tIQlus2q1ZzJSg1T
FoEHtMqL51xLb5SYIeeQl8PaLaaXrxd68PlqHXiyoLocioOp7cBk9ejVFPZd+Qdp
24y15acP8YFHdM0ouOcYUFOb7QJMZ2UPNipVQ4wh+mdYDNev3CKGiDtati+GORww
2mT65mFnjsZsO01gzXy9v3ie2gfvoPnWy8D7PThovfNEj+0tgNyCfqEtjiP1+83P
ATSgEdZ+SrSNfGdqbTLl83xGKh523T5xV3H11ZfkS27UUMWGuYaaZgrk0cgLff0B
o+tM/tcJHAqLMn7TWflWEMJ8WlpkxME2MrO/COByZrarTxI/duotvjTDID7WS9fq
axcZSH5msR4=
=3phK
-----END PGP SIGNATURE-----

--Sig_/lEe3Pzs8_AO9zYmwDDu5IgV--
