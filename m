From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] [mdadm] fix bug in assemble
Date: Wed, 09 Dec 2015 07:38:13 +1100
Message-ID: <87mvtksmkq.fsf@notabene.neil.brown.name>
References: <1449536919-3773378-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449536919-3773378-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 08 2015, Song Liu wrote:

> In Assemble, getinfo_super() over writes journal_clean, to same
> correct journal clean, keep it in "journal_clean_tmp" before
> getinfo_super().

Change "same" to "save" (and a couple of other little improvements).
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  Assemble.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/Assemble.c b/Assemble.c
> index 6b9a6da..0ab5943 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1302,6 +1302,7 @@ int Assemble(struct supertype *st, char *mddev,
>  	int bestcnt =3D 0;
>  	int devcnt;
>  	unsigned int okcnt, sparecnt, rebuilding_cnt, replcnt, journalcnt;
> +	int journal_clean_tmp =3D 0;

Removed "_tmp", it is just noise.


>  	int i;
>  	int was_forced =3D 0;
>  	int most_recent =3D 0;
> @@ -1592,7 +1593,7 @@ try_again:
>  			) {
>  			devices[j].uptodate =3D 1;
>  			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL))
> -				content->journal_clean =3D 1;
> +				journal_clean_tmp =3D 1;  /* store in journal_clean_tmp */

 i++; /* increment i */
!!

I removed the comment.

Applied, thanks,
NeilBrown

>  			if (i < content->array.raid_disks * 2) {
>  				if (devices[j].i.recovery_start =3D=3D MaxSector ||
>  				    (content->reshape_active &&
> @@ -1664,6 +1665,8 @@ try_again:
>  #ifndef MDASSEMBLE
>  	sysfs_init(content, mdfd, NULL);
>  #endif
> +	/* after reload context, store journal_clean in context */
> +	content->journal_clean =3D journal_clean_tmp;
>  	for (i=3D0; i<bestcnt; i++) {
>  		int j =3D best[i];
>  		unsigned int desired_state;
> --=20
> 2.4.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZz+1AAoJEDnsnt1WYoG5XAsQAK/Cc4zZ1e01Yo4kmp/sr2a8
RqFXz8CYuo2obqsrktEvOl5iP4Wg0kn8U+KEKtaVv94gBMhtRLTNWx0KkRDhMsIK
IxN/e71MZtdAW9sobfwARkpy0Z6bDIoaRehTlI/a2gktWdj1nimAaQ9r3LLKTlDE
bISTpKjXCTC3HIE49BQhbbV3RJtfZKzbin3uL2JgUNfM+3T5067bj3PWg6pleFro
6SlXCgrmxkwND0kx1yta3MeOPWUY9fy7k2ptxVwZzid+lbv4FWejfsdqwtX/3SZc
vKXoA4D3oebLSthK+l/u7SiRK92vMApGy4O3iFDL+ywwkiz+HArv60NEdFk695wR
k7rdP98pwn/mU+cDWbEr/Tmh5SdEwjwUiQ7Vg43yK8AcDbkMVU0zC2BWUqLwGYOh
ZpWH0YR6Zq62ZfjmvcldeG0hDItmAjv5RlIwk7XIf5fDyVKvqm3Z+KPex2ryy9Me
D64QJAOGZNHITs/HbQZzlkDyYz2r9dJeGFI6RcORUCBRd302epFJfkVrFFcp33TZ
RhsaKRhM6LcQrCMSJ7/rcZ7lOxlt/j+YATEKoKPtRo/LpC+U+UuDn1XsbVHoog/T
x9GBWn2F7BpN74KlWJ0jtr3kz6OLDhVEkx+oI1UK0cs/n/RPaOgVWW7kBjeMw4/V
W9BTjiTW9xsok5oeBRm6
=wp2+
-----END PGP SIGNATURE-----
--=-=-=--
