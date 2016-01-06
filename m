From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/4] raid5-cache: handle flush request for journal hotadd
Date: Wed, 06 Jan 2016 13:07:30 +1100
Message-ID: <87y4c3wjdp.fsf@notabene.neil.brown.name>
References: <cover.1452028077.git.shli@fb.com> <7b8a15be93941a393a5a08232659fef9ead4610b.1452028077.git.shli@fb.com> <87d1tfy0ii.fsf@notabene.neil.brown.name> <20160106014704.GA4056779@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160106014704.GA4056779@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 06 2016, Shaohua Li wrote:

> On Wed, Jan 06, 2016 at 12:12:05PM +1100, NeilBrown wrote:
>> On Wed, Jan 06 2016, Shaohua Li wrote:
>>=20
>> > When we hotadd journal for array which isn't created with journal, the
>> > array might be running write requests. Such writes aren't protected by
>> > journal yet, so we can't skip disk flush. There is no easy way to know
>> > when all such writes are finished, but the time should be enough after
>> > reclaim runs once.
>>=20
>> There is an easy way to know when such writes are finished.
>> Call mddev_suspend(mddev).  This is used for the more intrusive
>> reconfiguration such as initiating a reshape.
>> I think it would be perfectly appropriate to
>>   call mddev_suspend()
>>   attach the journal
>>   call mddev_resume()
>
> hot add/remove disk is called in raid5d, we can't wait IO there.
> mddev_suspend() will wait IO. So we can't call mddev_suspend()

Fair point.  I wonder if it should be though.

Activating a spare is a very different thing to activating a journal.
Activating a spare is just one small step on the way from being degraded
to being optimal.
Activating a spare is a distinct change in how the array behaves, not
unlike adding a bitmap.

So I think that adding a journal should happen a lot like adding a
bitmap.
When you write "journal" to the 'state' file, or call ADD_NEW_DISK with
MD_DISK_JOURNAL set, ->hot_add_disk() should be called directly, a bit
like add_bound_rdev() does when adding a device to a 'linear' array.

Having remove_and_add_spares() add a journal certainly doesn't seem like
a good idea.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjHbiAAoJEDnsnt1WYoG5IW8QALHmzE0XDSHngWCg53bK3Ztc
Fn1yeo8j1O/OV3XpuZX5rM3qtIngfroUjTvNE6mVsvqMCX3YmfX+HwJTFilnnDHr
yyhip1OaEfmwA1HPCs4J60V4hg7miT0m0Ecsbs2vXZ5yYg0Nh9mEJUweZMEgB5vi
NAy/Slzr7gC7SvJLsysTnlOv4m/SJsLKD1eefB6BiNHVBnyQZ6Hfdjymr38UHfVM
qnrQMejdvENljcHqAnSBpkqc93gqcew01/xlQYl4oF4TGIFRuhI1f9dK5M2iotrG
8dvVe4yShz3BPLRPd9xtYq57lMqhS3FieIcfuSm6N375zEWrjUqn6NNu8D9eB4Uh
bFE4GEhFS9OFQ2vMV61K3KyywXIWTdA3459S5MIQ/PNwLGBrDUNtz6tuYt+xdWNu
UeJcqKy3tPrgVj4MX0C/Cp44CyuVSGssgiuVmD7mGWf4a+R2S6jppbpSlOrjuydd
hgnwhC5jDpnFh4Bw9RlkRaU1PaXe6jlaM7ATgLRFzFNy+E4eBs5oWxNyu+vMxMwR
4K/fQU2slOhcxI+vmNelCagr8rNsszZJyE/0jjXNl/gG2adpDV7ZgAj0MT9E24K+
qjG12N0T6vG2STccTqb2vWQyCWulCjeAvJBmfSuL6T7XshrtVHtQa+/QSSfUGjAK
HZqlykZENMMabAnrYd4R
=7A92
-----END PGP SIGNATURE-----
--=-=-=--
