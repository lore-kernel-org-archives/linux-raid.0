From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 10/15] md/raid1: stop using bi_phys_segment
Date: Thu, 16 Mar 2017 13:49:57 +1100
Message-ID: <8737eedjfu.fsf@notabene.neil.brown.name>
References: <148954692173.18641.1294690639716682540.stgit@noble> <148954711389.18641.6044680366998154084.stgit@noble> <20170316001355.lyhq7lkyvndsocwo@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316001355.lyhq7lkyvndsocwo@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15 2017, Shaohua Li wrote:

> On Wed, Mar 15, 2017 at 02:05:14PM +1100, Neil Brown wrote:
>> Change to use bio->__bi_remaining to count number of r1bio attached
>> to a bio.
>> See precious raid10 patch for more details.
>>=20
>> Like the raid10.c patch, this fixes a bug as nr_queued and nr_pending
>> used to measure different things, but were being compared.
>>=20
>> This patch fixes another bug in that nr_pending previously did not
>> could write-behind requests, so behind writes could continue while
>> resync was happening.  How that nr_pending counts all r1_bio,
>> the resync cannot commence until the behind writes have completed.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/raid1.c |   87 +++++++++++++--------------------------------=
-------
>>  1 file changed, 22 insertions(+), 65 deletions(-)
>>=20
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 7e509a894f15..e566407b196f 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -246,35 +246,18 @@ static void reschedule_retry(struct r1bio *r1_bio)
>>  static void call_bio_endio(struct r1bio *r1_bio)
>>  {
>>  	struct bio *bio =3D r1_bio->master_bio;
>> -	int done;
>>  	struct r1conf *conf =3D r1_bio->mddev->private;
>>  	sector_t bi_sector =3D bio->bi_iter.bi_sector;
>>=20=20
>> -	if (bio->bi_phys_segments) {
>> -		unsigned long flags;
>> -		spin_lock_irqsave(&conf->device_lock, flags);
>> -		bio->bi_phys_segments--;
>> -		done =3D (bio->bi_phys_segments =3D=3D 0);
>> -		spin_unlock_irqrestore(&conf->device_lock, flags);
>> -		/*
>> -		 * make_request() might be waiting for
>> -		 * bi_phys_segments to decrease
>> -		 */
>> -		wake_up(&conf->wait_barrier);
>> -	} else
>> -		done =3D 1;
>> -
>>  	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>>  		bio->bi_error =3D -EIO;
>>=20=20
>> -	if (done) {
>> -		bio_endio(bio);
>> -		/*
>> -		 * Wake up any possible resync thread that waits for the device
>> -		 * to go idle.
>> -		 */
>> -		allow_barrier(conf, bi_sector);
>> -	}
>> +	bio_endio(bio);
>> +	/*
>> +	 * Wake up any possible resync thread that waits for the device
>> +	 * to go idle.
>> +	 */
>> +	allow_barrier(conf, bi_sector);
>
> I think this one should be r1_bio->sector instead of master_bio->sector,
> because multiple r1_bio could be attached to a master_bio. Maybe not chan=
ge
> anything, because both sector should be in the same barrier unit, but we'd
> better to be consistent.

Yes, I agree.  Both that it won't make a practical difference and that
it should be changed.
I just noticed another little problem with this patch.
The chunk in handle_read_error() should have added inc_pending()
near where it added bio_inc_remaining().

Shall I just resend the individual patch (and the raid5 one?).

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljJ/VUACgkQOeye3VZi
gbnLCA//VvK1lbRMKlvnvyHyH6x8ah6CpEXnHy+2dTM4mK9hNlKpUAALadE9dGQO
Gk0nY+Ii3QImsJVArKZt1M0UQBodYA2RSTZ/5J2wMQWjvbtESDVp4rZelw/HqgrJ
wcajHuDMIHUq0ls3Wu9mFDOu6MAQPkqGdMTZ4Dk2ABJXMbSAxXz0IzcaPQ0yEYHS
Bzqm4fBYLbMm94pYqN6cMTR2jzhLBwOSu69D4irr9SR+wOdRezTmfUyIPPlKDlUB
Wx8vaioTKr6pSP42g+tGA3Tsznq2e5s/88LpJFlBBOJJkIpWf21CZgRez2mgROG3
6Q4r+WFrwxQWmakZqd0tRFl7OENA/6/1jjfdeNINExftNmBf+9aeZtZaSRe/PBge
bmgjmOm5DqaWRWwOGZNPCW5bQ3g5TBHcMQWBvHiV35qNlzZBFYjbLYjjXOo0f6jb
oIraO4n/l+1VNwWyt9loJ1bXGONoiIaQ8hVDHtkAGx7h9bOm/FW3BngWIFTG1+ps
vr2yOr/L3te9FrSFQmXQnlF20PpAYSDJXZ8/unvra4gmPZoiMdT3VieIj2UzGrsk
a321hCCFiaDIjvFVA5DWZoY4Z1CRaXeo+TuLKLq6P2w57Yn+cnwMUQl5L1dv/e3H
WtskIeN4o3YgTUG6exaIFthIB+LJrDQ3ogVHfaOWAY09/n+UsZc=
=ZXrI
-----END PGP SIGNATURE-----
--=-=-=--
