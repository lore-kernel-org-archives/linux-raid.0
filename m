From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 05/18] md/raid10: add rcu protection to rdev access in raid10_sync_request.
Date: Fri, 10 Jun 2016 16:46:45 +1000
Message-ID: <87porpmtgq.fsf@notabene.neil.brown.name>
References: <20160602061319.2939.72280.stgit@noble> <20160602061952.2939.98809.stgit@noble> <20160603223315.GC1898@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160603223315.GC1898@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 04 2016, Shaohua Li wrote:

> On Thu, Jun 02, 2016 at 04:19:52PM +1000, Neil Brown wrote:
>> mirrors[].rdev can become NULL at any point unless:
>>   - a counted reference is held
>>   - ->reconfig_mutex is held, or
>>   - rcu_read_lock() is held
>>=20
>> Previously they could not become NULL during a resync/recovery/reshape e=
ither.
>> However when remove_and_add_spares() was added to hot_remove_disk(), that
>> changed.
>>=20
>> So raid10_sync_request didn't previously need to protect rdev access,
>> but now it does.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/raid10.c |  120 +++++++++++++++++++++++++++++++-------------=
-------
>>  1 file changed, 72 insertions(+), 48 deletions(-)
>>=20
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index e6f3a11f8f70..f6f21a253926 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -2871,11 +2871,14 @@ static sector_t raid10_sync_request(struct mddev=
 *mddev, sector_t sector_nr,
>>  				/* Completed a full sync so the replacements
>>  				 * are now fully recovered.
>>  				 */
>> -				for (i =3D 0; i < conf->geo.raid_disks; i++)
>> -					if (conf->mirrors[i].replacement)
>> -						conf->mirrors[i].replacement
>> -							->recovery_offset
>> -							=3D MaxSector;
>> +				rcu_read_lock();
>> +				for (i =3D 0; i < conf->geo.raid_disks; i++) {
>> +					struct md_rdev *rdev =3D
>> +						rcu_dereference(conf->mirrors[i].replacement);
>> +					if (rdev)
>> +						rdev->recovery_offset =3D MaxSector;
>> +				}
>> +				rcu_read_unlock();
>>  			}
>>  			conf->fullsync =3D 0;
>>  		}
>> @@ -2934,14 +2937,17 @@ static sector_t raid10_sync_request(struct mddev=
 *mddev, sector_t sector_nr,
>>  			int must_sync;
>>  			int any_working;
>>  			struct raid10_info *mirror =3D &conf->mirrors[i];
>> +			struct md_rdev *mrdev, *mreplace;
>>=20=20
>> -			if ((mirror->rdev =3D=3D NULL ||
>> -			     test_bit(In_sync, &mirror->rdev->flags))
>> -			    &&
>> -			    (mirror->replacement =3D=3D NULL ||
>> -			     test_bit(Faulty,
>> -				      &mirror->replacement->flags)))
>> +			rcu_read_lock();
>> +			mrdev =3D rcu_dereference(mirror->rdev);
>> +			mreplace =3D rcu_dereference(mirror->replacement);
>> +
>> +			if ((mrdev =3D=3D NULL ||
>> +			     test_bit(In_sync, &mrdev->flags))) {
>> +				rcu_read_unlock();
>>  				continue;
>> +			}
>
> We don't check mreplace here.

As you say ...  I wonder if I thought I was being clever somehow...

I'll resubmit with that fixed but it probably won't be for a couple of
week (I'm actually on leave, but thought I should reply).

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXWmJVAAoJEDnsnt1WYoG5sHcP/0qwL8/Gs+dm20Mt2M/gaFvs
Yp/D5ycuB4Y1chRH53WsKyyyGMvByH8TUG63cQhMXOB13ii4iY8TzlQURp5rtOVC
8QD0y2BNBf10v5gHTpKMY8Rhu4kJrlNSN/2xRVoYtAk6+I4heFH2tlR30qgBQAZ+
yhaemq1/NvdJAfv1QDq0UEWStqXFHc2EaU2NboBrb7YNeJnytWXlsKS03ZgeUmXC
8T9+1EFDwnLqbCp4IOT5Hwn+9QNHyD8AzFqsbh/QJrZy5J6bsggOdw+0rpLywS9L
nWNXvyhnO8q6yGYiQU/PjJd7P2u/2riiM8rzA2gWvfztTwqbJyyozZPCP17h6NmS
LUPvAjaBKUEu2Oxkwr9fKYk4IDf9/0+EUTitaSMu2SeQ/n8cDv+w9B5oDoox+UwV
7/n990UQcoZ8HxZnYQ+m7KAitqQZjEHI5Zm+aM6tFZPDUR4GJ3Xej++l79m3Qg+c
Q4+oUfxviuZ4EBNBgXsvvTDxsIQu+Pez0lYPzERWZrejVt0cwFLt4tgQFhFc2dHC
XbHU8cHgOuHAuCrLunr7me3GTrXWYSFZ6HT08wiYsYFGFJV+GeDo+uS7evYliCle
THX3iI+dKSDb6osIiEyEu4SSRAWkL+r9Pb3Er99Vre/FpfegElO/mskRNBER9Qxc
/j+8NdnJkpzLr5XldU9Z
=dPZI
-----END PGP SIGNATURE-----
--=-=-=--
