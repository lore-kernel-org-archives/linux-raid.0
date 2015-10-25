From: Neil Brown <neilb@suse.com>
Subject: Re: performance issue (was: Re: kernel: BUG: soft lockup - CPU#1 stuck for 60s!)
Date: Mon, 26 Oct 2015 05:08:39 +0900
Message-ID: <87a8r6g188.fsf@notabene.neil.brown.name>
References: <1092031595.20151015153830@oudeis.org> <87si5bvcj4.fsf@notabene.neil.brown.name> <43246687.20151024181541@oudeis.org> <20151024213139.5b20dec6@natsu> <16514313.20151025202337@oudeis.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16514313.20151025202337@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer =?utf-8?Q?F=C3=BCgenstein?= <rfu@oudeis.org>, Roman Mamedov <rm@romanrm.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rainer F=C3=BCgenstein <rfu@oudeis.org> writes:

> Hello Roman,
>
> Saturday, October 24, 2015, 6:31:39 PM, you wrote:
>
>> Use a higher bitmap-chunk size, such as 256M or more.
>
> I guess that would be
>
>    mdadm --grow /dev/md0 --bitmap-chunk=3D256M    ??

You would need to remove and then re-add the bitmap.  So:

  mdadm --grow /dev/md0 --bitmap=3Dnone
  mdadm --grow /dev/md0 --bitmap=3Dintermnal --bitmap-chunk=3D256M
=20=20
>
> is  it  wise  to issue this command during a re-sync?

Depending on kernel version, it will either work or it won't.
Either way, it won't cause harm.

>
> a  cron.weekly  job started the re-sync (although I'm pretty sure this
> job has been disabled quite some time ago)

Weekly is a bit more often than I would go for, but why disable it?
Regular scanning for latent bad blocks is fairly important for
reliability.

> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdb1[7] sdf1[3] sdc1[5] sde1[0] sdd1[8]
>       11721061376 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] =
[UUUUU]
>       [=3D=3D>..................]  resync =3D 11.9% (348948608/2930265344=
) finish=3D7771.1min speed=3D5533K/sec
>       bitmap: 8/350 pages [32KB], 4096KB chunk

That isn't a cronjob started resync. That would say "check" rather than
'resync".
This looks a lot like a resync after an unclean restart.  But with the
bitmap that should go faster...
What does "mdadm --examine-bitmap /dev/sdb1" report?

NeilBrown


>
> unused devices: <none>
>
> tnx & cu
>
> --=20
> Best regards,
>  Rainer                            mailto:rfu@oudeis.org
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWLTbIAAoJEDnsnt1WYoG5KekQALz0Z/veDnGddaN2oQwjmdVK
LTW7Jw35mYvYzWm7TcbuIJ9AJL4mWUlMGwfJ5Wd8YmqJlagJf/iy6KgEogts54Tq
VXMIT2ZzXD/ATcD1svi3KjNPXFQis68KrbpVbNyyk9+Uhgo1qTMg8mHHxZ2UB2dJ
mwhlzTxt/vE84FNsTlyt3GYFeIxUZX24kmOBtoJuhUgsIzUDJujVML85fW6ppDve
8rnB6dzYYaCixu2lJ/MCGJx24fWyCPnduzzF2kiTmyT90vn1euZkVA6/d/LT6FKO
SnrPgG2kzhXKkU937tF7iaA29DmDovHZ8Y8zeqfq/RuT0hfLAfS7s/AlaS8de0Yx
o0j9vTGGWGBEpvmMyd2GynqeYVaBCPs507wxuHNYeaITqGKKRipJ/kpk8zuoNxxN
oykqaj2v/spFea9wWIDrT8+6Jvj1PMq7ZegOklPSt8/q4EAxfrxxlffCrTL10ImV
U9130tSE3SGmQC8qnp6J7On2mEPZ8Gs4lcG8H7NaeCdLk9IjFSHnEESJFYP0nEm4
ZBwfucqByAejI/mDlLkVhGIQ5eW7SnRjmF99FGiGQOxVOKWjKNAx7SL3YlPNGPyJ
WCh6MHIt7U4Ysh35o175giLClhorAnzrPQHapffbeN4J52wxR6Mb2ysgxjt9S1t3
wR+g0emWg9UF92VnCcl3
=yUXh
-----END PGP SIGNATURE-----
--=-=-=--
