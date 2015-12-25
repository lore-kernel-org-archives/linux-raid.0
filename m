From: NeilBrown <nfbrown@novell.com>
Subject: Re: Create Lock to Eliminate RMW in RAID/456 when writing perfect stripes
Date: Fri, 25 Dec 2015 18:58:50 +1100
Message-ID: <87h9j7yn5x.fsf@notabene.neil.brown.name>
References: <CAFx4rwR1gtLZUF6MUx71QTvw3hT5GKhsEMU2xcBpAz5wZWBUCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwR1gtLZUF6MUx71QTvw3hT5GKhsEMU2xcBpAz5wZWBUCw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 24 2015, Doug Dumitru wrote:

> The issue:
>
> The background thread in RAID-5 can wake up in the middle of a process
> populating stripe cache entries with a long write.  If the long write
> contains a complete stripe, the background thread "should" be able to
> process the require without doing any reads.
>
> Sometimes the background thread is too quick at starting up a write
> and schedules a RMW (Read Modify Write) even though the needed blocks
> will soon be available.
>
> Seeing this happen:
>
> You can see this happen by creating an MD set with a small stripe size
> and then doing DIRECT_IO writes that are exactly aligned on a stripe.
> For example, with 4 disks and 64K stripes, write 192K blocks aligned
> on 192K boundaries.  You can do this from C or with 'dd' or 'fio'.
>
> If you have this running, you can then run iostat and you should see
> absolutely no read activity on the disks.
>
> The probability of this happening goes up when there are more disks.
> It may also go up the faster the disks are.  My use case is 24 SSDs.
>
> The problem with this:
>
> There are really three issues.
>
> 1)  The code does not need to work this way.  It is not "broken" but
> just seems wrong.
> 2)  There is a performance penalty here.
> 3)  There is a Flash wear penalty here.
>
> It is 3) that most interests me.
>
> The fix:
>
> Create a waitq or semaphore based lock so that if a write includes a
> complete stripe, the background thread will wait for the write to
> completely populate the thread.
>
> I would do this with a small array of locks.  When a write includes a
> complete stripe, it sets a lock (stripe_number % sizeof_lock_array).
> This lock is released as soon as the write finishes populating the
> stripe cache.  The background thread checks this lock before it starts
> a write.  If the lock is set, it waits until the stripe cache is
> completely populated which should eliminate the RMW.
>
> If no writes are full stripes, then the lock never gets set, so most
> code runs without any real overhead.
>
> Implementing this:
>
> I am happy to implement this.  I have quite a bit of experience with
> lock structures like this.  I can also test on x86 and x86_64, but
> will need help with other arch's.
>
> Then again, if this is too much of an "edge case", I will just keep my
> patches in-house.

Hi,
 this is certainly something that needs fixing.  I can't really say if
 your approach would work or not without seeing it and testing it on a
 variety of work loads.

 Certainly if you do implement something, please post it for other to
 test and review.  If it makes measurable improvements without causing
 significant regressions, it will likely be included upstream.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWfPc6AAoJEDnsnt1WYoG58FQQAKuSzGGx2FpfuRVuQ67t1yaw
UrNOZjaJeousYlWq9pX0w93LshCXBe3oGSNI0nXjWn6skx6/idv8uUVyvzpfOjNZ
mXX9yhyzMxc73HLTXRd+sUOdNXlGO9aL/kKLlWeavD8VXW5VY8KY/2pNdS/L7wwR
L31WO4gFgG1mxRgy90RuCtjMxIfRnmWK8hrjkGC6RubbmMc8Lyb1Yv6lx/S1JKBI
TJj6mQRSx9YHhJVQsGuxvOFnNis6ErQrV6sny0YJSMqEtne0xdLL+OS+azgI6gdr
hqh/RCp+q2gH+RZm4bPmT9U5a4beeVpXrrVanlsaWhyknGLeeK4xINje895Coilq
aFmaE2d+aB8Gt3fOy9yZnIbvU/SmSiBkiQQQ0+lEfQ9F1pIcq/+mjOK7E+Onuxdd
MfcTQ/P1Ut+dymmKYRtvGtyP2fpSsmW1p5TO+mIyM59t1JSezoM+MpqaH4sxAvFq
T5jHMlHFsFpa4EzXCv1GFPgutO1Jf5+iFerjaYuuQI3g0d6jRunpIpbMIT8wzaZx
KjW/GXtjVa82KNXc8r5fv36VKnk0K1K/wnP54ZnEWvlhwyX2mL3v4GDtq36Q8e9S
cnkVHLFzylmO7LQZbdvY3y6muJ0k4jWmUeE95VtRGuNSi3OPAEU71vk3lv/pQlNm
tsOw/452JJvX65TJY6+Z
=V0CE
-----END PGP SIGNATURE-----
--=-=-=--
