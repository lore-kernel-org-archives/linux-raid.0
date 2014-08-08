From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Recovery speed is wrong
Date: Fri, 8 Aug 2014 12:21:55 +1000
Message-ID: <20140808122155.306ab784@notabene.brown>
References: <1888683818.19423710.1407418230213.JavaMail.zimbra@redhat.com>
	<1135772294.19428712.1407418661354.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/J+0Gk71/fyIhDq1ihDu0daX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1135772294.19428712.1407418661354.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/J+0Gk71/fyIhDq1ihDu0daX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Aug 2014 09:37:41 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

> Hi all
>=20
>    When we calculate the speed of recovery, the numerator that contains t=
he recovery done sectors.
> It's need to subtract the sectors which don't finish recovery.

Thanks,
I've applied the patch.  However it needed some fixing up first.  If you are
going to be sending more patches, you need to get these details right.

I suggest using "quilt" to create patches.  There are other options, I most=
ly
use 'git' and 'stg' myself, but quilt is easy to get started with:
>=20
>=20
> Signed-off-by: Xiao Ni <xni@redhat.com>
>=20
> diff -urN linux-stable/drivers/md/md.c fix/md.c
> --- linux-stable/drivers/md/md.c 2014-07-30 14:36:37.327535805 +0800
> +++ fix/md.c   2014-08-07 16:07:12.559503942 +0800

This makes it look like the file "fix/md.c" is being patched, which confuses
programs that apply patches (like "git am").
If you really want to do it by hand, then:

  cp drivers/md/md.c drivers/md/md.c.orig
  # edit drivers/md/md.c
  # compile and test
  diff -u drivers/md/md.c.orig drivers/md/md.c > /tmp/diff

and post /tmp/diff.

> @@ -7376,7 +7376,7 @@
>    struct mddev *mddev2;
>    unsigned int currspeed =3D 0,
>        window;
> -  sector_t max_sectors,j, io_sectors;
> +  sector_t max_sectors,j, io_sectors, recovery_done;
>    unsigned long mark[SYNC_MARKS];
>    unsigned long update_time;
>    sector_t mark_cnt[SYNC_MARKS];
 ^^^^

There are spaces here.  They should be 'tabs'.  Probably your mail program
thinks it knows better and is converting spaces to tabs.
If you cannot get it not to do that, then add the patch as an attachment.
I MUCH prefer patches to be inline in the text, not as an attachment, but an
attachment is MUCH better than converting all the tabs to spaces.

> @@ -7652,7 +7652,8 @@
>        */ =20
>       cond_resched();
> =20
> -     currspeed =3D ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
> +     recovery_done =3D io_sectors - atomic_read(&mddev->recovery_active);
> +     currspeed =3D ((unsigned long)recovery_done - mddev->resync_mark_cn=
t)/2
>          /((jiffies-mddev->resync_mark)/HZ +1) +1;

I also kept the inner brackets, so that reads:

> +     currspeed =3D ((unsigned long)(recovery_done - mddev->resync_mark_c=
nt))/2

I think the extra brackets make it clear that it is the difference that nee=
ds
to be cast, not just the first value.  The result is the same, but this very
is (to me) more readable.

Thanks,
NeilBrown


> =20
>       if (currspeed > speed_min(mddev)) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/J+0Gk71/fyIhDq1ihDu0daX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+Q0Qznsnt1WYoG5AQLTmw//c295mbSx/wHdYxfig+wyE7lzMoHeTu5k
WaXYiDetZy26KkYK7cHkg3bVYZ97L1SdYHM52vPidQLetrP9orZFYQcCBXBTsVZu
lrojUEcdzqzFRbwhnCS7t42C6wIiJd6ni6icSI046Jsnc368AgeDSFRiFFOqS3z9
nMJnkcLYWohScMpAkcXDkk0rL3bMsgUOT/8BmhjJDAacPICMZv+K6cORpGoyF/yZ
rJJlgH7bXG+u8YJ+4ks3Snz4guyAy+Bi/c+/V9Hmgy71pdCz6d9Maat4f7ShlgWg
pmSSInaZtgGUGpGrb/3ygvNur0XpDZ2fAykNMjoJpp/LOjXAeNvJbsIV6R7O2CQ5
lpSlgnHCeQU/Kt6RolGhamHOfrWPtySo6jSemF5IS8WwI4Y4Uflq9xpkNK1nRSZI
ZROvwvX86CYxYAguoj1WskK8wqGsI8982uzURUxV5capzHcFpYm8EADX1Na+w2uw
6MQElGprc9wtLlLdkRPgeu0bD6mVtOql9ihT0Ih9WvgSni2764+BneCZ9crpXXve
kWUZ6Vbjrb47EeDgZcIELiPZjmCxOfU8ClDOLTYsxwiJDauMznsY+83nR9aXckVY
AXWUDmIcSlwr//jrOBipmIBrSUgquZfA2COae6/6RDdcJECqVMrcfwYPllyoUNVP
Sat1FldQiCA=
=ptXj
-----END PGP SIGNATURE-----

--Sig_/J+0Gk71/fyIhDq1ihDu0daX--
