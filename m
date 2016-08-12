From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/3] MD: hold mddev lock for .quiesce in md_do_sync
Date: Fri, 12 Aug 2016 10:04:05 +1000
Message-ID: <87h9aqluoa.fsf@notabene.neil.brown.name>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com> <87y44epwb5.fsf@notabene.neil.brown.name> <87y44dnrz2.fsf@notabene.neil.brown.name> <20160806041428.GB9281@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160806041428.GB9281@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 06 2016, Shaohua Li wrote:

> On Thu, Aug 04, 2016 at 01:16:49PM +1000, Neil Brown wrote:
>> On Wed, Aug 03 2016, NeilBrown wrote:
>>=20
>> > [ Unknown signature status ]
>> > On Sun, Jul 31 2016, shli@kernel.org wrote:
>> >
>> >> From: Shaohua Li <shli@fb.com>
>> >>
>> >> .quiesce is called with mddev lock hold at most places. There are few
>> >> exceptions. Calling .quesce without the lock hold could create races.=
 For
>> >> example, the .quesce of raid1 can't be recursively. The purpose of th=
e patches
>> >> is to fix a race in raid5-cache. The raid5-cache .quesce will write md
>> >> superblock and should be called with mddev lock hold.
>> >>
>> >> Cc: NeilBrown <neilb@suse.com>
>> >> Signed-off-by: Shaohua Li <shli@fb.com>
>> >
>> > Acked-by: NeilBrown <neilb@suse.com>
>> >
>> > This should be safe but I'm not sure I really like it.
>> > The raid1 quiesce could be changed so that it can be called recursivel=
y.
>> > The raid5-cache situation would be harder to get right and maybe this =
is
>> > the best solution... It's just that 'quiesce' should be a fairly
>> > light-weight operation, just waiting for pending requests to flush.  It
>> > shouldn't really *need* a lock.
>>=20
>> Actually, the more I think about this, the less I like it.
>>=20
>> I would much rather make .quiesce lighter weight so that no locking was
>> needed.
>>=20
>> For r5l_quiesce, that probable means removed the "r5l_do_reclaim()".
>> Stopping and restarting the reclaim thread seems reasonable, but calling
>> r5l_do_reclaim() should not be needed.  It should be done periodically
>> by the thread, and at 'stop' time, but otherwise isn't needed.
>> You would need to hold some mutex while calling md_register_thread, but
>> that could be probably be log->io_mutex, or maybe even some other new
>> mutex
>
> We will have the same deadlock issue with just stopping/restarting the re=
claim
> thread. As stopping the thread will wait for the thread, which probably is
> doing r5l_do_reclaim and writting the superblock. Since we are writting t=
he
> superblock, we must hold the reconfig_mutex.

When you say "writing the superblock" you presumably mean "blocked in
r5l_write_super_and_discard_space(), waiting for  MD_CHANGE_PENDING to
be cleared" ??
With a bit of care you could wait for MD_CHANGE_PENDING to clear, or for
=2D>quiesce to be set, and then exit gracefully.

>
> Letting raid5_quiesce call r5l_do_reclaim gives us a clean log. Just
> stop/restart the reclaim thread can't guarantee this, as it's possible so=
me
> space aren't reclaimed yet. A clean log will simplify a lot of things, for
> example we change the layout of the array. The log doesn't need to rememb=
er
> which part is for the old layout and which part is the new layout.

I really think you are putting too much functionality into quiesce.
When we change the shape of the array, we do much more than just
quiesce it.  We also call check_reshape and start_reshape etc.
They are called with reconfig_mutex held and it would be perfectly
appropriate to finish of the r5l_do_reclaim() work in there.

>
> I think we can add a new parameter for .quiesce to indicate if reconfig_m=
utex
> is hold. raid5_quiesce can check the parameter and hold reconfig_mutex if
> necessary.

Adding a new parameter because it happens to be convenient in one case
is not necessarily a good idea.  It is often a sign that the interface
isn't well designed, or isn't well understood, or is being used poorly.

I really really don't think ->quiesce() should care about whether
reconfig_mutex is held.  All it should do is drain all IO and stop new
IO so that other threads can do unusually things in race-free ways.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXrRJ2AAoJEDnsnt1WYoG5he0QAJlFaC9VFRNy0rGK1H5AO/Dh
sPrb4lyeSTeG6gIuqBVhhRAc+1ijCxYAhlHejAXrk/MYmurua9HreCQzsmeEWKer
T2/bDCDeb+FqbCH2mxtrexuewbBOS/XHA++oNTg+ZnZrmZ1nP0eKGID8Vc+97Yvc
vQrDW7jw9l2fqb3ICv+VQKBlSl9KA1JkrdIuXhoGPVcw8verxb82qa69OF+tu2VK
7Qarw6bUKNAMKkv8PG0bteBEEAuSv0ffxjuB9TeeTZ47g2zNTFwXT5whNhMXAC9m
yB7vJLqg13n3Tv0pPRLdGRhhBD7rK7s5Lp+f6BDF2ooCDaXZiV8MGhLOa987AYVe
iZiQXZaxM+5n1L6FbdBPSCTLPVfnMsU4ixoU+7QJHL2bbNb3j0uKbBz7g0dJ7C14
PG14rGuFAqoSy+enLJCI3Xci18RHIK1huweQHBBC+5onQyvdPDDdrZFrTtN/TTVv
dsbX63zmn3iOzQ8g9DeSntFGIj8YEWaGmtwe6EusPx4j10BHUnja4aDkv77TuKfu
bYsDcJTI7HrXbLE1HMtdeCJ72hZqQfLH/ZJF4k3IQ2hhZGCZdF10YX8YtEmejSUw
DvuwPN0UPpzIzJef+aGQQ0P3aJiGkG40TvdgsbU1CGFjnlJvqRn2MJb9j6I7lhyj
km2SfoaxQxG7DYJK/xWd
=XI4M
-----END PGP SIGNATURE-----
--=-=-=--
