From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/bitmap: don't read page from device with Bitmap_sync
Date: Tue, 20 Jun 2017 13:59:45 +1000
Message-ID: <87o9tj2tse.fsf@notabene.neil.brown.name>
References: <20170616091927.12959-1-gqjiang@suse.com> <20170616173613.c2cp6qt2hmoebgct@kernel.org> <87h8zc51t0.fsf@notabene.neil.brown.name> <20170620004158.lrry5ig5epvmcqfc@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170620004158.lrry5ig5epvmcqfc@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 19 2017, Shaohua Li wrote:

> On Mon, Jun 19, 2017 at 09:11:23AM +1000, Neil Brown wrote:
>> On Fri, Jun 16 2017, Shaohua Li wrote:
>>=20
>> > On Fri, Jun 16, 2017 at 05:19:27PM +0800, Guoqing Jiang wrote:
>> >> The device owns Bitmap_sync flag needs recovery
>> >> to become in sync, and read page from this type
>> >> device could get stale status.
>> >>=20
>> >> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> >> ---
>> >> When develop for clustered raid10 feature, if add a
>> >> disk under grow mode in master node, I could get
>> >> the "bitmap superblock UUID mismatch" warning due
>> >> to the page is read from Bitmap_sync device.
>> >>=20
>> >>  drivers/md/bitmap.c | 3 ++-
>> >>  1 file changed, 2 insertions(+), 1 deletion(-)
>> >>=20
>> >> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
>> >> index bf7419a..bf34cd8 100644
>> >> --- a/drivers/md/bitmap.c
>> >> +++ b/drivers/md/bitmap.c
>> >> @@ -156,7 +156,8 @@ static int read_sb_page(struct mddev *mddev, loff=
_t offset,
>> >>=20=20
>> >>  	rdev_for_each(rdev, mddev) {
>> >>  		if (! test_bit(In_sync, &rdev->flags)
>> >
>> > Why In_sync is set for the rdev? I think it shoudn't.
>>=20
>> There are several states a device can be in.
>> If ->raid_disk is < 0, then the device is a spare, and doesn't contain
>>     and valid data.
>> Otherwise ->raid_disk >=3D0 and:
>>    In_sync is clear, which means that blocks before ->recovery_offset
>>        contain valid data, and blocks after there don't
>>    In_sync is set, which means ->recovery_offset is irrelevant and
>>        should be treated as MaxSector
>>    Bitmap_sync is set, which could apply in either of the above cases,
>>        and means blocks corresponding to bits that are set in the bitmap
>>        may not be up to date.
>>=20
>> Bitmap_sync is only relevant before a device has been handed to the
>> personality.  After it has been added, ->recovery_cp ensures that the
>> blocks that might be wrong are not read until until the bitmap-based
>> recovery has fixed them up.
>>=20
>> Bitmap_sync is only use to stop the device from being given to the
>> personality if a recovery won't be started because the array is
>> read-only.
>>=20
>> So it is perfectly valid for both In_sync and Bitmap_sync to be set.
>> If they are, it makes sense to avoid reading bitmap information from the
>> Bitmap_sync device, as that will be out-of-date.
>>=20
>> I'm not quite sure why Guoqing is getting a UUID mismatch ... it
>> suggests that the new device wasn't initialized properly.  So there
>> might be another bug.  But I think this is definitely a bug.
>
> Can you describe a scenario a disk has both bits set? I had hard time to
> imagine it.

An array with a bitmap has a device fail (cable break?).
So the bitmap stops clearing bits and ->events_cleared stays
where it was, with the same value as events in the superblock
of the failed device.

The device then starts working (cable is replaced) and
it device is added back to the array.
super_1_validate notices that the array has a bitmap and that the event
count in the new device is >=3D mddev->bitmap->events_cleared, but <
mddev->events.
i.e. it is in the range for which a bitmap-based recovery is both
possible and needed.
So it sets Bitmap_sync.
Then it notices that the 'role' in a valid role for the array,
so that role is stored in rdev->saved_raid_disk and, as there is no
MD_FEATURE_RECOVERY_OFFSET, In_sync is set.
A similar sequence can happen in super_90_validate.

>
> md_update_sb will update super and bitmap super at almost the same time. =
It's
> possible we update super but not bitmap super and there is power loss. Is=
 this
> the case we have the both bits set? There seems no mechanism to prevent t=
he
> first disk has older bitmap super than the second disk in this scenario.

This isn't really about the superblock and bitmap on the one device
being in sync or not.
It is the superblock on one (failed) device having a different event
count than the bitmap (on the other devices) that is actively being used
by the array.

>=20=20
>> >
>> >> -		    || test_bit(Faulty, &rdev->flags))
>> >> +		    || test_bit(Faulty, &rdev->flags)
>> >> +		    || test_bit(Bitmap_sync, &rdev->flags))
>> >
>> > I didn't see code clears the Bitmap_sync bit after disk is synced, so =
likely
>> > there is bug in this side.
>>=20
>> There is no need to clear Bitmap_sync.  It stays set until it becomes
>> irrelevant.
>
> Hmm, if we use in this way, we should add comments there to declare this =
bit
> can only be used very early.

Certainly would be appropriate to document that it is only meaningful
before the device has been passed to ->hot_add_disk().

Thanks,
NeilBrown

>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllInbMACgkQOeye3VZi
gbkCPRAAmBOq5KgI5nAQJSpsRtPCcbkDzZZBjXDLxWs4QIhfhKClLp/+CzxzGdf5
0YtwKCaDFyUaJvDdF1CPXLOWEho91+78SrC3UHWdfjpo8msn+cN9AKPIO3IRJq41
JA0aFbHaJiprPV90nq6h3CrLpkH40espAFe4nxUDC9rUnjoamyROKIs25rGoeXF2
v4ScnvzrB49dcyR18f0DV4e1NgOykrNNHf2UAI3/ieMVzREWWFGhx5cBH81oBovT
KZQ+DydlsmmcAhuQJT1htLjB22iZfT9JMDbKAHpL0RJg5hN81t4C+F6NgrwNSfRt
EztmTF+uzSiEjYadUb6VF2KMljozoCnzGV70FmnMLH5J9ri5cHlkK37jLgUxDDga
3O6lSA9G7L6VT042fRCj5NL5w7q+Hgbn+CJKmecVpCo9PbcRPDc/+1gjDtiBQU+l
+FyLyqFjN7AnoE4QYMUsWvSxt/g7nOJyOAtVRUFk3N8O7ARaVvuZUtZVMSzHpxu6
zzlyGsV1amm0Svn72v6YQZyndam1Ev33k36ovzumSjZdJT/POFbE/zfciOw/gWaq
SeRhTjBuRIpB0VhxLF0ZbFBnm/nYSLE9zFhMC4zlfvIXWwlsCbPgrTkR7MLRQo+z
KL4ytZ9e15/MubtOpC42fagMN2op7itknZDOme51BfjRSzpBj08=
=jbI7
-----END PGP SIGNATURE-----
--=-=-=--
