From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 09/14] md/raid10: stop using bi_phys_segments
Date: Fri, 17 Feb 2017 13:15:21 +1100
Message-ID: <87d1eh4l6u.fsf@notabene.neil.brown.name>
References: <148721992248.7521.17160361058957519076.stgit@noble> <148721994257.7521.2502119977276847128.stgit@noble> <CA+res+SSS4c1nXo8AE14ku2q_3Bb+w-+XuZOK14SHLACWkHzRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+SSS4c1nXo8AE14ku2q_3Bb+w-+XuZOK14SHLACWkHzRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Feb 16 2017, Jack Wang wrote:

> 2017-02-16 5:39 GMT+01:00 NeilBrown <neilb@suse.com>:
>> raid10 currently repurposes bi_phys_segments on each
>> incoming bio to count how many r10bio was used to encode the
>> request.
>>
>> We need to know when the number of attached r10bio reaches
>> zero to:
>> 1/ call bio_endio() when all IO on the bio is finished
>> 2/ decrement ->nr_pending so that resync IO can proceed.
>>
>> Now that the bio has its own __bi_remaining counter, that
>> can be used instead. We can call bio_inc_remaining to
>> increment the counter and call bio_endio() every time an
>> r10bio completes, rather than only when bi_phys_segments
>> reaches zero.
>>
>> This addresses point 1, but not point 2.  bio_endio()
>> doesn't (and cannot) report when the last r10bio has
>> finished, so a different approach is needed.
>>
>> So: instead of counting bios in ->nr_pending, count r10bios.
>> i.e. every time we attach a bio, increment nr_pending.
>> Every time an r10bio completes, decrement nr_pending.
>>
>> Normally we only increment nr_pending after first checking
>> that ->barrier is zero, or some other non-trivial tests and
>> possible waiting.  When attaching multiple r10bios to a bio,
>> we only need the tests and the waiting once.  After the
>> first increment, subsequent increments can happen
>> unconditionally as they are really all part of the one
>> request.
>>
>> So introduce inc_pending() which can be used when we know
>> that nr_pending is already elevated.
>>
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/raid10.c |   76 +++++++++++++++++----------------------------------
>>  1 file changed, 25 insertions(+), 51 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 9258cbe233bb..6b4d8643c574 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -301,27 +301,18 @@ static void reschedule_retry(struct r10bio *r10_bio)
>>  static void raid_end_bio_io(struct r10bio *r10_bio)
>>  {
>>         struct bio *bio = r10_bio->master_bio;
>> -       int done;
>>         struct r10conf *conf = r10_bio->mddev->private;
>>
>> -       if (bio->bi_phys_segments) {
>> -               unsigned long flags;
>> -               spin_lock_irqsave(&conf->device_lock, flags);
>> -               bio->bi_phys_segments--;
>> -               done = (bio->bi_phys_segments == 0);
>> -               spin_unlock_irqrestore(&conf->device_lock, flags);
>> -       } else
>> -               done = 1;
>>         if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
>>                 bio->bi_error = -EIO;
>> -       if (done) {
>> -               bio_endio(bio);
>> -               /*
>> -                * Wake up any possible resync thread that waits for the device
>> -                * to go idle.
>> -                */
>> -               allow_barrier(conf);
>> -       }
>> +
>> +       /*
>> +        * Wake up any possible resync thread that waits for the device
>> +        * to go idle.
>> +        */
>> +       allow_barrier(conf);
>> +       bio_endio(bio);
>> +
>
> Hi Neil,
>
> Why do you switch the order of above 2 lines, is there a reason
> behind, I notice in raid1 you kept the order?

I cannot think why I would have done that.  It doesn't matter what
order they are in, but it does make sense to leave the order unchanged
unless there is a good reason.  I'll put it back.

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlimXLkACgkQOeye3VZi
gbnDkhAArnPy5ACTEKAMvpNfhADDL7aZywqMCTDWZVyzCFuMrXGL6Ps2uwI13F0I
dU2UrLk0j38XXP2Spqtj9KS8a4yAyfYYBwkpPgwlKtCH4GGDZ05hAr/DHt+1w2WZ
QtXr0WHo3jKKXBkdI94fef2sXgw2zZ5IZodb5GRa95qB0ekwqKVjeapYdqmReRFb
3HgSpJFHKo22GXbqPL1Z32kvLrugqRf52/p6z/ZQ0hz4fjORogYF2h+HSM8qqlhF
A7sO5S4MTcYRPiPJITecrvMpzCrPD3I3rlf29bQLtR8ZFYmF8Hbp7DkhWvuX+O4S
ttZemg/lbbZb96PdfDzLhdIbRFwofhBBo8E7rS/HmhBVmXK8iwucVTMFplut39uy
VAKL67bC6Y2EinBV7nYS/bDMSOl7d3nGvVdtQIXvy8HZFiybkucp3x1mzrJL8KBa
STJeSmB2LPVMoUiJs7CDddzt/iftpiD97Rk3j1i8cmNxk+42FBaJbFE8i5EYG26x
GubOQRaU0F4YjWCjA55xDlwoOsFmmbvUbB06thggOjcYmI8+86ERImH2+EaBmD6D
QnH/dFG6H6bFzULOjxbj+Wn4AvumdjMl79wp3KWOU68CZYl+EkKMFmD/8hvK2jGM
S3FOmpaNK6PqbPChQlmITygEgjVmzrl0u/OyR7shzM1IOoa+AOU=
=uvvO
-----END PGP SIGNATURE-----
--=-=-=--
