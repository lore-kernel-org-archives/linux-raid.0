From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: HDD reports errors while completing RAID6 array check
Date: Sat, 11 Jun 2011 00:00:00 +0600
Message-ID: <20110611000000.76ca58e7@natsu>
References: <BANLkTik87PZChAzgBnDM170uJHU=3Yc6Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ytUbQ8vIvGp.HF=XAtmdnOk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTik87PZChAzgBnDM170uJHU=3Yc6Eg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ytUbQ8vIvGp.HF=XAtmdnOk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Jun 2011 18:37:06 +0100
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

>   9 Power_On_Hours          0x0032   090   090   000    Old_age
> Always       -       7781


> # 1  Extended offline    Completed without error       00%      6827
> - # 2  Extended offline    Completed without error       00%
> 6550         - # 3  Extended offline    Completed without error
> 00%      6468         - # 4  Extended offline    Completed without
> error       00%      6329         - # 5  Extended offline    Completed
> without error       00%      6040         - # 6  Extended offline
> Completed without error       00%      5584         - # 7  Extended
> offline    Completed without error       00%      5178         - # 8
> Extended offline    Completed without error       00%      4761         -=
 #
> 9  Short offline       Completed without error       00%      2285       =
  -
> #10  Extended offline    Completed without error       00%      1514

I suggest that you do another "smartctl -t long" on it, the latest one was
done almost 1000 hours ago which is also much longer than the period between
previous tests. Freezes on reads could be a symptom of a bad (unreadable, or
very slowly readable - which is worse) sector, perhaps it could be detected=
 by
the SMART test. Or also do a full read of the drive directly (not through t=
he
RAID) e.g. with "badblocks" and see if you get any I/O errors that way.

--=20
With respect,
Roman

--Sig_/ytUbQ8vIvGp.HF=XAtmdnOk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3yW6AACgkQTLKSvz+PZwi/kACdFYyH5e2uH0Y7AZYhWfaBJ9+j
mkkAn2VjKpkCcjuNbNr58DEskyMDKzDx
=ABrf
-----END PGP SIGNATURE-----

--Sig_/ytUbQ8vIvGp.HF=XAtmdnOk--
