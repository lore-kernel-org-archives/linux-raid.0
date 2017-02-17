From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 14/14] MD: use per-cpu counter for writes_pending
Date: Fri, 17 Feb 2017 13:34:18 +1100
Message-ID: <87a89l4kb9.fsf@notabene.neil.brown.name>
References: <148721992248.7521.17160361058957519076.stgit@noble> <148721994322.7521.3431105903303667812.stgit@noble> <20170216201211.3q7rvvp2p3xxz6ew@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170216201211.3q7rvvp2p3xxz6ew@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 16 2017, Shaohua Li wrote:

> On Thu, Feb 16, 2017 at 03:39:03PM +1100, Neil Brown wrote:
>> The 'writes_pending' counter is used to determine when the
>> array is stable so that it can be marked in the superblock
>> as "Clean".  Consequently it needs to be updated frequently
>> but only checked for zero occasionally.  Recent changes to
>> raid5 cause the count to be updated even more often - once
>> per 4K rather than once per bio.  This provided
>> justification for making the updates more efficient.
>>=20
>> So we replace the atomic counter with a per-cpu array of
>> 'long' counters. Incrementing and decrementing is normally
>> much cheaper, testing for zero is more expensive.
>>=20
>> To meaningfully be able to test for zero we need to be able
>> to block further updates.  This is done by forcing the
>> "increment" step to take a spinlock in the rare case that
>> another thread is checking if the count is zero.  This is
>> done using a new field: "checkers".  "checkers" is the
>> number of threads that are currently checking whether the
>> count is zero.  It is usually 0, occasionally 1, and it is
>> not impossible that it could be higher, though this would be
>> rare.
>>=20
>> If, within an rcu_read_locked section, checkers is seen to
>> be zero, then the local-cpu counter can be incremented
>> freely.  If checkers is not zero, mddev->lock must be taken
>> before the increment is allowed.  A decrement is always
>> allowed.
>>=20
>> To test for zero, a thread must increment "checkers", call
>> synchronize_rcu(), then take mddev->lock.  Once this is done
>> no new increments can happen.  A thread may choose to
>> perform a quick test-for-zero by summing all the counters
>> without holding a lock.  If this is non-zero, the the total
>> count is non-zero, or was non-zero very recently, so it is
>> safe to assume that it isn't zero.  If the quick check does
>> report a zero sum, then it is worth performing the locking
>> protocol.
>>=20
>> When the counter is decremented, it is no longer possible to
>> immediately test if the result is zero
>> (atmic_dec_and_test()).  We don't even really want to
>> perform the "quick" tests as that sums over all cpus and is
>> work that will most often bring no benefit.
>>=20
>> In the "safemode=3D=3D2" case, when we want to mark the array as
>> "clean" immediately when there are no writes, we perform the
>> quick test anyway, and possibly wake the md thread to do the
>> full test.  "safemode=3D=3D2" is only used during shutdown so
>> the cost is not problematic.
>>=20
>> When safemode!=3D2 we always set the timer, rather than only
>> when the counter reaches zero.
>>=20
>> If mod_timer() is called to set the timeout to the value it
>> already has, mod_timer() has low overhead with no atomic
>> operations.  So at worst it will have a noticeable cost once
>> per jiffie.  To further reduce the otherhead, we round the
>> requests delay to a multiple of ->safemode_delay.  This
>> might increase the delay until the timer fires a little, but
>> will reduce the overhead of calling mod_timer()
>> significantly.  If lots of requests are completing, the
>> timer will be updated every 200 milliseconds (by default)
>> and never fire.  When it does eventually fire, it will
>> schedule the md thread to perform the full test for
>> writes_pending=3D=3D0, and this is quite likely to find '0'.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>
> This sounds like a good place to use percpu-refcount. In set_in_sync, we =
switch
> it to atomic, read it, then switch it back to percpu.

I did have a quick look at percpu-refcount and it didn't seem suitable.
There is no interface to set the counter to atomic and wait for that to
complete.
There is also no interface to perform a lockless sum - only expected to
report '0' if the count has been zero for a little while.

I might be able to make do without those, or possibly enhance
percpu-refcount.

I'll have a look - thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlimYSoACgkQOeye3VZi
gbk1VA/8D7ljNPcX3sfoAb2aBjnbFXFb8Kmuxx5eXNFKHC/hb4ixLWi9qu6EDG/J
R876ViLifKS7B0GUp59C8H85uAtS75pxxvBDOXuwvefPXD4j9icEb8vWSpkG89RL
1hKsHOFQhtyh6Nm+SSJeT1LwcNlCXrEZ3uk35pCTcK97Vg13JBja9YPdYj/uyYIX
IldfxqXXBDQqh6ubDZw+mN7G35PE5izwhh+bta/LkhJHU+pCIPyk4XY65jfpyMST
tSs4Wl0vAekEzHW5g4kqP+myI8YJeZvqpHJGf6c3rFP6/++L9Z9Z7/G3+/Ks0UyK
ZlUZdJK21ly5KueYQgFpB5e2WU/1/d4qfojuw+xPLca0rSGHvH2JBI+KOR3F/M9V
Fj1NCUD2USXN+HI/F6r6Ufn8zyzDG/hUy9zWtYkuWO7q3x/js/uJhupktlAOOT9K
AQ1glhffRgro8YV0ByBeppckTWTjft/qc6wh+lxZOIAcvBkAB0AmJRPYxOsx/65P
jVkwoL3Dm9kQ7YdSeeIpisnaQQQ6UXbP6T5nN3mTExElFlkhFTTu3QHCabcsP+2H
tiIBILC+HUsOVwhC9OX0LLGWtRS/872RJVpJMx1Q73XGVRmWl+DdRwxVjzi+OmXe
Z36Enxn4+8Cu0C1ASV16TK+qySyTvvzJ4sy/+A0O4hZmdfcY7gI=
=7Ogm
-----END PGP SIGNATURE-----
--=-=-=--
