Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E013E347506
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 20:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785441779; cv=none; b=B8bBECUC9AQBA49Zh+wlFCHGzPYWgwrX/z2LpxBrHkMf2BrhDn872O4XvPMX+hLA1npeuUscjT9pyoRJEWHa4oRDPIQyPQToA4gln+IHgFjh9f97y2sDTRDZLK1KA3iXBfp+xAsC78AVhlaSWUpfUJKqw5nEweYZyma9a9Vg6is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785441779; c=relaxed/simple;
	bh=p8h4DmUfcqZszTFCaMcEisgt/6+IGvOqY85EQwlg0sg=;
	h=Cc:From:Message-Id:Content-Type:Mime-Version:Date:References:To:
	 Subject:In-Reply-To; b=eJ7Cf2u2D1Qdg9/9z+LuXEh8IPxsaGAdyEF73AzdC5W1tnt4xJYzqIIyLNFF2/PkkUGH/2j0+Y/cB+jiCpQstzx7p4BbVnDvFiHOpiJPoPHfqBkzhOI05fgSFX17AdDIoIWvblcYNqY6Oe+MvV9F8gRNUUUm2Awwxs5NWsbP5V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=oeGTWhjC; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="oeGTWhjC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785441767;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Tk3sB2hpJ9ZwidwOR2mz/E9yu5Xc7t091/qV5f+s5cM=;
 b=oeGTWhjCmPOCEjmug0M3diD9JDCXcMuzRJbB38gJiq+YxE2wTOAQYphIUx3DXWPR5DR/Jk
 HyvEPxCwhIQ7AKrehyZ86M1XJ+GuYdgOnNQBKcJxl/eNgyZ25ueo/jKtc24n319OVbiZUH
 QzOOmzzj+UJB4TC5DmO/1IPaKTr5iwgMp2STlTPT+G2v2RzPk50lfFV0ZP2aykSUaqMKbq
 JiWs0BxMdSDnntsHvkDKGcXNoECCAHuvL9IaqxGBrmrnZuC8H8oEZlNtc5fvTI2GpdfsMR
 Hg3ERSY4cxYdpKqszZAlugTsYU4EvonmCjmFhhyom0V7E4gIoNNl7XPkI8Tn9A==
Cc: <linux-raid@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <6a38d4fe-f8f6-4a0e-9054-9678f99537b1@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 20:02:46 +0000
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Date: Fri, 31 Jul 2026 04:02:44 +0800
X-Lms-Return-Path: <lba+26a6bade7+778631+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260710132339.7284-1-nishidafmly@gmail.com> <20260710132339.7284-2-nishidafmly@gmail.com> <20260710133601.099961F000E9@smtp.kernel.org>
To: <sashiko-reviews@lists.linux.dev>, 
	"Hiroshi Nishida" <nishidafmly@gmail.com>
Subject: Re: [PATCH 1/2] md/raid5: submit a window of stripes during resync/recovery
In-Reply-To: <20260710133601.099961F000E9@smtp.kernel.org>

Hi,

=E5=9C=A8 2026/7/10 21:36, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] The batched sync loop can greedily drain the stripe cache withou=
t yielding, causing severe latency spikes and potentially starving user I/O=
.
> --
>
> --- Patch [1]: [PATCH 1/2] md/raid5: submit a window of stripes during re=
sync/recovery ---
> commit 2b3cdb45d82bdea6112cba5dad14b59ec3acb23a
> Author: Hiroshi Nishida <nishidafmly@gmail.com>
>
> md/raid5: submit a window of stripes during resync/recovery
>
> This patch updates the RAID5 sync path to dispatch a batch of up to 32
> stripes per call instead of just one. It throttles only on the first stri=
pe,
> allowing subsequent stripes to be submitted without blocking to improve
> resync performance.
>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 0c5c9fb0606ee..574880e4f23fe 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
> [ ... ]
>> @@ -6640,13 +6632,42 @@ static inline sector_t raid5_sync_request(struct=
 mddev *mddev, sector_t sector_n
> [ ... ]
>> +	/* Submit remaining stripes in the window non-blocking.  Stop early
>> +	 * if the stripe cache is full: the disk queue is already saturated.
>> +	 * Bound by resync_max so a user- or cluster-imposed sync ceiling is
>> +	 * not overshot.
>> +	 */
>> +	win_sector =3D sector_nr + RAID5_STRIPE_SECTORS(conf);
>> +	for (submitted =3D 1;
>> +	     submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
>> +	     win_sector < mddev->resync_max;
>> +	     submitted++, win_sector +=3D RAID5_STRIPE_SECTORS(conf)) {
>> +		sh =3D raid5_get_active_stripe(conf, NULL, win_sector,
>> +					     R5_GAS_NOBLOCK);
>> +		if (!sh)
>> +			break;
> [Severity: High]
> Can this batched sync loop greedily drain the stripe cache without yieldi=
ng to
> user I/O?
>
> During array resync or recovery, this loop acquires up to 32 free stripes
> sequentially. Could this starve user I/O threads that are blocked on the
> conf->wait_for_stripe waitqueue, since it doesn't check if user I/O is wa=
iting
> (e.g., via waitqueue_active(&conf->wait_for_stripe)) before getting the n=
ext
> stripe?

This make sense, always submit 32 stripes at a time will against the thrott=
ling rules
from sync_io_depth. Please check this in sync_io_within_limit(), and do not=
 exceed
the limit.

>
>> +		md_bitmap_start_sync(mddev, win_sector, &sync_blocks,
>> +				     still_degraded);
>> +		set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
>> +		set_bit(STRIPE_HANDLE, &sh->state);
>> +		raid5_release_stripe(sh);
>> +	}
>> +
>> +	return submitted * RAID5_STRIPE_SECTORS(conf);
>>   }

--=20
Thanks,
Kuai
