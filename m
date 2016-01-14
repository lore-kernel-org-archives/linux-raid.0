From: NeilBrown <nfbrown@novell.com>
Subject: Re: [PATCH] Define _POSIX_C_SOURCE if undefined
Date: Thu, 14 Jan 2016 11:40:18 +1100
Message-ID: <87mvs96ljh.fsf@notabene.neil.brown.name>
References: <1452671964-35006-1-git-send-email-raj.khem@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1452671964-35006-1-git-send-email-raj.khem@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 13 2016, Khem Raj wrote:

> typecast second argument of connect() API to use struct sockaddr*
>

Hi,
 You have told us what this patch does, but not why anyone should care.
 Just a sentence or two is probably enough.  Are you getting compiler
 warnings (if so, what are they).  Are we violating some standard (which
 one).

 Is there a connection between defining _POSIX_C_SOURCE (as described in
 the subject) and the second argument to connect (as mentioned in the
 comment above) and the second argument to bind (as not mentioned until
 the code).

 Please explain.

Thanks,
NeilBrown


> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---
>  config.c | 3 +++
>  mdmon.c  | 2 +-
>  msg.c    | 2 +-
>  3 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/config.c b/config.c
> index c58c8fe..b308b6c 100644
> --- a/config.c
> +++ b/config.c
> @@ -63,6 +63,9 @@
>   * but may not wrap over lines
>   *
>   */
> +#ifndef _POSIX_C_SOURCE
> +#define _POSIX_C_SOURCE 200809L
> +#endif
>=20=20
>  #ifndef CONFFILE
>  #define CONFFILE "/etc/mdadm.conf"
> diff --git a/mdmon.c b/mdmon.c
> index ee12b7c..e4b73d9 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -235,7 +235,7 @@ static int make_control_sock(char *devname)
>  	addr.sun_family =3D PF_LOCAL;
>  	strcpy(addr.sun_path, path);
>  	umask(077); /* ensure no world write access */
> -	if (bind(sfd, &addr, sizeof(addr)) < 0) {
> +	if (bind(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
>  		close(sfd);
>  		return -1;
>  	}
> diff --git a/msg.c b/msg.c
> index 754630b..45cd450 100644
> --- a/msg.c
> +++ b/msg.c
> @@ -170,7 +170,7 @@ int connect_monitor(char *devname)
>=20=20
>  	addr.sun_family =3D PF_LOCAL;
>  	strcpy(addr.sun_path, path);
> -	if (connect(sfd, &addr, sizeof(addr)) < 0) {
> +	if (connect(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
>  		close(sfd);
>  		return -1;
>  	}
> --=20
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWlu5yAAoJEDnsnt1WYoG5UbgP/1SyEb2owr8skBePfdZ9lpO0
8SA8u8DDbKatT0PFTzIzZBoMVU2Ahker9BAJbwXMd4U9nK/n/K13xnuGX6QPS32g
U/sLZfKRWCGM2IZAKbXrOAjR6DEc8za/WIOQPZMgTLUW2ETsbnruTQU9wU5oGieE
/xUi5+H+i4xBKqCpd1QGttg4yAbnLqBX1l5YOwGpOihJsLxGKJPmoxMSjt4V50Mv
Xe4TdlThUHGc1XFT4H4MaKMn2l0Syfmj2/sQeJvQ6/idam8swIK2Uyg0TigmrjHX
Ib2OBnCN4Eg/bnB8vNTWBcNhjS/XDw4mggrMwvddQoh+qal4vSHvAJmudN3GygES
BC8LK76rGE4/EtynXdGwL0762h1MCdEkEm+EGMzFpAMGr6q6rofZ3BFKPblBWQqb
gzWm/vjtI9UI26n18ABxa2YuCdP6H8wjXUpS9dLuL2O+UAG5A2DxtCXnlUDWrB2V
Rit0Xkxf0JYq+6ORKi+p99zPBaffMT2Pd76a6XnA2auiwXcOg4+72c1t6kUXaQzp
9kUZnLWxMYyfF1Hg7+jQpBT4hQDqjwIQt6Egc6CMZDJhezsRVdEf5tpndDlZg5S7
ZGgwF0xYCYIZAitbw9GegBx7Em/uGq5pztWichP/w+vyzKwGlPdNc+i5TcQ5G1M+
GeXRfAoaW8wOpuXqrlpi
=f6c2
-----END PGP SIGNATURE-----
--=-=-=--
