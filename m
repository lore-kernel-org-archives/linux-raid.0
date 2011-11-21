From: NeilBrown <neilb@suse.de>
Subject: Re: Question about mdadm commit
 d6508f0cfb60edf07b36f1532eae4d9cddf7178b "be more careful about add
 attempts"
Date: Mon, 21 Nov 2011 13:44:29 +1100
Message-ID: <20111121134429.7a6f46cc@notabene.brown>
References: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
	<20111027085125.747691a9@notabene.brown>
	<CAGRgLy7biNy4Tj9wXhBosjC4QNy7dXC2aoimu7ezGqdL82Axxg@mail.gmail.com>
	<20111031101649.657a1ab3@notabene.brown>
	<CAGRgLy7G_M=FtdZ9mmDvxxN52+AF+L=0+OaEP=dK7Z+Z5YBYKw@mail.gmail.com>
	<20111031201933.314d130f@notabene.brown>
	<CAGRgLy5zkfy2bfrJnC_eKQ_-VAcdaKCyeSounjZ3FjBb83T0mQ@mail.gmail.com>
	<20111102095204.024dc6b2@notabene.brown>
	<CAGRgLy5WaOAg2R0FW1=cPgn+sK+PA_=T=GrLj+KWb5HVxbndzQ@mail.gmail.com>
	<20111109104128.7b6f098f@notabene.brown>
	<CAGRgLy49X7KUMdY8hj-99Z46vfzvSnB6LhNZpsN5XedjTdBu1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0H11oZR8MgnlD/0+TdDewLE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy49X7KUMdY8hj-99Z46vfzvSnB6LhNZpsN5XedjTdBu1Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0H11oZR8MgnlD/0+TdDewLE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Nov 2011 13:13:20 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
>=20
> >> However, at least for 1.2 arrays, I believe this is too restrictive,
> >> don't you think? If the raid slot (not desc_nr) of the device being
> >> re-added is *not occupied* yet, can't we just select a free desc_nr
> >> for the new disk on that path?
> >> Or perhaps, mdadm on the re-add path can select a free desc_nr
> >> (disc.number) for it (just as it does for --add), after ensuring that
> >> the slot is not occupied yet? Where it is better to do it?
> >> Otherwise, the re-add fails, while it can perfectly succeed (only pick
> >> a different desc_nr).
> >
> > I think I see what you are saying.
> > However my question is: is this really an issue.
> > Is there a credible sequence of events that results in the current code=
 makes
> > an undesirable decision? =A0Of course I do not count deliberately editi=
ng the
> > metadata as part of a credible sequence of events.
>=20
> Consider this scenario, in which the code refuses to re-add a drive:
>=20
> Step 1:
> - I created a raid1 array with 3 drives: A,B,C (and their desc_nr=3D0,1,2)
> - I failed drives B and C, and removed them from the array, and
> totally forgot about them for the rest of the scenario.
> - I added to the array two new drives: D and E, and waited for the
> resync to complete. The array now has the following structure:
> A: descr_nr=3D0
> D: desc_nr=3D3 (was selected during the "add" path in mdadm, as expected)
> E: desc_nr=3D4 (was selected during the "add" path in mdadm, as expected)
>=20
> Step 2:
> - I failed drives D and E, and removed them from the array. The E
> drive is not used for the rest of the scenario, so we can forget about
> it.
>=20
> I wrote some data to the array. At this point, the array bitmap is
> dirty, and will not be cleared, since the array is degraded.
>=20
> Step 3:
> - I added one new drive (last one, I promise!) to the array - drive F,
> and waited for it to resync. The array now has the following
> structure:
> A: descr_nr=3D0
> F: desc_nr=3D3
>=20
> So F took desc_nr of D drive (desc_nr=3D3). This is expected according
> to mdadm code.
>=20
> Event counters at this point:
> A and F: events=3D149, events_cleared=3D0
> D: events=3D109
>=20
> Step 4:
> At this point, mdadm refuses to re-add the drive D to the array,
> because its desc_nr is already taken (I verified that via gdb). On the
> other hand, if we would have simply picked a fresh desc_nr for D, then
> it could be re-added I believe, because:
> - slots are not important for raid1 (D's slot was taken actually by F).
> - it should pass the check for bitmap-based resync (events in D' sb >=3D
> events_cleared of the array)
>=20
> Do you agree with this, or perhaps I missed something?
>=20
> Additional notes:
> - of course, such scenario is relevant only for arrays with more than
> single redundancy, so it's not relevant for raid5
> - to simulate such scenario for raid6, need at step 3 to add the new
> drive to the slot, which is not the slot of the drive we're going to
> re-add in step4 (otherwise, it takes the D's slot, and then we really
> cannot re-add). This can be done as we discussed earlier.
>=20
> What do you think?

I think some of the details in your steps aren't really right, but I do see
the point you are making.
If you keep the array degraded, the events_cleared will not be updated so a=
ny
old array member can safely be re-added.

I'll have a look and see how best to fix the code.

Thanks.

NeilBrown



>=20
> Thanks,
> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/0H11oZR8MgnlD/0+TdDewLE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsm7DTnsnt1WYoG5AQLRlxAAt+zyEXrHjFzEAsftm5ssAa0/zSPO0LuO
lpwEd+RdN9FF7MdkSRK9kx2zpvBjmTRl7OIR7Pw+50liyHS1UVlGzfkSJg27rzP4
RGbSjxT2Y0P9IZLA8LDi13dRD5Dj9q9055O1v1yQitOo5vUSXCqBcyhox3SkaEOZ
2SqqH9ShrNcG+n6uTtZChAZScHtLCN5mJ+Wc/GGdzuuAdYcOoeSw3Tz3SJ/Nxs+E
srtn8jqH2SYiKv8tRakrLi68KzGTn3mySWcxUhtY4Yzaalm2vXmAsbh9vrxRO6vN
uD5f8+fOsshCSbdeuqh8McsoX1wedWSe1GNHgbpmMte1554Jj6juZJlIehj7Hm/U
DQ3DGIRChghbULKOD1yiqaqXWb9oOWvMRnPHgC7jonPzfU9KxssYg2ZFGlpbcBdc
Q3AInsMPTQLVGvELiHpJAsxYww10kx8zsj+WfE/mPF5Ul7EPc2VPShSiLwykfygL
1T7Pny5x7v69h+mnW8xgib8RQMMKstqTxIYIokIi/3K4hUrCaeOLuiFJdsWjzZd2
yU3Uy8bzf4UVZHv8mFoRrpyial/cKsamUOlqdYwkDVbh/dLnYj8KDjO2dlUvP6Ld
gzJn/dRmk9FaBB6Mh1vbngPhNupM4Eb2opVLS3piG92H4ilzCSTq2Oz6IpjLjSvI
DMz55kRdK40=
=+G8a
-----END PGP SIGNATURE-----

--Sig_/0H11oZR8MgnlD/0+TdDewLE--
