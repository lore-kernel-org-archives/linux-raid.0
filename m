From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH/RFC/RFT] md: allow resync to go faster when there is competing IO.
Date: Wed, 27 Jan 2016 10:08:45 +1100
Message-ID: <87mvrs2b2a.fsf@notabene.neil.brown.name>
References: <CAByoP04f6YgzhXn+55iEpg0SrVnK3mUxOuEfp-Hki_mppOBieg@mail.gmail.com> <87si1k2do8.fsf@notabene.neil.brown.name> <20160126225222.GA29409@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160126225222.GA29409@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Chien Lee <chienlee@qnap.com>, linux-raid@vger.kernel.org, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 27 2016, Shaohua Li wrote:

> On Wed, Jan 27, 2016 at 09:12:23AM +1100, Neil Brown wrote:
>> On Tue, Jan 26 2016, Chien Lee wrote:
>>=20
>> > Hello,
>> >
>> > Recently we find a bug about this patch (commit No. is
>> > ac8fa4196d205ac8fff3f8932bddbad4f16e4110 ).
>> >
>> > We know that this patch committed after Linux kernel 4.1.x is intended
>> > to allowing resync to go faster when there is competing IO. However,
>> > we find the performance of random read on syncing Raid6 will come up
>> > with a huge drop in this case. The following is our testing detail.
>> >
>> > The OS what we choose in our test is CentOS Linux release 7.1.1503
>> > (Core) and the kernel image will be replaced for testing. In our
>> > testing result, the 4K random read performance on syncing raid6 in
>> > Kernel 4.2.8 is much lower than in Kernel 3.19.8. In order to find out
>> > the root cause, we try to rollback this patch in Kernel 4.2.8, and we
>> > find the 4K random read performance on syncing Raid6 will be improved
>> > and go back to as what it should be in Kernel 3.19.8.
>> >
>> > Nevertheless, it seems that it will not affect some other read/write
>> > patterns. In our testing result, the 1M sequential read/write, 4K
>> > random write performance in Kernel 4.2.8 is performed almost the same
>> > as in Kernel 3.19.8.
>> >
>> > It seems that although this patch increases the resync speed, the
>> > logic of !is_mddev_idle() cause the sync request wait too short and
>> > reduce the chance for raid5d to handle the random read I/O.
>>=20
>> This has been raised before.
>> Can you please try the patch at the end of=20
>>=20
>>   http://permalink.gmane.org/gmane.linux.raid/51002
>>=20
>> and let me know if it makes any difference.  If it isn't sufficient I
>> will explore further.
>
> I'm curious why we don't calculate the wait time. Say the target resync s=
peed
> is speed_min. The wait time should be:
>
> (currspeed * SYNC_MARK_STEP - speed_min * SYNC_MARK_STEP) / speed_min
> =3D (currspeed / speed_min - 1) * SYNC_MARK_STEP
>
> if SYNC_MARK_STEP is too big and sync speed has drift, we can make it sma=
ller.

What do you hope this would achieve?

If I understand correctly, this might allow the thread to sleep for
longer instead of looping around every 500ms or so.  But we don't really
want to do that.  As soon as filesystem IO pauses, we want resync IO to
go back to full speed.

The "speed_min" isn't really a "target".  It is only a "target" for
those times when there is no filesystem IO.

I'd certainly be happy to discuss alternate approaches to this.  Details
are important through.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWp/x9AAoJEDnsnt1WYoG5nn4P/1bYgnFE/eBDVlWMuDVLepE/
PKb3ZuLmLrQrsE+FY/FpXsLE9v2tqIsH3KDOQflSlPgKhjEXA4cFwrIMD6RPqGww
OnGMJWd8yC/wQt3oIiPTjng/2VGOdAlV7HFXR05MCs7udVQ1KR3PLwyOuM0blKPe
PrHuHHyF+d5qzK7H3F67WlEwbVyz8ZXil7zEYEzGilqHeLV0XBuxfqLO/Uv30NTc
QpdH5wA7opmy1hWTfjMlLvUwb+rHw2DvXtisSggaOfIWsl5ZxshmlMPkE5wE67uI
wiJtL2aTT1O9PPZvy3hFIHsbGVmzMf1fK0sCV5Eby7VSquGxz046jQ0pjS0mBdDK
MKZio6WTCDQawjm68FzPDoFgaEErBeXaD1/s7rHW2YGELT2pQNaR9nuOPDuiGdgr
plDvSAep3y4cF89rxUJtJqUlC+6Y8J7CFuX2cZ6uVLlfUoebxpisvF34uyNrdBad
vNkfNoVFyFS9eNMqxVScj031yWKeMqzTNlGLt0Dmds60b+TT6Nb33OGrwXl3Ekzu
5IQsQ546IRvfR7aBbbudpWEdgbKIi4pBPF43AhXsgCJPI8dG9B/AA2hL8dvZOc5b
AL3tgpWQHNnirwSgWtWVWZH40GZVNEVo+bYIt193WXPsSCuA1E3hRJHrr6rEew3v
ag5iqD8DmhrrxL0fIBYc
=+Kt0
-----END PGP SIGNATURE-----
--=-=-=--
