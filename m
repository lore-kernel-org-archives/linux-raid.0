From: NeilBrown <neilb@suse.de>
Subject: Re: Massive data corruption on replace + fail + rebuild
Date: Mon, 25 May 2015 15:22:20 +1000
Message-ID: <20150525152220.20b11db9@notabene.brown>
References: <555CF034.8050303@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/twGxEmb+387Jc/glOLG1DLm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <555CF034.8050303@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: James J <james.j@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/twGxEmb+387Jc/glOLG1DLm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 22:36:04 +0200 James J <james.j@shiftmail.org> wrote:

> Hello all,
> I wrote some days ago to the ML with subject "MD RAID hot-replace wants=20
> to rewrite to the source! (and fails, and kicks)"
> The problem went much worse than that and ended with massive data=20
> corruption on the replacement drive sdm.
>=20
> In this report I will use the same letters as in previous email: sdl for=
=20
> the failing drive, sdm for the replacement drive.
> This report is for raid5 on kernel 3.4.34 .

Bug was fixed in 3.4.56

   0761d079bbc2 ("md/raid5: fix interaction of 'replace' and 'recovery'.")

and  3.11

   f94c0b6658c7 ("md/raid5: fix interaction of 'replace' and 'recovery'.")


> Bad blocks list is not enabled.
> Bitmap is enabled
> See previous post for details, mdstat and dmesg log.
>=20
> It seems that the following series of events deeply corrupts the=20
> replacement drive:
> 1) drive sdl is flaky, so the user initiates replacement process=20
> (want_replacement) to the spare drive sdm
> 2) the disk sdl has read errors on some sectors. MD performs reconstruct=
=20
> read and then rewrite for those sectors. Currently MD wants to rewrite=20
> the source drive sdl, instead of just to the replacement drive sdm which=
=20
> I would much prefer.

It probably makes sense to avoid repairing read errors of a drive being
replaced.  I've put it on my todo list, but I'm afraid I haven't looked at
that much lately.

However any writes to the array would have to be written to both drives.
If we only ever wrote to the replacement drive, it would be very hard to ke=
ep
track of where to read from.
So if you have a device that cannot survive being written to, then you would
need to avoid writing to the array completely.

NeilBrown




> 3) sdl unfortunately is too flaky to receive rewrites, so it fails on=20
> the rewrites and is kicked by MD. The array is now degraded
> 4) At this point, MD apparently continues the rebuild process=20
> transforming the replacement into a full rebuild, but continuing from=20
> the point where sdl was kicked, and not from the start. This seems=20
> smart, however I guess there is a bug in doing this, maybe an off-by-N=20
> error. In the previous post you can see the dmesg line "[865031.586650]=20
> md: resuming recovery of md54 from checkpoint."
>=20
> At the end of the rebuild, when MD starts using sdm as a member drive,=20
> an enormous amount of errors appear on the filesystems located on that=20
> array.
>=20
> In fact, I performed a check afterwards, and this was the mismatch_cnt:
>=20
>    root@server:/sys/block/md54/md# cat mismatch_cnt
>    5296438776
>=20
> This is on a 5x3TB array so about 90.4% of it has mismatches, if my math=
=20
> is correct.
>=20
> The drive sdl was kicked at about 1% of the replacement process, so this=
=20
> 90.4% would not match, should have been 99%, but considering that many=20
> stripes could be zeroes, an 8.5% could be parities on zeroes which match=
=20
> just by chance.
>=20
> So I suppose there is a problem in the handover between the replacement=20
> and the rebuild. I would bet on an off-by-N problem, i.e. a shifting of=20
> the data. Maybe the sources start a reconstruct-read from the beginning=20
> of the array while the destination continues writing from the point of=20
> the handover, or vice versa.
>=20
> Currently I have "solved" the problem already, by artificially failing=20
> the drive sdm, and introducing another disk as spare to perform a clean=20
> rebuild from scratch. After failing sdm and dropping the caches, before=20
> inserting the new spare, the filesystems were readable again, so I was=20
> optimistic, and in fact at the end of the clean rebuild this appears to=20
> have recovered our data and mismatch_cnt is now zero. However I was=20
> lucky to have immediately understood what happened, otherwise we would=20
> have probably lost all our data, so please look into this.
>=20
> Thanks for your work
> PS: I would appreciate if you can also make MD not rewrite to the source=
=20
> during replacement :-)
> JJ
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/twGxEmb+387Jc/glOLG1DLm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKxjDnsnt1WYoG5AQL9xhAAgaAZe3M1qC3DBz+aWRBoJ+zuaw7DC/At
wpdWsGzKux25JXCHzpFs0hSCq2ngKWJL6P2O4jQUmc+bH5MCjJ/WOo4KXufSrQjK
j+5U5DO/VxCKZQT6E8M+sdtMjKysUStrhrRYDBT/mCAmL8oFby832X43HbXopPAY
eEdl3vbuoHYN8b101hkF3fTMGJZ71+R8lGTtSPTrCM7XvX3KvmoNFqO0/NTYdz5F
7wzew0rovzcLQtcLHP2uLJCYm2ENVZI+9otqTWEN5fEE4PH8CqdtQuVOvai1+IEz
/IjI95Cehr0YAB3HQn7DEEC8AAmhA8okNGE0GpGQuZzkqFYcBl3XWqhc3/LARn/z
Lmzo/znPrlgRP9XMLI2+cStQ7g8aE/SS9B7SRBagsCRAfm7EjBUxt2aZORe0Elwh
LQGfncJtODaw3dZ7XSi8hEJqluvWGqrHYbDyFpvYK0lWglyVBgnfdmVdC/dUAs2H
wbNJmi4zb5gWyGSsa3+jnl16DMU1uctxHRGCD+vdoe/mGmLw0Dkk6l3WZiviUppV
OChBgkaX9eiUlbMzjPloIzqAFzdNzUQd3vVAPiGAAZDjCYoKEYRFytUXUmnkoWEv
c0POC3qxu+kMibcP5JVtIuOlyQhHwY7pKU38fw6y4xTJ37suR6T7spO/9Z4cAJIn
WpJkPIzz+W0=
=Y7Xc
-----END PGP SIGNATURE-----

--Sig_/twGxEmb+387Jc/glOLG1DLm--
