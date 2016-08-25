From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/3] MD: hold mddev lock for .quiesce in md_do_sync
Date: Thu, 25 Aug 2016 14:59:13 +1000
Message-ID: <87bn0hfnq6.fsf@notabene.neil.brown.name>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com> <87y44epwb5.fsf@notabene.neil.brown.name> <87y44dnrz2.fsf@notabene.neil.brown.name> <20160806041428.GB9281@kernel.org> <87h9aqluoa.fsf@notabene.neil.brown.name> <20160817012803.GA86961@kernel.org> <87k2f6g496.fsf@notabene.neil.brown.name> <20160824052512.GA1921@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160824052512.GA1921@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 24 2016, Shaohua Li wrote:

> On Wed, Aug 24, 2016 at 02:49:57PM +1000, Neil Brown wrote:
>> On Wed, Aug 17 2016, Shaohua Li wrote:
>> >> >
>> >> > We will have the same deadlock issue with just stopping/restarting =
the reclaim
>> >> > thread. As stopping the thread will wait for the thread, which prob=
ably is
>> >> > doing r5l_do_reclaim and writting the superblock. Since we are writ=
ting the
>> >> > superblock, we must hold the reconfig_mutex.
>> >>=20
>> >> When you say "writing the superblock" you presumably mean "blocked in
>> >> r5l_write_super_and_discard_space(), waiting for  MD_CHANGE_PENDING to
>> >> be cleared" ??
>> > right
>> >> With a bit of care you could wait for MD_CHANGE_PENDING to clear, or =
for
>> >> ->quiesce to be set, and then exit gracefully.
>> >
>> > Can you give details about this please? .quiesce is called with reconf=
ig_mutex
>> > hold, so the MD_CHANGE_PENDING will never get cleared.
>>=20
>> raid5_quiesce(mddev, 1) sets conf->quiesce and then calls r5l_quiesce().
>>=20
>> r5l_quiesce() tells the reclaim_thread to exit and waits for it to do so.
>>=20
>> But the reclaim thread might be in
>>    r5l_do_reclaim() -> r5l_write_super_and_discard_space()
>> waiting for MD_CHANGE_PENDING to clear.  That will only get cleared when
>> the main thread can get the reconfig_mutex, which the thread calling
>> raid5_quiesce() might hold.  So we get a deadlock.
>>=20
>> My suggestion is to change r5l_write_super_and_discard_space() so that
>> it waits for *either* MD_CHANGE_PENDING to be clear, or conf->quiesce
>> to be set.  That will avoid the deadlock.
>>=20
>> Whatever thread called raid5_quiesce() will now be in control of the
>> array without any async IO going on.  If it needs the metadata to be
>> sync, it can do that itself.  If not, then it doesn't really matter that
>> r5l_write_super_and_discard_space() didn't wait.
>
> I'm afraid waiting conf->quiesce set isn't safe. The reason to wait for
> superblock write isn't because of async IO. discard could zero data, so b=
efore
> we do discard, we must make sure superblock points to correct log tail,
> otherwise recovery will not work. This is the reason we wait for superblo=
ck
> write.
>
>> r5l_write_super_and_discard_space() shouldn't call discard if the
>> superblock write didn't complete, and probably r5l_do_reclaim()
>> shouldn't update last_checkpoint and last_cp_seq in that case.
>> This is what I mean by "with a bit of care" and "exit gracefully".
>> Maybe I should have said "abort cleanly".  The goal is to get the thread
>> to exit.  It doesn't need to complete what it was doing, it just needs
>> to make sure that it leaves things in a tidy state so that when it
>> starts up again, it can pick up where it left off.
>
> Agree, we could ignore discard sometime, which happens occasionally, so i=
mpact
> is little. I tested something like below recently. Assume this is the sol=
ution
> we agree on?

Yes, this definitely looks like it is heading in the right direction.

I thought that

> -		set_mask_bits(&mddev->flags, 0,
> -			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
> -		md_wakeup_thread(mddev->thread);

would still be there in the case that the lock cannot be claimed.

You could even record the ->events value before setting the flags,
and record the range that needs to be discarded.  Next time
r5l_do_reclaim is entered, if ->events has moved on, then it should be
safe to discard the recorded range.  Maybe.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXvnshAAoJEDnsnt1WYoG50lsP/0HLC17moELzN+vPA3mBNqQW
Bw78MxwzotDaLwn65T5/Wkke3hrY5eOluNawePmQlbB7tlMk3o4Zic8qTw0cWhfL
VuKL/b8jzrwTUdOYDgtXZISw7jXgbWGt5I4S8GfNU/hDLMyNI2QmvuSBdtHOAinl
DY3T3yTuA8KYF9c0i/TDpKADhvyl9Ijd484/sV0W0acc13Y68HkeB0tQGCmAKX6u
1uaqD26I0M+C6JlFg2Fe5JcZKM9cRrLrHFHJw/Vq+mCDBmgCPAru+hWOYKAkgc4x
VrxR8FoJdPveS11/U3F5jOb0CiusxDu6YZQerPO2+T+4hOg1m9tFwRFF3ad1V2Zy
++kjpHjymjQRbHTjoTDzgm65qGS65Fp4r5/fslzzFhm1uRqhV9dESbQOcB8U0tWX
PpgV0KcmS+YonjE42ejBB0NMxMlmgwyyvmVhBDLfzAimUz9eFdvGXBtz9N5oGD20
irg/3jeCen+G7b8DHF1XjubAm75aeZcuiErSJmm3OK7K0JXfCGrZ4p7eSBc5/iep
dy27/xZsrxfCbaflXgkvCO8BCBNvL4AGydFYheCbyUchq3PyDNCe4pvYbqgy4mDd
MaHcrlrR6YUAI3ZqvmEW1T/ODXGmJEddsso9UWfUtQjJdCG7rtYY7p4r2ScVMHZX
yyHjZUYlhEAtWM9jv7JC
=NT2l
-----END PGP SIGNATURE-----
--=-=-=--
