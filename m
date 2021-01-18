Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0CEC433E0
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 01:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA72720758
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 01:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbhARBAg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Jan 2021 20:00:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:47208 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730595AbhARBA3 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 17 Jan 2021 20:00:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4F80FAC6E;
        Mon, 18 Jan 2021 00:59:47 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     Kevin Vigor <kvigor@gmail.com>, linux-raid@vger.kernel.org
Date:   Mon, 18 Jan 2021 11:59:43 +1100
Cc:     Kevin Vigor <kvigor@gmail.com>
Subject: Re: [PATCH 1/2] md/raid10: wake pending freeze in raid10d()
In-Reply-To: <20201231173000.3596606-1-kvigor@gmail.com>
References: <20201231173000.3596606-1-kvigor@gmail.com>
Message-ID: <87bldnjc00.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 31 2020, Kevin Vigor wrote:

> The freeze_array() function waits for changes to nr_queued,
> but the raid10d() function alters it without sending a wake.
>
> This can lead to freeze_array() never being woken.

No it cannot.
freeze_array() is only called from handle_read_error() which is only
called from raid10d().  So it cannot possibly be sleeping at the point
where you added the wake_up().
handle_read_error() passes '1' as the 'extra' arg to freeze_array()
which exactly compensates for the recent decrement of ->nr_queued.

NAK.

Thanks,
NeilBrown


>
> Signed-off-by: Kevin Vigor <kvigor@gmail.com>
> ---
>  drivers/md/raid10.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c5d88ef6a45c..f98df9f084c2 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2698,6 +2698,7 @@ static void raid10d(struct md_thread *thread)
>  	struct r10conf *conf =3D mddev->private;
>  	struct list_head *head =3D &conf->retry_list;
>  	struct blk_plug plug;
> +	int dequeued =3D 0;
>=20=20
>  	md_check_recovery(mddev);
>=20=20
> @@ -2709,6 +2710,7 @@ static void raid10d(struct md_thread *thread)
>  			while (!list_empty(&conf->bio_end_io_list)) {
>  				list_move(conf->bio_end_io_list.prev, &tmp);
>  				conf->nr_queued--;
> +				dequeued++;
>  			}
>  		}
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
> @@ -2739,6 +2741,7 @@ static void raid10d(struct md_thread *thread)
>  		r10_bio =3D list_entry(head->prev, struct r10bio, retry_list);
>  		list_del(head->prev);
>  		conf->nr_queued--;
> +		dequeued++;
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
>=20=20
>  		mddev =3D r10_bio->mddev;
> @@ -2762,6 +2765,10 @@ static void raid10d(struct md_thread *thread)
>  			md_check_recovery(mddev);
>  	}
>  	blk_finish_plug(&plug);
> +
> +	/* in case freeze_array is waiting for changes to nr_queued. */
> +	if (conf->array_freeze_pending && dequeued)
> +		wake_up(&conf->wait_barrier);
>  }
>=20=20
>  static int init_resync(struct r10conf *conf)
> --=20
> 2.26.2

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJCBAEBCAAsFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAmAE3X8OHG5laWxiQHN1
c2UuZGUACgkQOeye3VZigbkN3Q//Y27niiBfatatPrMPCNmOmw4mlpNvSIeMpjgB
UtaCAvKgozZ/Ij3P9vZrz3doPbtVAhiTiC8ifsUhYrLBS+GR9HGl/2pNXWlKGgHD
ibYxPISh3Ln+lAjrN6Tjr/Gntbd8eS98xOC4rd266qpZdZlvy42bFlkioLVcLy7q
jhGIc5EfTvMdYzY5BX9SX7Lq9zbwaShUYJdcpef/GjcTI7O/Q7LR4KOdFCeUFfKx
VLDfxYryZVY3Hij8ucm/jzhRc4Rueyh+gM7QGbq+3WAkGCy7Z7Zjkyon71mZMm11
N9/yz52+CD0UjILVMsn/eWDUdFpuamXuDyumI7DYM7T7I7fNnjGHXv6QBmkl5ZMI
NQWlkYWcPY3bi5vEblg+clan1Wcr0hzBkzGw0xQA7QpfrDKD2a3VGZucS7rjpdQ2
0U0MTvv1kBZXqh8nm0e6HII7USMdSiPgkCLp2+IvIqBNW48iYPrjXbGcG/6ZNWcx
viKxsI8W7u4tdwC4uUhVtRdK863opU9L6H9HZhVofOMuu3gDE5QVxK7gKZuOQBXN
jQR1Rg/GaF8anfOuww16hFpqbdiM6NcXFiyEOKmYcY66L9BI9AYsOLjkw+5o5TYk
llODHYvimUanIFJcruH7eFL9Ynco0gUp3Uj8YWcBRTBXc3T88/kqZTRH8np4T03e
Ecyex4M=
=eUTa
-----END PGP SIGNATURE-----
--=-=-=--
