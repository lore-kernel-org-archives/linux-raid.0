From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md:array cannot be opened again after 'md_set_readonly'
Date: Wed, 29 Mar 2017 08:18:02 +1100
Message-ID: <87bmsl6qyd.fsf@notabene.neil.brown.name>
References: <1490601145-5865-1-git-send-email-zlliu@suse.com> <20170327182214.zde4kao2gz2lazgm@kernel.org> <0c5289f3-0160-8d2d-a5d8-da126b2fb468@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0c5289f3-0160-8d2d-a5d8-da126b2fb468@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, Shaohua Li <shli@kernel.org>
Cc: shli@fb.com, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 28 2017, Zhilong Liu wrote:

> On 03/28/2017 02:22 AM, Shaohua Li wrote:
>> On Mon, Mar 27, 2017 at 03:52:25PM +0800, Zhilong Liu wrote:
>>> This is a bug about array cannot be opened again after 'md_set_readonly=
',
>>> because the MD_CLOSING bit is still waiting for clear.
>>> MD_CLOSING should only be set for a short period or time to avoid certa=
in
>>> races. After the operation that set it completes, it should be cleared.
>> where is the bit set? Why don't clear it after the operation but clear i=
t in
>> set_readonly?
>>=20=20=20
>
> it goes two paths after set MD_CLOSING bit, do_md_stop and md_set_readonl=
y,
> the do_md_stop has done the md_clean to clear the mddev->flags, thus I=20
> put it in
> md_set_readonly.
> Thanks for your suggestion, is the following changing good for you? here=
=20
> it has
> finished what it needs to do, so clear the MD_CLOSING bit in time.
> if looks good, I would send this in new revision patch.
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6ae1d6..e8c1130 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6868,6 +6868,7 @@ static int md_ioctl(struct block_device *bdev,=20
> fmode_t mode,
>                  set_bit(MD_CLOSING, &mddev->flags);
>                  mutex_unlock(&mddev->open_mutex);
>                  sync_blockdev(bdev);
> +               clear_bit(MD_CLOSING, &mddev->flags);

No.

MD_CLOSING is used to prevent a race with md_open().
md_open() blocks on open_mutex(), but we cannot hold that here for
complicated reasons.
So we set MD_CLOSING and need to keep it set at least until
md_set_readonly() or do_md_stop() take that lock again.

Clearing it here just opens up the race again.

It needs to be cleared in md_ioctl, after any call to md_set_readonly()
or do_md_stop().
I've already posted a sample patch which has been tested.  Please don't
do something completely different.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlja0woACgkQOeye3VZi
gbmhMw/9FrQOmyujRx579OV8WZknaSJ7q3LkSyqF/6LyHrpwy7ypjMywWq6DloJy
b+xf6stLDsu7fUvtpxxiy3Gvg6WRjyqTiwLu/Nbf9uK+XpaxdAOgpx8RI54xXhMc
8ncNYCOIee2N5Pfbu6m3savAsFg/q/7nhyLWtU0Ln+x0Jwe5oT3zIHmQYSXTWj8A
8KUK50tV2xyWNXB6vInGix+FuGoOiy9oMU5x3zZOEqHWZTwTYOyBjW2qL0Xe02fl
x7685YQ2xbq4cxDxdff2oyc3naEq/XxhHhu/hbCfzUiAzcg46TWWTwJjHqF4H8EI
EJwWCNnQogYZ71UNJyvKbksRP0op2EOo6m1Z14Rd+zuYeIlSyI/atrOX5ucj+8JC
VjJFqbieiKfjQLRq2+ubMzwp2YDP7jFDgr1bKxEVcGM9sjS6n/XhzYfLfzzJYAHp
1xVp0wE4ljyli9ppCdDKDy27zz12NhwUQQTLliv2iZb9Iq0EmAlu4ySirVw2shBi
sbrTaK5w3sD1Z4ISXJo9wpan4GnFAtJGlkEeCHEdaIDtxvPMrQPX0SI0+7bWhlkb
oIzZNuaPmogx+NKhGnsQmd/liPnvp5/WG7Piq/aBje8OGzfUpqnx/0CE6+oNPWzE
3s/JNo9VAekxqWrVkv5UVqbD/Fwjaz+Y7qK8ijBt01p5KH1nB8o=
=gwbQ
-----END PGP SIGNATURE-----
--=-=-=--
