Received: from va-2-17.ptr.blmpb.com (va-2-17.ptr.blmpb.com [209.127.231.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25369171CD
	for <linux-raid@vger.kernel.org>; Sun,  5 Jul 2026 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783268200; cv=none; b=FmWbJhIrHbv/cfdg/hByh4j9g/yGdZ/wlIkxzeqqGsqdLsFR65GnMiFE82cnUGRuIdAcOnk0hBboyEVogvbTCYTM0Fp+XJ4yBINHN/9/MhJ/Yg1NQgIoayAmqYeeck5M5cyRd33UrvIoSW+VCHSXUQ6w2vPIQ3uvR1xmn5Qdub8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783268200; c=relaxed/simple;
	bh=MxeCiJGguuKfSXWxTHmUYzDXBfnnqUDlHIzYxNiS9CA=;
	h=Date:References:To:Message-Id:Mime-Version:In-Reply-To:From:
	 Subject:Content-Type:Cc; b=AuvR+iBtWFzneE33AynOc3uksBb1jm9wksSGYlYbjEp8vSaSLBbQVFMAFatcb0O8PMhePHELTeQIaLZz1Gre6uBhdD/XJ68UglOrRyXEk4r99WvJVXpz5LB3tQJCOHd9O5XR2jkGCoPfty3shPPNCUrkVGeU/+giSKsQnLoXscY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RB4d88R8; arc=none smtp.client-ip=209.127.231.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RB4d88R8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783268190;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=b6AtWDZjTTxX3OsXNXFJqOyicH//GW2+ir0w4NemRJI=;
 b=RB4d88R8MQjhiq16IenPE1wweLEjpSfKXKJ7N5sGMdxA2ycGNd31c38CWrtW4yrnybXJbQ
 7i6cJTGgjlSfrca+ZqGSoTTWu0aUE/ADEgRYWG8MHFz9Xkzt5Ep7ufWI+b8zL3hZBKVwUm
 UFxnML7FeU12BJnBoSM+6zsrKSDdonnNV7LjXmE8xGvIK3VTrDj3ix3tv/Wa1PBV0nu7Pv
 ZL8xI9Vb6ucWl3ghSXsMEOI60zQF6dSnhIyd9iS1yWdnDrtxRqZD7qTbuJwtNawpkFlNkD
 L+4vno/7xnBsCZUcXsqRWh1+/daQwY8wTxdFYXRyci/zjV7MVWeXLmLc/yHXHg==
Date: Mon, 6 Jul 2026 00:16:24 +0800
Content-Transfer-Encoding: quoted-printable
References: <20260630075640.1081634-1-abd.masalkhi@gmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <yukuai@fygo.io>
Message-Id: <0a7dc7e2-30af-44de-8c29-b6e27a62fa55@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260630075640.1081634-1-abd.masalkhi@gmail.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sun, 05 Jul 2026 16:16:28 +0000
X-Lms-Return-Path: <lba+26a4a835d+46fd35+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md: avoid modifying spares while the array is not suspended
Content-Type: text/plain; charset=UTF-8
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"sashiko-bot" <sashiko-bot@kernel.org>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/6/30 15:56, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> remove_spares() and remove_and_add_spares() modify the array's rdev
> configuration. These operations are only safe after the array has been
> suspended.
>
> Today, md_start_sync() can call md_choose_sync_action() even when the
> array has not been suspended. As a result, md_choose_sync_action() may
> remove or replace rdevs while normal I/O is still accessing them.
>
> The race can occur as follows:
>
> raid10d          Worker                      Normal IO
> ____________     _______________________     ______________________
>
>                                               raid10_write_request()
>                                               wait_blocked_dev()
> set Blocked
> set Faulty
>                                               Skip Faulty rdev
>                                               rrdev->nr_pending++
>                                               .repl_bio =3D bio
>                   removeable_rdev =3D false     .
>                   array not suspended         .
> lock mddev                                   goto err_handle
>                   lock mddev (wait)
>                   .
> update sb        .
> clear Blocked    .
>                   .
> unlock mddev     .
>                   lock mddev (acquires)
>                   remove_spares()
>                   removeable_rdev =3D true
>
>                   raid10_remove_disk()
>                   rdev =3D replacement
>                   replacement =3D NULL
>                                               rdev_dec_pending(NULL)
>                   unlock mddev                (NULL)->nr_pending--
>
> In this case, rdev_dec_pending() is called with a NULL pointer,
> resulting in a NULL pointer dereference when attempting to decrement
> nr_pending.
>
> Fix this by ensuring that remove_spares() and remove_and_add_spares()
> are only called after the array has been suspended, preventing
> concurrent rdev configuration changes while normal I/O is in progress.
>
> Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need =
reconfiguration")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260628142420.1051027-1-abd.masal=
khi@gmail.com?part=3D3
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
>   drivers/md/md.c | 18 +++++++++++++-----
>   1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 66a41d482e59..c85ebb59535b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -10116,7 +10116,8 @@ static int remove_and_add_spares(struct mddev *md=
dev,
>   	return spares;
>   }
>  =20
> -static bool md_choose_sync_action(struct mddev *mddev, int *spares)
> +static bool md_choose_sync_action(struct mddev *mddev, int *spares,
> +				  bool array_suspended)
>   {
>   	/* Check if reshape is in progress first. */
>   	if (mddev->reshape_position !=3D MaxSector) {
> @@ -10132,7 +10133,9 @@ static bool md_choose_sync_action(struct mddev *m=
ddev, int *spares)
>  =20
>   	/* Check if resync is in progress. */
>   	if (mddev->resync_offset < MaxSector) {
> -		remove_spares(mddev, NULL);
> +		if (array_suspended)
> +			remove_spares(mddev, NULL);

The problem looks real, however, I think this will cause a change that user=
 will be awared,
if there are really spares that can be removed from conf, but array is not =
suspended here,
user will still expect rdev will be removed from conf automatically.

In md_start_sync, if suspend is false, can we check again after mddev_lock?=
 If suspend is
supposed to be true, we can release the lock and retry with suspend =3D tru=
e.

> +
>   		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>   		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   		clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
> @@ -10144,7 +10147,11 @@ static bool md_choose_sync_action(struct mddev *=
mddev, int *spares)
>   	 * also removed and re-added, to allow the personality to fail the
>   	 * re-add.
>   	 */
> -	*spares =3D remove_and_add_spares(mddev, NULL);
> +	if (array_suspended)
> +		*spares =3D remove_and_add_spares(mddev, NULL);
> +	else
> +		*spares =3D 0;
> +
>   	if (*spares || test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery)) {
>   		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>   		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> @@ -10189,11 +10196,12 @@ static void md_start_sync(struct work_struct *w=
s)
>   		 * As we only add devices that are already in-sync, we can
>   		 * activate the spares immediately.
>   		 */
> -		remove_and_add_spares(mddev, NULL);
> +		if (suspend)
> +			remove_and_add_spares(mddev, NULL);
>   		goto not_running;
>   	}
>  =20
> -	if (!md_choose_sync_action(mddev, &spares))
> +	if (!md_choose_sync_action(mddev, &spares, suspend))
>   		goto not_running;
>  =20
>   	if (!mddev->pers->sync_request)

--=20
Thanks,
Kuai
