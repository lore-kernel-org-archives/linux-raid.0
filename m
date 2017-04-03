From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v1] mdadm/grow: reshape would be stuck from raid1 to raid5
Date: Mon, 03 Apr 2017 14:36:05 +1000
Message-ID: <87d1cukszu.fsf@notabene.neil.brown.name>
References: <wrfjk27aid6n.fsf@gmail.com> <20170330073808.6176-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170330073808.6176-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 30 2017, Zhilong Liu wrote:

> systemctl doesn't interpret mdadm-grow-continue@.service
> correctly due to the wrong argument provided in [service],
> it should be corrected %I as %i. Otherwise, if the service
> cannot start by systemctl and the reshap progress would be
> stuck all time when grows array from raid1 to raid5.
>
> reproduce steps:
> ./mdadm -CR /dev/md0 -l1 -b internal -n2 /dev/loop[0-1]
> ./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  systemd/mdadm-grow-continue@.service | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-co=
ntinue@.service
> index 5c667d2..882bc0b 100644
> --- a/systemd/mdadm-grow-continue@.service
> +++ b/systemd/mdadm-grow-continue@.service
> @@ -10,7 +10,7 @@ Description=3DManage MD Reshape on /dev/%I
>  DefaultDependencies=3Dno
>=20=20
>  [Service]
> -ExecStart=3DBINDIR/mdadm --grow --continue /dev/%I
> +ExecStart=3DBINDIR/mdadm --grow --continue /dev/%i

Do you know why this makes a difference?  I don't think it should.
man systemd.unit says that "%i" is the "Instance name" while "%I" is the
"Unescaped instance name".

The Instance name here is something like "md0" so there is nothing to
escape.

I would rather not change it unless we know exactly why it is broken,
and I don't find your explanation to be convincing.

NeilBrown


>  StandardInput=3Dnull
>  StandardOutput=3Dnull
>  StandardError=3Dnull
> --=20
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljh0TUACgkQOeye3VZi
gbnrqBAAu/7RKtfZxJWlBewfpaj3O8DS+s7tDa+F3Xrlf1gNe03C33WxTkSSCDfl
QOWXpheZLfRlvJsRydWk2IkQx2i6HBTNztWQBRPHgC/1c/SF9DpfkVsYrKFqKDmN
RO0Xmx8sNhjPt53G76ftiHMZ5z1CDc9QxAGmW+v2ueuT0YB0bRUynGBaJMyN6HNN
YgP/YQwaSlY2yDtbaxpyXNNqnXauoMrkgqFK05EV28tRbDd0+t2lfAIBm/lbt7yB
RvJqHOiEoMvSke/FdsEMMpf4mO1TRlmfXl5RiTbjSXKk5pDAYNmnXxQPGsWdJf2x
jyumJsoB39yjSyAtNQRXCC24hzYlB5hF5AqMJ8byRzcVAv1CNZASj4nH7VbW7a5X
JqcmH19rDrw811/lxd1/rcQVA9BJgQSiBD/4GlZgiDiLjBl4vYMokyOnbc59NfR3
kbIFg5/poLIJrESSktHm4g4siMR9Fjditpim7PLabAgFPcl5DubMxxKpNv4LD3+c
SbKu6b0n4N9EZp/Crmz6METym5JJAr1u6mT7trUZ/ESmdUUB1Z06z8pDdq4w4Mrh
MNiDZpcVr+BjvZWj6pcrWQui5SAS3LxdYCzfz/LFYksJVjgEsgBmYnu4Te8x+Rtn
wqeMj0SmuCdMSoxuITZVsdFdKvG2KkiR9e/tGtijKxY5w79sMGw=
=qTU4
-----END PGP SIGNATURE-----
--=-=-=--
