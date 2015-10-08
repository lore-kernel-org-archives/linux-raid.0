From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/6] md: don't export log device
Date: Thu, 08 Oct 2015 17:04:54 +1100
Message-ID: <8737xl7v5l.fsf@notabene.neil.brown.name>
References: <cover.1443973492.git.shli@fb.com> <7aecea0895b46e28c2b8a876a83da10d7f30d7f1.1443973492.git.shli@fb.com> <87pp0q6s1i.fsf@notabene.neil.brown.name> <20151008031644.GA3063621@devbig084.prn1.facebook.com> <87bnca6lli.fsf@notabene.neil.brown.name> <20151008043121.GA3189627@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151008043121.GA3189627@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> On Thu, Oct 08, 2015 at 03:16:41PM +1100, Neil Brown wrote:
>> Shaohua Li <shli@fb.com> writes:
>> >>=20
>> >> Neither of these chunks should be needed.
>> >> ->raid_disk of an active devices is only set to -1 if ->hot_remove_di=
sk
>> >> succeeds.
>> >> You have make ->hot_remove_disk fail for Journal devices, so ->raid_d=
isk
>> >> will be >=3D 0.
>> >
>> > I agree the raid5_remove_disk part is superficial, I fixed in an updat=
ed
>> > patch. I still didn't get the point what can prevent a journal disk is
>> > removed. Currently the raid_disk is always -1 for journal disk. If it
>> > should be >=3D0, what value it should be? We give journal disk a speci=
al
>> > role '0xfffd' currently.
>>=20
>> Oh, are we leaving the ->raid_disk at -1 for the journal?  I hadn't
>> noticed that.  I don't feel comfortable it.  Too much code assumes that
>> <0 means "not in use".
>>=20
>> Probably set it to 0, and add a check to setup_conf(), and adjust the
>> check in run().  md_update_sb() probably need to be careful of journals
>> too (to not change ->recovery_offset).
>> I wonder what 'slot_show' should report for the journal.... maybe
>> "journal"??
>
> ->raid_disk >=3D 0 is for normal raid disks. If we use it, we will have
> two disks with ->raid_disk 0, it sounds weird. Currently we add the
> 'test(Journal, rdev->flags)' check in different places to destinguish
> journal disk. We will need to audit the code which assumes ' < 0 means
> not in use'. We will probably need to audit the same code if we set
> ->raid_disk 0 for journal. Neither is perfect.

Having two disks with ->raid_disk=3D=3D0 does seem a little weird, but we do
already have that in some cases.
When you have a hot-replace going, both the original and the replacement
have the same ->raid_disk numbers.  They can be distinguished by the
Replacement flag.
I'm suggesting the same (sort of) for journals, and distinguish by the
Journal flag.

I did quick audit and just found setup_conf, run() and md_update_sb().
If you could do an audit to that would be good.  I'd be surprised if you
find many more places where Journal needs to be tested with ->raid_disk.

Thanks,
NeilBrown

>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFgeGAAoJEDnsnt1WYoG5zDQQAIBoE4bA5L2osKyHX6sUAIPr
YbbDxoei0wagQuWOPJ8YxftnYH9SYhp0atrI5ORDR/EhLCiFHu3bqwxNtEMohWdW
PcSQ35eX26EVzKgmtvaVTjbr+Us8q5nF4CttflpMA4KbaAJTw2kgwvIx5+XCzbO0
hgKQbDj54jVsiatx1NLswHfdLmihJvz9Op/1ShPj7rNTQdHA+Cu/MdjHJo9DpKtN
VnUb37VjZUBykGmOZmC+W61+DE1svfoJPYYyraXVl1SwuLD360n+BZaas9Oh/ERU
biA2FX9SOJbHPI+sK8drdOPkclLlMnDLkl0jOQPsjCr3bnwsbP15hFHl/2/lATTz
mPtcR6OF9L6kGo+H8hTU6CHaIC6gv9H86c5jaN0q0d1eCJqWQQzyPEGN3A2/x+TP
yN017/46TDy8kSOAYk8bqmhV/pEFd4ql0H/4trYe4EKZNwkpejHqTAbOsqI/RntJ
K6cZc9Tm2JWji3a8LfRtZhKDnffUph07h0LWMMayI8bfYNAxnnF3hD11nJP/Eu51
hLQEY4hsGTFSMbrUD2dZ4AVedAaSd1TS7UfkQiASscIr40QuovEpfd/E2E1NrkJf
EpzAYwbdFOUctBivQ8RBfDke7LxI5p3moZl7EkfzyWKA5bUZDp/Ggoi/Lvb2VXaV
B5Eo903xLV9Gcc4qKq6W
=V2va
-----END PGP SIGNATURE-----
--=-=-=--
