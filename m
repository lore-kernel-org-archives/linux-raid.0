From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix recommended test command
Date: Mon, 19 Nov 2012 10:03:18 +1100
Message-ID: <20121119100318.3b54abda@notabene.brown>
References: <1353155873-28770-1-git-send-email-g.esp@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uEaYdRx08BDS_LoEXXL8xLQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353155873-28770-1-git-send-email-g.esp@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Gilles Espinasse <g.esp@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/uEaYdRx08BDS_LoEXXL8xLQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 17 Nov 2012 13:37:53 +0100 Gilles Espinasse <g.esp@free.fr> wrote:

> Signed-off-by: Gilles Espinasse <g.esp@free.fr>
>=20
> Recommended 'sh ./test' fail with
> LANG=3DC sudo sh ./test
> ./test: line 73: `ctrl-c': not a valid identifier
>=20
> Replace '-' by '_' in the ctrl-c function name fix that.

Thanks.  I already have fixed that .. but I haven't pushed it out yet.  I
should  do that - later today.


> In the same time, update the recommended command to 'bash ./test' to matc=
h the shebang

Maybe should just make it:
   ./test

as it has "#!/bin/bash" at the top.  I might fix that too.

Thanks,
NeilBrown


> ---
>  Makefile |    2 +-
>  test     |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index d99ea2b..94229fa 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -268,7 +268,7 @@ uninstall:
>  	rm -f $(DESTDIR)$(MAN8DIR)/mdadm.8 $(DESTDIR)$(MAN8DIR)/mdmon.8 $(DESTD=
IR)$(MAN4DIR)/md.4 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5 $(DESTDIR)$(BINDIR)/md=
adm
> =20
>  test: mdadm mdmon test_stripe swap_super
> -	@echo "Please run 'sh ./test' as root"
> +	@echo "Please run 'bash ./test' as root"
> =20
>  clean :=20
>  	rm -f mdadm mdmon $(OBJS) $(MON_OBJS) $(STATICOBJS) core *.man \
> diff --git a/test b/test
> index 3f8515f..a3c2a24 100755
> --- a/test
> +++ b/test
> @@ -68,13 +68,13 @@ cleanup() {
>  	done
>  }
> =20
> -ctrl-c() {
> +ctrl_c() {
>  	exitonerror=3D1
>  }
> =20
>  do_setup() {
>    trap cleanup 0 1 3 15
> -  trap ctrl-c 2
> +  trap ctrl_c 2
> =20
>    devlist=3D
>    for d in 0 1 2 3 4 5 6 7 8 9 10 11 12


--Sig_/uEaYdRx08BDS_LoEXXL8xLQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKlpNjnsnt1WYoG5AQJbWhAAjX7fyTUGptx4WIqoa9CMqUfYgg/mPnUL
pu696QbZoiLaEbhrSFpmB2bF9ZUR5mql87i22DcEdj0lyn/9uRfVRKYGVOZoY6sB
D+IOW+JAy6jtsdTWZUFW52ufBTDeQv5vjcHABO/MgbeyDKWY2gC1I3ClYXjKnyGg
bJ9DGbLG9wAkm66ADbW3sZXTQByb4AI+hgsTIzYnRFpkOn0G8NvGngwrrUQaQmpG
HOzivac+YBuCGkbGsqm2u8dt8CEoobhbp/pK+c4glaPs04W/xNy7Yol62IwC0B7s
xrC1Q2cHVh3+xjpIvhqKSyPqexeK5Id8ECbKX/ZnW90nSZDyDr84KZs5wrYMi8rr
bcn3spw4nFB6VFFfONHmpx6Xf+gynIdEgxjk/yCp3z8Qe02d9oOduoPZrsICcdwK
6AN9iKSPeT895R+aCkDBALuX/Xl2CAuV8PaK05wRlRcW3fcjsCtV0MkXlcDNzdmh
hx2FvhlglzNkfIa8SavVA66BiuLHJllxJiwER72os+7ELqq/eHn0IX/d02BSiY2V
Ahw2wbDwzsTH4J7VYnJ3rbtZRIt8B6hJmjMswcTgwAhUlDm53cyc1RuVAcJknMLl
f0NKUsbSDhssB/18tDFk6+yjXBevoyD7bEqE9PUdg7QzDbxnRpMiVb2hEUpRpGru
FimcMp8wvos=
=uR1/
-----END PGP SIGNATURE-----

--Sig_/uEaYdRx08BDS_LoEXXL8xLQ--
