From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCHv2 2/2] super1: check and output faulty dev role
Date: Wed, 22 Mar 2017 06:55:33 +1100
Message-ID: <877f3icslm.fsf@notabene.neil.brown.name>
References: <1490003517-4216-1-git-send-email-gi-oh.kim@profitbricks.com> <1490003517-4216-3-git-send-email-gi-oh.kim@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1490003517-4216-3-git-send-email-gi-oh.kim@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gioh Kim <gi-oh.kim@profitbricks.com>, jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20 2017, Gioh Kim wrote:

> From: Jack Wang <jinpu.wang@profitbricks.com>
>
> Output the real dev role in examine_super1, it will help to
> find problem.
>
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> Reviewed-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> ---
>  super1.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/super1.c b/super1.c
> index f3520ac..c903371 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -501,8 +501,10 @@ static void examine_super1(struct supertype *st, cha=
r *homehost)
>  #endif
>  	printf("   Device Role : ");
>  	role =3D role_from_sb(sb);
> -	if (role >=3D MD_DISK_ROLE_FAULTY)
> -		printf("spare\n");
> +	if (role =3D=3D MD_DISK_ROLE_SPARE)
> +		printf("Spare\n");
> +	else if (role =3D=3D MD_DISK_ROLE_FAULTY)
> +		printf("Faulty\n");
>  	else if (role =3D=3D MD_DISK_ROLE_JOURNAL)
>  		printf("Journal\n");
>  	else if (sb->feature_map & __cpu_to_le32(MD_FEATURE_REPLACEMENT))
> --=20
> 2.5.0

I don't think the distinction between "faulty" and "spare" is really
useful here.  I used to report the difference and it turned out to be
confusing, so we stopped.

This is information stored on some other disk, not the one that is
spare-or-faulty.  All it needs to know if what other devices are
working.  It doesn't need to know about which devices aren't working and
why.
The distinction between 'faulty' and 'spare' is only relevant to the
device itself, and to the array as a whole.

We should probably get rid of the distinction between
MD_DISK_ROLE_FAULTY and MD_DISK_ROLE_SPARE.
Most places that test for it just test >=3D MD_DISK_ROLE_FAULTY.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljRhTUACgkQOeye3VZi
gblnXg/9EcV87uEAxL76OFMpKUWtk0r9q9quRwh9pjfuiIVe8gIMIks9jbQSsYvO
I6sOpan/mSw6vr+ZBLIPf6o/wgONOEOukoS7M/bnuPYJPnw5dCaF/p9Psn2+OH1/
oJOxr2bZBNcSLp+SJq8omRnW2cTpxk8Mrkv5FI43j/0VbAWfO3ZsFoh445mrIV70
7yaJVhn1CoCZH09mg9+OdU1/q5OTRz/4HNtPW1ss7B/7FGZTqF4TIxusKMLT9p49
sm3Fep4nfd7updeki3XKCtJN/CUag8ais5n9S8qrGth9aU1VJXNPfO1peM5JNQSd
rjyc3tjvNdqZXYXSsnaWnFA2pTdnR6zR4cCmGFf/kSAgzZbIc0JAl2CJCBSZiqzQ
q834vk8mP8zL7syg9Klo3o+ylNWaZaKWoLleMN0Vfr88IrHd2Eh1Uku03ZgY3yEt
iuZo9y0VPPTunfWQEvyl7rdh2HqBhzJX506JTEeccZ9f0+883M/rSMjHvdGdD7pp
BgkmilbdxyS3TQB4YHiolxcn9y4Em9Wq3xpo/udtOUcJ4BIzHRxwDkEQGikm1xX/
iLoy4MJMP5MxwlsCWq16n+V4IRoRs4g/kgsn/cd6l9LKGDR/UfL8NDANEPmA9ywZ
zK2EDMR6tIq9cXcZ6yfqFLF9yqf9hEghMPxzHVZzP1z2jLNSeKA=
=TA4S
-----END PGP SIGNATURE-----
--=-=-=--
