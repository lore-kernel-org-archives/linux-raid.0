From: NeilBrown <neilb@suse.com>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Tue, 16 May 2017 13:27:57 +1000
Message-ID: <87efvpmqf6.fsf@notabene.neil.brown.name>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk> <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk> <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org> <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk> <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no> <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no> <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com> <87bmr14u5f.fsf_-_@esperi.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bmr14u5f.fsf_-_@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Chris Murphy <lists@colorremedies.com>
Cc: David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, May 09 2017, Nix wrote:

> On 9 May 2017, Chris Murphy verbalised:
>
>> 1. md reports all data drives and the LBAs for the affected stripe
>
> Enough rambling from me. Here's a hilariously untested patch against
> 4.11 (as in I haven't even booted with it: my systems are kind of in
> flux right now as I migrate to the md-based server that got me all
> concerned about this). It compiles! And it's definitely safer than
> trying a repair, and makes it possible to recover from a real mismatch
> without losing all your hair in the process, or determine that a
> mismatch is spurious or irrelevant. And that's enough for me, frankly.
> This is a very rare problem, one hopes.
>
> (It's probably not ideal, because the error is just known to be
> somewhere in that stripe, not on that sector, which makes determining
> the affected data somewhat harder. But at least you can figure out what
> filesystem it's on. :) )
>
> 8<------------------------------------------------------------->8
> From: Nick Alcock <nick.alcock@oracle.com>
> Subject: [PATCH] md: report sector of stripes with check mismatches
>
> This makes it possible, with appropriate filesystem support, for a
> sysadmin to tell what is affected by the mismatch, and whether
> it should be ignored (if it's inside a swap partition, for
> instance).
>
> We ratelimit to prevent log flooding: if there are so many
> mismatches that ratelimiting is necessary, the individual messages
> are relatively unlikely to be important (either the machine is
> swapping like crazy or something is very wrong with the disk).
>
> Signed-off-by: Nick Alcock <nick.alcock@oracle.com>
> ---
>  drivers/md/raid5.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ed5cd705b985..bcd2e5150e29 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3959,10 +3959,14 @@ static void handle_parity_checks5(struct r5conf *=
conf, struct stripe_head *sh,
>  			set_bit(STRIPE_INSYNC, &sh->state);
>  		else {
>  			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
> -			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
> +			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>  				/* don't try to repair!! */
>  				set_bit(STRIPE_INSYNC, &sh->state);
> -			else {
> +				pr_warn_ratelimited("%s: mismatch around sector "
> +						    "%llu\n", __func__,
> +						    (unsigned long long)
> +						    sh->sector);
> +			} else {

I think there is no point giving the function name,
but that you should give the name of the array.
Also "around" is a little vague.
Maybe something like:

> +				pr_warn_ratelimited("%s: mismatch sector in range "
> +						    "%llu-%llu\n", mdname(conf->mddev),
> +						    (unsigned long long) sh->sector,
> +						    (unsigned long long) sh->sector + STRIPE_SECTORS);

As an optional enhancement, you could add "will recalculate P/Q" or
"left unchanged" as appropriate.

Providing at least that the array name is included in the message, I
support this patch.

NeilBrown



>  				sh->check_state =3D check_state_compute_run;
>  				set_bit(STRIPE_COMPUTE_RUN, &sh->state);
>  				set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
> @@ -4111,10 +4115,14 @@ static void handle_parity_checks6(struct r5conf *=
conf, struct stripe_head *sh,
>  			}
>  		} else {
>  			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
> -			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
> +			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>  				/* don't try to repair!! */
>  				set_bit(STRIPE_INSYNC, &sh->state);
> -			else {
> +				pr_warn_ratelimited("%s: mismatch around sector "
> +						    "%llu\n", __func__,
> +						    (unsigned long long)
> +						    sh->sector);
> +			} else {
>  				int *target =3D &sh->ops.target;
>=20=20
>  				sh->ops.target =3D -1;
> --=20
> 2.12.2.212.gea238cf35.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkacb0ACgkQOeye3VZi
gblpyg//Y/uI2exfA/X4JzkPPQVSgkH1VI5Uhk7TpWicJCKs2SdbuG8ToaL7GMqH
2UOj8CMOPA1CXHUOtQhqJAu6bGID/HZ4W8TTIX3fKD/4gwdyD2gaYT0UDGaUasmE
teT0v151LGFwXhaOlyuXXOzwmnMuS5RtTeop5F5icN+BaXlK6VMVHMuYuwhnDEmc
mAa95NrIuAhRI9Fyw4gnNcPrTQqtq10tuxOQEPL3yUs5PE7fAB0zg80rS7ruW/dI
wg7IUGNKGhjjtMgjhmjaXJnlKUObQIEv2rfp4qfhTYDagtqsNLM+yUqautp1RTwa
awJWtGiCQUYQHwm6V227vMsgWUhfBM2GCLLHenzi2WJgd6PwTIZZeAhRmfdGA5zt
510XPXZfOcTqTIHwSQcoOLiRJesJS7WpljyJBHjU1fJ51A0ekrYnUD8wX8dATQ62
ifJbvL0QqGomdDHmraYnUmLGIOkMp2SIlWw8z3fLmwnATsAgGR8pvw2nTcuYXyp3
1KmMj8KKh8yUHct6YzcPLhVTBLUEs2/lknClZa/SMZx1uef3d1jkzlH51aB5q7pZ
lbulBV5fpRnqQPUjMPeBrB8usH+eL36nKGZ9N1dTeMPB9mDvA21d+iE3rAsZ0T8T
Mpv59Mn/Tta+fgsohxVNLxX5HhoY2VHt4/M+TRUZEw8nvOgikTY=
=HqGI
-----END PGP SIGNATURE-----
--=-=-=--
