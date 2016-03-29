From: NeilBrown <neilb@suse.de>
Subject: Re: Unable to handle kernel NULL pointer dereference in super_written
Date: Wed, 30 Mar 2016 09:23:28 +1100
Message-ID: <87d1qcvs7z.fsf@notabene.neil.brown.name>
References: <678678296.35099303.1459240762496.JavaMail.zimbra@redhat.com> <538658018.35237734.1459254120634.JavaMail.zimbra@redhat.com> <20160329213731.GA2287@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160329213731.GA2287@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 30 2016, Shaohua Li wrote:

> On Tue, Mar 29, 2016 at 08:22:00AM -0400, Xiao Ni wrote:
>> Hi all
>>=20
>> I encountered one NULL pointer dereference problem.
>>=20
>> The environment=EF=BC=9A
>> latest linux-stable and mdadm codes
>> aarch64 platform
>> the md device is created with loop devices
>>=20
>> It's a test case to check date integrity. I added the test script as the=
 attachment.
>
> Could you please try this patch:
>
>
> From b86d9e1724184c79ad1ea63901aec802492b861c Mon Sep 17 00:00:00 2001
> Message-Id: <b86d9e1724184c79ad1ea63901aec802492b861c.1459285706.git.shli=
@fb.com>
> From: Shaohua Li <shli@fb.com>
> Date: Tue, 29 Mar 2016 14:00:19 -0700
> Subject: [PATCH] MD: add rdev reference for super write
>
> md_super_write() and corresponding md_super_wait() generally are called
> with reconfig_mutex locked, which prevents disk disappears. There is one
> case this rule is broken. write_sb_page of bitmap.c doesn't hold the
> mutex. next_active_rdev does increase rdev reference, but it decreases
> the reference too early (eg, before IO finish). disk can disappear at
> the window. We unconditionally increase rdev reference in
> md_super_write() to avoid the race.
>

Yes, that makes sense.  Thanks.

Acked-by: NeilBrown <neilb@suse.com>


> Reported-by: Xiao Ni <xni@redhat.com>
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c068f17..bcfde333 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -718,6 +718,7 @@ static void super_written(struct bio *bio)
>=20=20
>  	if (atomic_dec_and_test(&mddev->pending_writes))
>  		wake_up(&mddev->sb_wait);
> +	rdev_dec_pending(rdev, mddev);
>  	bio_put(bio);
>  }
>=20=20
> @@ -732,6 +733,8 @@ void md_super_write(struct mddev *mddev, struct md_rd=
ev *rdev,
>  	 */
>  	struct bio *bio =3D bio_alloc_mddev(GFP_NOIO, 1, mddev);
>=20=20
> +	atomic_inc(&rdev->nr_pending);
> +
>  	bio->bi_bdev =3D rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev;
>  	bio->bi_iter.bi_sector =3D sector;
>  	bio_add_page(bio, page, size, 0);
> --=20
> 2.8.0.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW+wBgAAoJEDnsnt1WYoG5onkP/3ZogLzxt02bL01KA/Mzbb+4
BgY8IFdcd18Vn0Rl92ooNSWLRsrtEGfo6UEX+BfCMwi+uej6WmxDKM4FpOUoXAqO
3YACgg2lgAq/H+YMCZWVckem3FMTmKmy4sUvQLdzgIoDBKkkUfA5sPfEH/EIUVcr
SI0VxcqWiPqESOfTuKVMvy8T+t+WjGWbTJqJISRxI/BZV+vBA3OUHu1D50ucwVal
6lQTzhIPNCBFYlWXG1tT4gM/IpCgBD7gTs5gnP30BSZQlem8kbRHSBC/Jt1TWeT7
owQ7ixguEpQp/CBL3oVnJGo1NS01pb+vYy3ybKlYHEUiTwp1EW9rv/QQh8hcq2gb
uxHbEXR3AMvsY3O6pDjmDdMn14IntYVuXj+gnxiyagNb8GC6wVmv3j2m+KBOPnDs
OcF6xl2URp1xFWEEA9QRTWzhphBtm4SRnigXmdKXMOc061FEbNEaHYE2vDqdkv0F
Pxg3mrKRETSvlhyCRfnwTCNsL5bNDgCkt48Ake07xeVhzzDF1BDWOBqOw06SxDif
TpTYPgsOYuc+5JYr8U4tCKYc2S53CiGE3Ggx+ZJn857JZJFwCORq2HtByRBYMD0Q
njh55nhYTfy2YXkD0TOHdsTuhGF6vBYQTyI/wwFH41SOriEKNUM+2h62vhBtEcU3
Zw4B/WmhJkl+/EBGtsF8
=iQJg
-----END PGP SIGNATURE-----
--=-=-=--
