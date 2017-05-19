From: NeilBrown <neilb@suse.com>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Fri, 19 May 2017 14:49:51 +1000
Message-ID: <87h90hlac0.fsf@notabene.neil.brown.name>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk> <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk> <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org> <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk> <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no> <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no> <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com> <87bmr14u5f.fsf_-_@esperi.org.uk> <87efvpmqf6.fsf@notabene.neil.brown.name> <87bmqsmrre.fsf@notabene.neil.brown.name> <871sroscey.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sroscey.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, May 16 2017, Nix wrote:

> On 16 May 2017, NeilBrown spake thusly:
>
>> Actually, I have another caveat.  I don't think we want these messages
>> during initial resync, or any resync.  Only during a 'check' or
>> 'repair'.
>> So add a check for MD_RECOVERY_REQUESTED or maybe for
>>   sh->sectors >= conf->mddev->recovery_cp
>
> I completely agree, but it's already inside MD_RECOVERY_CHECK:
>
> if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>         /* don't try to repair!! */
>         set_bit(STRIPE_INSYNC, &sh->state);
>         pr_warn_ratelimited("%s: mismatch sector in range "
>                             "%llu-%llu\n", mdname(conf->mddev),
>                             (unsigned long long) sh->sector,
>                             (unsigned long long) sh->sector +
>                             STRIPE_SECTORS);
> } else {
>
> Doesn't that already mean that someone has explicitly triggered a check
> action?

Uhmm... yeah.  I lose track of which flags me what exactly.
You log messages aren't generated when 'repair' is used, only when
'check' is.
I can see why you might have chosen that, but I wonder if it is best.

But I'm OK with this patch as it stands.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkeeW8ACgkQOeye3VZi
gblqbw//WjgpF5pF0o5lIRC7WvekhnEPIFQVg0FS3ZCCQjuG4Bp8/TapqVcZWNeJ
8SVOZ5pe4GlWWLBLvynR2xirzrfVSswRCclMxtoRdTm4PlIbEdzTh9MDcNaEQljn
U7CxnUVtrW7//Z1IH+eZc5yfACIkjLiVjAQsDtbUDLlM4yI4Mez8COeFHN4Kd9uo
W0Rs3PKrHo/KOhzR6oWZk4pvcdkKUKKEg3ySAc8VYVmycmE99KQf1fKFGlbAVKrp
hd2azS/Pd9SSYsCBFmKe8RmZI2I5ViiEI/BLT2hCtdUPv5z/r1sPT/AKLfJT7fLQ
lxTkhtWvXeqJj7JpgT5gZxdF1YZfytBkuwf8JoDGd3xNXwJa1sOXGvzFq1wdbDlb
sfLdFT8UQODfCdjr0KOCMxgU5SjU/TDYIKJgPV9mK/cHFYuqKqo1Rb8xuJkGVuAU
u6afjrwwdGQ88f5Th650JJxhXNckDkaZE1zHwxczvNJyMTvq3WBsZv2Rpug7AsBY
53e8nJiKiWm1Sn/1efBVc1hIOb+/ydx55OWtYJdZfpd9jgvp1NwcS73ARl8TgtTj
Yxo3UY0HVwj1EpMrPBqmMZjrGvxhGUArDbHOTma67vagE0ShBJY3Wx42ryPmnfO8
okx/LCk3cB07F8dGHOXCpuIvIMDtDflettNfBaF3Czwac5nQRFI=
=zYhS
-----END PGP SIGNATURE-----
--=-=-=--
