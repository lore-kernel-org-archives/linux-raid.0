From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 02/14] md/raid5: simplfy delaying of writes while metadata is updated.
Date: Fri, 17 Feb 2017 13:10:48 +1100
Message-ID: <87fujd4lef.fsf@notabene.neil.brown.name>
References: <148721992248.7521.17160361058957519076.stgit@noble> <148721994135.7521.12977218167692514945.stgit@noble> <20170216173757.chtxbvpbzxcqjk62@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170216173757.chtxbvpbzxcqjk62@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 16 2017, Shaohua Li wrote:

> On Thu, Feb 16, 2017 at 03:39:01PM +1100, Neil Brown wrote:
>> If a device fails during a write, we must ensure the failure is
>> recorded in the metadata before the completion of the write is
>> acknowleged.
>>=20
>> Commit c3cce6cda162 ("md/raid5: ensure device failure recorded before
>> write request returns.")  added code for this, but it was
>> unnecessarily complicated.  We already had similar functionality for
>> handling updates to the bad-block-list, thanks to Commit de393cdea66c
>> ("md: make it easier to wait for bad blocks to be acknowledged.")
>>=20
>> So revert most of the former commit, and instead avoid collecting
>> completed writes if MD_CHANGE_PENDING is set.  raid5d() will then flush
>> the metadata and retry the stripe_head.
>>=20
>> We check MD_CHANGE_PENDING *after* analyse_stripe() as it could be set
>> asynchronously.  After analyse_stripe(), we have collected stable data
>> about the state of devices, which will be used to make decisions.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/raid5.c |   27 ++++-----------------------
>>  drivers/md/raid5.h |    3 ---
>>  2 files changed, 4 insertions(+), 26 deletions(-)
>>=20
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 760b726943c9..154593e0afbe 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -4492,7 +4492,8 @@ static void handle_stripe(struct stripe_head *sh)
>>  	if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
>>  		goto finish;
>>=20=20
>> -	if (s.handle_bad_blocks) {
>> +	if (s.handle_bad_blocks ||
>> +	    test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
>>  		set_bit(STRIPE_HANDLE, &sh->state);
>>  		goto finish;
>>  	}
>
> This part is fragile. We don't delay it and post it to handle list again.=
 So
> the raid5d/worker could run this stripe infinitely.
>

Ah yes - I forget about the worker threads.

I think we need to get raid5_do_work() to block while MD_CHANGE_PENDING
is set.
I'll look over the interactions there and see if that really make sense.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlimW6gACgkQOeye3VZi
gbmGoxAAwAePrf0ouqn8wQIbBHmW5ON5rsBg+bwD+BB9/eeoZcJbciF4+5ovSc+p
4RV3Ttkw6dBEalAODdz4mfWuSDs8iplEgdl5ACONKSZCeQFSix3jxsua4pMU8+HP
SdIJEbkCIML6dKM3BifHyuHnc3f9/iTBdLML+IaGR0lIePt7PQT1spVzarSTIQrJ
wB0XfXfjPcfJLA/tAcPxvIzzd3CfJJH1rK98iFPvk2IFDVKWyyZDosfMxcDzZHuy
yGWtlJSbNvEHJe01r+eRsSvZnFrpLuagrCsmIeOE5QTJaWT5jF7ehjkoO64VPzYM
NOn6T+x2wWEepdzpLXG2/i4lk+LE4T54WRM2bZ+UvCPbSVNX64rQycxvS1RnzzI5
grfX7SAJUiuy9A+U9R7j/p4nM9OSN0RIdepNCukFJ+h0ttkyjd9pvHRAf6tcDjeq
gvwEE5GmX+A8nVM9s9vAmiolMAlz1kNmDyO9JkLWPH4WjQw/GBdh7dWZcdQQwnK7
iVkCuDw6tiQb6PRKIXS7FMwTk8LqJqQ7IMif3b9FdBhced2JXOjzm7bdFaEnSERy
p0JviPSJ5mR1kT/aD3Qk+McLrqR/jSqT8Y2I3HzjA8oFiZ0vHQ2Oup7s84ZZu3/E
r0uC38xuHuQ3obYmkQG1TXqKvYF0NF+mRG8FXe/mlHW28Risi0Y=
=QZqK
-----END PGP SIGNATURE-----
--=-=-=--
