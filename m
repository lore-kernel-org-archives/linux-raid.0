From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/3] MD: hold mddev lock for .quiesce in md_do_sync
Date: Wed, 24 Aug 2016 14:49:57 +1000
Message-ID: <87k2f6g496.fsf@notabene.neil.brown.name>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com> <87y44epwb5.fsf@notabene.neil.brown.name> <87y44dnrz2.fsf@notabene.neil.brown.name> <20160806041428.GB9281@kernel.org> <87h9aqluoa.fsf@notabene.neil.brown.name> <20160817012803.GA86961@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160817012803.GA86961@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17 2016, Shaohua Li wrote:
>> >
>> > We will have the same deadlock issue with just stopping/restarting the=
 reclaim
>> > thread. As stopping the thread will wait for the thread, which probabl=
y is
>> > doing r5l_do_reclaim and writting the superblock. Since we are writtin=
g the
>> > superblock, we must hold the reconfig_mutex.
>>=20
>> When you say "writing the superblock" you presumably mean "blocked in
>> r5l_write_super_and_discard_space(), waiting for  MD_CHANGE_PENDING to
>> be cleared" ??
> right
>> With a bit of care you could wait for MD_CHANGE_PENDING to clear, or for
>> ->quiesce to be set, and then exit gracefully.
>
> Can you give details about this please? .quiesce is called with reconfig_=
mutex
> hold, so the MD_CHANGE_PENDING will never get cleared.

raid5_quiesce(mddev, 1) sets conf->quiesce and then calls r5l_quiesce().

r5l_quiesce() tells the reclaim_thread to exit and waits for it to do so.

But the reclaim thread might be in
   r5l_do_reclaim() -> r5l_write_super_and_discard_space()
waiting for MD_CHANGE_PENDING to clear.  That will only get cleared when
the main thread can get the reconfig_mutex, which the thread calling
raid5_quiesce() might hold.  So we get a deadlock.

My suggestion is to change r5l_write_super_and_discard_space() so that
it waits for *either* MD_CHANGE_PENDING to be clear, or conf->quiesce
to be set.  That will avoid the deadlock.

Whatever thread called raid5_quiesce() will now be in control of the
array without any async IO going on.  If it needs the metadata to be
sync, it can do that itself.  If not, then it doesn't really matter that
r5l_write_super_and_discard_space() didn't wait.

r5l_write_super_and_discard_space() shouldn't call discard if the
superblock write didn't complete, and probably r5l_do_reclaim()
shouldn't update last_checkpoint and last_cp_seq in that case.
This is what I mean by "with a bit of care" and "exit gracefully".
Maybe I should have said "abort cleanly".  The goal is to get the thread
to exit.  It doesn't need to complete what it was doing, it just needs
to make sure that it leaves things in a tidy state so that when it
starts up again, it can pick up where it left off.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXvSd1AAoJEDnsnt1WYoG5ulkQAJWEd68Xt0ka2qW0d5/h7DQY
FdPw922SGxn21iCrJN1VgyiyPwUq0NAd4AoR9XQcIScef8mSgsN0sh8kdO82HEGd
1wdjmTv+tPrH/fK5R8BxeXcOflWyrz+qudiA2vG/7/VK+MpAoq7EFkKoDdPIWxqQ
8VsbvmSv0Eb7fKoZUvuwQQWJKKXhtn2pNuOvLArPd4wetDBgKwcFSIYRoD7KYHiC
zRprDPLGMqQple1soRIOdpEDvPaU+IqICDLPO981VdyXekArbGC8VOty2knWPrOY
YpnPhQNLWM8riDk4q81a5Jt9ewfQQ9h378Bkv4PigdbpXhy82xGg31Kt3Lpfv72D
12rUXO+QjeeM+bEJbTeBY7lwVh0rlPThS032p5a7Q4l7+gt5rKce/elNG9k5IJ6N
DzJsQgfrlo+kPG0yGWyzmWqyLvhMDTgCCnLg+NUUZNYHiyC6/oH1gLL7StjcpB3H
QgGWZ1OkmC2m27RXWHN6lQk43FAIx+iH/p5++eLnAmYwf9wOy512WPNoF+ajqNA4
i7ykgyb6pbVF9rIm9l+qOg4GX8bwyqOV5bnfoEmrqzSvIa35rNdZLeN5KZVlYj5H
hV+aS+0PpiiwrJOOM1qP5iCTOsnZlpwz8y+dg1jynRW/JYMxH9a03Ip3aZaBta3e
7GtLvsncxmYV0rU7ygWW
=rX7R
-----END PGP SIGNATURE-----
--=-=-=--
