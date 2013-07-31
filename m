From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] tests/env-ddf-template: helper for new unit test
Date: Wed, 31 Jul 2013 16:49:27 +1000
Message-ID: <20130731164927.0b1a4181@notabene.brown>
References: <1375219114-5626-11-git-send-email-mwilck@arcor.de>
	<1375248992-7130-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WSMSe.AUP6K2_H4U.fSWJZX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375248992-7130-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WSMSe.AUP6K2_H4U.fSWJZX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Jul 2013 07:36:32 +0200 mwilck@arcor.de wrote:

> From: Martin Wilck <mwilck@arcor.de>
>=20
> I forgot to check in this helper script, similar to the one for IMSM.
> It is needed by tests/10ddf-create-fail-rebuild.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  tests/env-ddf-template |   76 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 76 insertions(+), 0 deletions(-)
>  create mode 100644 tests/env-ddf-template
>=20
> diff --git a/tests/env-ddf-template b/tests/env-ddf-template
> new file mode 100644
> index 0000000..28e19d0
> --- /dev/null
> +++ b/tests/env-ddf-template
> @@ -0,0 +1,76 @@
> +ddf_check() {
> +    udevadm settle
> +    case $1 in
> +    container )
> +        grep -s "blocks super external:ddf" /proc/mdstat > /dev/null || {
> +            echo >&2 "**Fatal** Correctly formed container not found"; c=
at /proc/mdstat; exit 1; }
> +        ;;
> +    member )
> +        t_member=3D$2
> +        t_num_disks=3D$3
> +        t_level=3D$4
> +        t_rd_size=3D$5
> +        t_size=3D$6
> +        t_offset=3D$7
> +        t_chunk=3D$8
> +	t_layout=3D$9
> +=09
> +	if [ $t_chunk -ne 0 ]; then
> +	    t_rd_size=3D$((t_rd_size & ~(t_chunk - 1)))
> +        fi
> +	case $t_level in
> +	0) t_size=3D$((t_num_disks*$t_rd_size));;
> +	1) t_size=3D$t_rd_size;;
> +	4|5) t_size=3D$(((t_num_disks-1)*$t_rd_size));;
> +	6) t_size=3D$(((t_num_disks-2)*$t_rd_size));;
> +	10) t_size=3D$((t_num_disks*$t_rd_size/t_layout));;
> +	esac
> +
> +        err=3D0
> +
> +        eval `stat -L -c "let major=3D0x%t; let minor=3D0x%T;" $t_member`
> +        sysfs=3D/sys/dev/block/${major}:${minor}
> +        if [ ! -f ${sysfs}/md/array_state ]; then
> +            echo "**Fatal**: Array member $t_member not found" >&2; cat =
/proc/mdstat >&2; exit 1
> +        fi
> +        _chunk=3D`cat ${sysfs}/md/chunk_size`
> +        if [ $t_chunk -ne $((_chunk/1024)) ]; then
> +            echo "**Error**: Chunk size mismatch - expected $t_chunk, ac=
tual $_chunk" >&2
> +            err=3D$((err + 1))
> +        fi
> +        for i in `seq 0 $((t_num_disks - 1))`; do
> +	    _offset=3D`cat ${sysfs}/md/rd${i}/offset`
> +	    if [ $t_offset -ne $((_offset / 2)) ]; then
> +		echo "**Error**: Offset mismatch - expected $t_offset, actual $((_offs=
et/2))" >&2
> +		err=3D$((err + 1))
> +	    fi
> +	    _rd_size=3D`cat ${sysfs}/md/rd${i}/size`
> +	    if [ $t_rd_size -ne $_rd_size ]; then
> +		echo "**Error**: Component size mismatch - expected $t_rd_size, actual=
 $_rd_size" >&2
> +		err=3D$((err + 1))
> +	    fi
> +        done
> +        _size=3D`cat ${sysfs}/md/array_size`
> +	[ o$_size =3D odefault ] && _size=3D$(($(cat ${sysfs}/size)/2))
> +        if [ $t_size -ne $_size ]; then
> +            echo "**Error**: Array size mismatch - expected $t_size, act=
ual $_size" >&2
> +            err=3D$((err + 1))
> +        fi
> +        if [ $err -gt 0 ]; then
> +            echo "$t_member failed check" >&2
> +            cat /proc/mdstat >&2
> +            mdadm -E /dev/loop8 >&2
> +            exit 1
> +        fi
> +        ;;
> +    * )
> +        echo >&2 "**Error** unknown check $1"; exit 1;
> +    esac
> +}
> +
> +container=3D/dev/md/ddf
> +member0=3D/dev/md/vol0
> +member1=3D/dev/md/vol1
> +member2=3D/dev/md/vol2
> +member3=3D/dev/md/vol3
> +member4=3D/dev/md/vol4


applied, thanks.

NeilBrown

--Sig_/WSMSe.AUP6K2_H4U.fSWJZX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfizdznsnt1WYoG5AQKzCw//S7+eC/Myy/HErDE06v5SegngA+LQFEHx
659QAVJ/h+JOKSKG2F6I2q942mfiLZA1hmZSNQcgNksXSg1hy7ag2ku4TAqU0Jkv
eYyz3QVgWjpqjbVata7+UHh3AFZW3rRm3WQT7Rqp0KULLYa/WbvQdIudk47b4/ih
68989d7EuVc5jnDjC4OY6RKGwenKf+KUIrbrCSyf+NugDXFt02/nsXfiG5EDQASP
mA23+tKuAJMdLo6xez3pbccgJqJZZITSXVIsRTrjyQpjQcfL+1A4J4XqjsGLf4hp
AeX60aNVJS9+sZl6HY9Jmu64bu8BOXz7KWP390AF2DJunfeRPesEYMwDB4fiYVbA
E4Jds6x28pZzBXh6jgLwmJh4xCITrB+cOs3aGqiySsSZU7GYriW798lmcciz5zqO
BKqBJiyF4iPaatCYBdZwtusIivHfywQLcIgshLG+Dz7exV/oQjcSr1ggKuiDGO4v
b8l78+mfdMGKHR9A6GuKSP7OSmkAUCI8J8Cic2qQKa+BwxF6p2RRiEDgarnxsdpX
HZdOw/bUypyPkK4cqkdiB0yFmzW6MwXXiauajVmeYWBIS7zOuw8lZo5InwKcSN03
nF06X2ma92D6mz0yNY1D9W1ZPwZZfPpzqoLYzlcPShagd64jpCD01wrvbmmm4bEg
vccVM08yYLU=
=PxJt
-----END PGP SIGNATURE-----

--Sig_/WSMSe.AUP6K2_H4U.fSWJZX--
