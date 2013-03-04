From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/4] md: Don't do normal-write on unresync area of
 replacement-disk.
Date: Mon, 4 Mar 2013 16:30:22 +1100
Message-ID: <20130304163022.7e18af78@notabene.brown>
References: <201302281550356268273@gmail.com>
	<20130304130435.4113d2a4@notabene.brown>
	<201303041024138712338@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//kdt/lXgfyg3r7DM+9toY_0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201303041024138712338@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//kdt/lXgfyg3r7DM+9toY_0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Mar 2013 10:24:16 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >On Thu, 28 Feb 2013 15:50:37 +0800 majianpeng <majianpeng@gmail.com> wro=
te:
> >
> >> Replacement is a fullsync which don't depent on bitmap.So regardless of
> >> the presence and absence of bitmap, it do full resync.
> >> If offset of normal io is larger than offset of resync,it will write
> >> again when resync arrived this offset.
> >
> >This might be OK for RAID1 and RAID10 as recover is paused when writes
> >happen, but that is not the case for RAID5, so it isn't safe to test aga=
inst
> >curr_resync - it gets updated a bit too later.
> >
> ->curr_resync + STRIPE_SECTORS is the next stripe which willbe replaced.
> How about the ->curr_resync+STRIPE_SECTORS?

If you aren't certain, then neither am I.

As resync and normal writes can be intermingled you would need some guarant=
ee
that a write wouldn't be missed, and that almost certainly means a test und=
er
a lock against some value which is updated under a lock.

>=20
> >Also you messed up the formatting in raid10.c
> >
> Can you explain in detail?


>>  		if (rrdev && (test_bit(Faulty, &rrdev->flags)
>> -			      || test_bit(Unmerged, &rrdev->flags)))
>> +			|| test_bit(Unmerged, &rrdev->flags) ||=20
>> +			(test_bit(Replacement, &rrdev->flags) &&
>> +			conf->mddev->curr_resync < r10_bio->sector)))

Text that is inside parentheses (or other brackets) should never be to the
left of the opening parenthesis unless that parenthesis is at the end of a
line.
In the original code, the "|| test_bit(Unmerged....." was to the right of t=
he
'('.  In your version it starts to the left, and the lines you added also
start to the left.

> >I'm not convinced this optimisation is really worth it.
> >
> Maybe for HDD disk, it only improve speed by reducing some write operatio=
n.
> But for ssd disk, it can reduce one write.

Still doesn't sound convincing.


NeilBrown

>=20
> Thanks!
> Jianpeng Ma
> >NeilBrown
> >
> >
> >>=20
> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/raid1.c  |    4 +++-
> >>  drivers/md/raid10.c |    4 +++-
> >>  drivers/md/raid5.c  |    3 ++-
> >>  3 files changed, 8 insertions(+), 3 deletions(-)
> >>=20
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index d5bddfc..142a5fa 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -1173,7 +1173,9 @@ read_again:
> >>  				set_bit(R1BIO_Degraded, &r1_bio->state);
> >>  			continue;
> >>  		}
> >> -
> >> +		if (test_bit(Replacement, &rdev->flags) &&
> >> +			conf->mddev->curr_resync < r1_bio->sector)
> >> +			continue;
> >>  		atomic_inc(&rdev->nr_pending);
> >>  		if (test_bit(WriteErrorSeen, &rdev->flags)) {
> >>  			sector_t first_bad;
> >> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> >> index 64d4824..bb11cfb 100644
> >> --- a/drivers/md/raid10.c
> >> +++ b/drivers/md/raid10.c
> >> @@ -1337,7 +1337,9 @@ retry_write:
> >>  			     || test_bit(Unmerged, &rdev->flags)))
> >>  			rdev =3D NULL;
> >>  		if (rrdev && (test_bit(Faulty, &rrdev->flags)
> >> -			      || test_bit(Unmerged, &rrdev->flags)))
> >> +			|| test_bit(Unmerged, &rrdev->flags) ||=20
> >> +			(test_bit(Replacement, &rrdev->flags) &&
> >> +			conf->mddev->curr_resync < r10_bio->sector)))
> >>  			rrdev =3D NULL;
> >> =20
> >>  		r10_bio->devs[i].bio =3D NULL;
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index bd49623..e0a2a39 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -602,7 +602,8 @@ static void ops_run_io(struct stripe_head *sh, str=
uct stripe_head_state *s)
> >>  			rdev =3D NULL;
> >>  		if (rdev)
> >>  			atomic_inc(&rdev->nr_pending);
> >> -		if (rrdev && test_bit(Faulty, &rrdev->flags))
> >> +		if (rrdev && (test_bit(Faulty, &rrdev->flags) ||
> >> +			conf->mddev->curr_resync < sh->sector))
> >>  			rrdev =3D NULL;
> >>  		if (rrdev)
> >>  			atomic_inc(&rrdev->nr_pending);
> >
> >

--Sig_//kdt/lXgfyg3r7DM+9toY_0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTQxbznsnt1WYoG5AQJj6BAAqH3LhNskfLw6F0rg62DNzqe+3LT1pHMc
S6kHh7P8KnEzlEQhtbNUxTuKbwSDEbCQnrh7duYGASQoZG8hbeocX0Oa5ZGeM5RD
xcI5JMgDAX6YZskSWOS1beYXRqTO5BoPZ62YSI8qmmu0GFjFOEw7wAz0F2Tx3Bvr
1o5vWMU8MK895tWk8MbiFMbJPVyNS3wdCAvXW5fYxlItZB9XzZgDAH3U0wAT2B0b
WfVDBRZ22ZziPo7d6RnH3YXGSJGSGWYzFCMBm5A/JGbk2oB3+OPq4t6ufMwAJ+A2
XOQGetM55PILA+r18o4CM9H8AVGwh9NjmnP4de9G9H9ALXJbhIpJZ8fS7FCOMQmw
JBcQ6wNYXZm8k1QIa+vbe1JByRTtBgMrIEj1f/6llZW16yIsgiwE/AAiL+umWae3
WK/nlgcWzlc+ojCfX8QW+is5WNeMqZBMY/F9luIQYq+stTadv24b6sD96JLgMLOb
WTpXaqmHl1DYPjHSUw70lODNh1FXY1/ye8EbeuKJLTS+VREyDKEGgZHFzKVcYGhp
JqzzHg7luF0fY8g5kRFciGTJpy+sffiqnz1TsZNk6rAOn8urp9J37vmETCQ7CQ3T
wuHVuUww8YljqxJmlIfUS4jv0hTEj3IAwt2hn8BkLMgHmRWLnViHw+br9g6J43s6
v5+9M7XKOZI=
=cRV+
-----END PGP SIGNATURE-----

--Sig_//kdt/lXgfyg3r7DM+9toY_0--
