From: Neil Brown <neilb@suse.de>
Subject: Re: Bad raid0 bio too large problem
Date: Thu, 24 Sep 2015 12:53:06 +1000
Message-ID: <87io70wmst.fsf@notabene.neil.brown.name>
References: <wrfjoagucvyq.fsf@redhat.com> <87k2rhyiqe.fsf@notabene.neil.brown.name> <wrfjvbb12xl8.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjvbb12xl8.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, yizhan@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Neil Brown <neilb@suse.de> writes:
>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>
>>> Hi Neil,
>>>
>>> I think we have some bad side effects with this patch:
>>>
>>> commit 199dc6ed5179251fa6158a461499c24bdd99c836
>>> Author: NeilBrown <neilb@suse.com>
>>> Date:   Mon Aug 3 13:11:47 2015 +1000
>>>
>>>     md/raid0: update queue parameter in a safer location.
>>>=20=20=20=20=20
>>>     When a (e.g.) RAID5 array is reshaped to RAID0, the updating
>>>     of queue parameters (e.g. max number of sectors per bio) is
>>>     done in the wrong place.
>>>     It should be part of ->run, but it is actually part of ->takeover.
>>>     This means it happens before level_store() calls:
>>>=20=20=20=20=20
>>>         blk_set_stacking_limits(&mddev->queue->limits);
>>>=20=20=20=20=20
>>> Running the '03r0assem' test suite fills my kernel log with output like
>>> below. Yi Zhang also had issues where writes failed too.
>>>
>>> robably something we need to resolve for 4.2-final or revert the
>>> offending patch.
>>>
>>> Cheers,
>>> Jes
>>>
>>> md: bind<loop0>
>>> md: bind<loop1>
>>> md: bind<loop2>
>>> md/raid0:md2: md_size is 116736 sectors.
>>> md: RAID0 configuration for md2 - 1 zone
>>> md: zone0=3D[loop0/loop1/loop2]
>>>       zone-offset=3D         0KB, device-offset=3D         0KB, size=3D=
     58368KB
>>>
>>> md2: detected capacity change from 0 to 59768832
>>> bio too big device loop0 (296 > 255)
>>> bio too big device loop0 (272 > 255)
>>
>> 1/ Why do you blame that particular patch?
>>
>> 2/ Where is that error message coming from?  I cannot find "bio too big"
>>   in the kernel (except in a comment).
>>   Commit: 54efd50bfd87 ("block: make generic_make_request handle
>> arbitrarily sized bios")
>>   removed the only instance of the error message that I know of.
>>
>> Which kernel exactly are you testing?
>
> I blame it because of bisect - I revert that patch and the issue goes
> away.
>
> I checked out 199dc6ed5179251fa6158a461499c24bdd99c836 in Linus' tree,
> see the bio too large. I revert it and it goes away.

Well that's pretty convincing - thanks.
And as you say - it is tagged for -stable so really needs to be fixed.

Stares at the code again.  And again.

Ahhh.  that patch moved the
  blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
to after
 disk_stack_limits(...);

That is wrong.

Could you confirm that this fixes your test?

Thanks,
NeilBrown

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 4a13c3cb940b..0875e5e7e09a 100644
=2D-- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -431,12 +431,6 @@ static int raid0_run(struct mddev *mddev)
 		struct md_rdev *rdev;
 		bool discard_supported =3D false;
=20
=2D		rdev_for_each(rdev, mddev) {
=2D			disk_stack_limits(mddev->gendisk, rdev->bdev,
=2D					  rdev->data_offset << 9);
=2D			if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
=2D				discard_supported =3D true;
=2D		}
 		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
@@ -445,6 +439,12 @@ static int raid0_run(struct mddev *mddev)
 		blk_queue_io_opt(mddev->queue,
 				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
=20
+		rdev_for_each(rdev, mddev) {
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset << 9);
+			if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+				discard_supported =3D true;
+		}
 		if (!discard_supported)
 			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 		else

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWA2WSAAoJEDnsnt1WYoG5HJwP/jsaMwZ13BvGvOjGTKOahCCw
9kkVPBWlit/7EjixxT5DdSU9KzbHTI/4FB92r5hShFBNFfFwMCo+HaGemuaOkD/X
g+aMRUa9FTvpj9uozi4qBrXQ99WGMwTUlpWJXzl37myLXEXC3ixXhAJmm/dPHsCM
1wKkS5hw4ow3ahnFq8SsvFTrWIKZvQERPAa5/e6jzMHErA0sysf5YA2dKxtdKsAs
uyil7+Ftp6twXPYmLm1P+o+ObNze5dBAnB452f3Z0jv/xKUif4r45ES/a5dHX5pE
eeuR+ne8bhOV/VEtxp1/2tst8XMY89/cRrsGNd1LJ6xr6jipjqkgNCw6TrpFFYtT
OD3zCCOx04UgcIuzrzAyfBhR6CemnFllb7cQvdydUS1uoc+39AquTs2EEGS68UOu
nYvAPkVVgcqO016023+u7S8/iXml9+JwJ/acFp3QwpLe1/Y1ZSJDgB6UXNqDtb3o
Z/+Ry4KUg+aD61Q3foizUmFv5JttDMsCDlfE34pk4ZbzzNQoJbIIDUrkqKgnICRy
qM0eQeerS8f5jS3EXt12emP3+3+wBlJ1Ong8wTXoAQ5TgXg841/lYv/Nca4T0oMX
34tiw2TfHllAMas0VhWRnxeamY2EzWS1B8e3BM0ZZYvC3efUJyKGaBUqlF1lAVVb
H+I3Sjxduj6jnkcFwtWI
=+SKa
-----END PGP SIGNATURE-----
--=-=-=--
