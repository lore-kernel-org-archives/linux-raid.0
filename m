From: NeilBrown <neilb@suse.com>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Wed, 17 May 2017 07:11:17 +1000
Message-ID: <87bmqsmrre.fsf@notabene.neil.brown.name>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk> <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk> <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org> <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk> <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no> <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no> <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com> <87bmr14u5f.fsf_-_@esperi.org.uk> <87efvpmqf6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efvpmqf6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Chris Murphy <lists@colorremedies.com>
Cc: David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, May 16 2017, NeilBrown wrote:

> On Tue, May 09 2017, Nix wrote:
>
>> On 9 May 2017, Chris Murphy verbalised:
>>
>>> 1. md reports all data drives and the LBAs for the affected stripe
>>
>> Enough rambling from me. Here's a hilariously untested patch against
>> 4.11 (as in I haven't even booted with it: my systems are kind of in
>> flux right now as I migrate to the md-based server that got me all
>> concerned about this). It compiles! And it's definitely safer than
>> trying a repair, and makes it possible to recover from a real mismatch
>> without losing all your hair in the process, or determine that a
>> mismatch is spurious or irrelevant. And that's enough for me, frankly.
>> This is a very rare problem, one hopes.
>>
>> (It's probably not ideal, because the error is just known to be
>> somewhere in that stripe, not on that sector, which makes determining
>> the affected data somewhat harder. But at least you can figure out what
>> filesystem it's on. :) )
>>
>> 8<------------------------------------------------------------->8
>> From: Nick Alcock <nick.alcock@oracle.com>
>> Subject: [PATCH] md: report sector of stripes with check mismatches
>>
>> This makes it possible, with appropriate filesystem support, for a
>> sysadmin to tell what is affected by the mismatch, and whether
>> it should be ignored (if it's inside a swap partition, for
>> instance).
>>
>> We ratelimit to prevent log flooding: if there are so many
>> mismatches that ratelimiting is necessary, the individual messages
>> are relatively unlikely to be important (either the machine is
>> swapping like crazy or something is very wrong with the disk).
>>
>> Signed-off-by: Nick Alcock <nick.alcock@oracle.com>
>> ---
>>  drivers/md/raid5.c | 16 ++++++++++++----
>>  1 file changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index ed5cd705b985..bcd2e5150e29 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3959,10 +3959,14 @@ static void handle_parity_checks5(struct r5conf =
*conf, struct stripe_head *sh,
>>  			set_bit(STRIPE_INSYNC, &sh->state);
>>  		else {
>>  			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
>> -			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
>> +			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>>  				/* don't try to repair!! */
>>  				set_bit(STRIPE_INSYNC, &sh->state);
>> -			else {
>> +				pr_warn_ratelimited("%s: mismatch around sector "
>> +						    "%llu\n", __func__,
>> +						    (unsigned long long)
>> +						    sh->sector);
>> +			} else {
>
> I think there is no point giving the function name,
> but that you should give the name of the array.
> Also "around" is a little vague.
> Maybe something like:
>
>> +				pr_warn_ratelimited("%s: mismatch sector in range "
>> +						    "%llu-%llu\n", mdname(conf->mddev),
>> +						    (unsigned long long) sh->sector,
>> +						    (unsigned long long) sh->sector + STRIPE_SECTORS);
>
> As an optional enhancement, you could add "will recalculate P/Q" or
> "left unchanged" as appropriate.
>
> Providing at least that the array name is included in the message, I
> support this patch.

Actually, I have another caveat.  I don't think we want these messages
during initial resync, or any resync.  Only during a 'check' or
'repair'.
So add a check for MD_RECOVERY_REQUESTED or maybe for
  sh->sectors >=3D conf->mddev->recovery_cp

NeilBrown


>
> NeilBrown
>
>
>
>>  				sh->check_state =3D check_state_compute_run;
>>  				set_bit(STRIPE_COMPUTE_RUN, &sh->state);
>>  				set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
>> @@ -4111,10 +4115,14 @@ static void handle_parity_checks6(struct r5conf =
*conf, struct stripe_head *sh,
>>  			}
>>  		} else {
>>  			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
>> -			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
>> +			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>>  				/* don't try to repair!! */
>>  				set_bit(STRIPE_INSYNC, &sh->state);
>> -			else {
>> +				pr_warn_ratelimited("%s: mismatch around sector "
>> +						    "%llu\n", __func__,
>> +						    (unsigned long long)
>> +						    sh->sector);
>> +			} else {
>>  				int *target =3D &sh->ops.target;
>>=20=20
>>  				sh->ops.target =3D -1;
>> --=20
>> 2.12.2.212.gea238cf35.dirty
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkbavUACgkQOeye3VZi
gbnWuQ/7BGrpG/fu6ggNZmrSPoxtEwA46z25VkOFUxFuSCXGxZge7x+U0gVKazPv
s8giu98WxhPBDNngFjvI2/3Nfx2qYPTrsFGTPV40iLZpM4v9qYzi22mMsMmXTTBi
HQgymBDRzRRRihO1mr3MGAD4J2YIK4fX3uBwqQsHb1iAe2g3VXAuMOZn1VtXgQdU
Q4zEZpK5sptENxjZ0e6mkkrawBbyHvoU0vxdzZJmbZLTdtonVk2Go8gaG8j3bgNv
2XMfkf22MgmtQGcKgl6+KRLiKFai5RUWbzyUFQkNalkhU3gpSIVOJygtsdRmtv76
I63sBkQ6RF2YyO26AUuInce1yW609a7CDVQXsJYE750ixQ0iZWtrjWA4dlpRCBgJ
3+uisQXBhhdi8XJOWDmDTJLSjhmCOtTo0n1G25pTS2qEKfcdGEPq28o/WuH+o4tA
9lmtXxmtvAHvwIHOAHOWwGEAHSzJbThRGbeQHtGr5m5sAt4yVZADueXu98C6XUPN
jx7k70OH6qu+pt3/TWzOTyFSlPWY+KW+8Zt7MR0trWQXznMxJzKbv8wJjsyD7ZZM
UhBugWrrtsoUfUYE1zp1mb3N/koq06wNnys8E3bbLPlF5x4eUS7cwKjnM7wnoOsT
+Ymq5U06wBtqmowdtaYE/YbAM85R1jomeLESrd0mJsKyPrpWIu0=
=R6n2
-----END PGP SIGNATURE-----
--=-=-=--
