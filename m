Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31C73B52E7
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785442063; cv=none; b=TLAB9Ir4MOen9iLVXnNLA7ScxA8xHOD7X4UgZzNTkIpn4YqkZgWw7A6KHcMu6PvxtJ/kLQM9aa9xjSHvGOtxw61fHf8YkQ++NhqL3k67lw2T2BqVwpZSc+X/AF46OEkw5m8cZPb74UzusLoqEz99KQzwIwj4k4/G/b99Vm/4yjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785442063; c=relaxed/simple;
	bh=gIUUDNbF0f1jVuBTDyZP8/pajrsB2uoEZNusFzpYq/g=;
	h=Cc:Subject:Date:From:Mime-Version:To:In-Reply-To:Message-Id:
	 Content-Type:References; b=sJpnROUfS+iDt2tVmACrSysokbRj4+Ll16oklCiO5x/HqPrQkfQAOoJEPlV+RsvdYM9g3KvmmpWpEsfunK+bF6kmfpD6YtVS+e7Mf5tIsUOFuDW963WlTcYUm60yiV1exVivB54x80O0D1DJDN+rBh6UnraS/kvDaMR7hIZBlDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=KkfcIBZG; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="KkfcIBZG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785442054;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=boMMpd8TAe8v+X91QDzc4BUyoESurNrhzh3AeeMYOAI=;
 b=KkfcIBZGbdqpfBMeA+X50Xj/2g1msyYw/dYhswW/2042Y3Y4nGROaUO+Ok7kNRCpDmMHaG
 Rb61acXSUfsDwelyW1tWOrq9i4uGHAauCrXKTyGNCm5yT8ZQMwWy2GQ/4hFG6McpkKghmS
 FyrHw6dKbJGKnPGEeP7Wgyso7kn7kLHAA+RYjcI9Rnf6KdQ1mzz1fgFbcrInMBxclnS1Vh
 mpz5V1e909stz+JAYb1xdxarpGZRX6185V5jQjJ/wUIDLtz8GgVZk7IAEq8vE9jARovUPp
 HzUb5KlFf03e3fma7WQYiv00HE+0spdAIPIax0IYIfkbsC71hnGpc6Ho0Ql1EQ==
Reply-To: yukuai@fygo.io
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] md/raid5: reserve stripe cache for user I/O during rebuild
Date: Fri, 31 Jul 2026 04:07:29 +0800
Content-Transfer-Encoding: quoted-printable
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 20:07:32 +0000
In-Reply-To: <20260710132339.7284-3-nishidafmly@gmail.com>
Message-Id: <cf8bebfb-ddce-4f1d-9da3-993ab60e5e01@fygo.io>
Content-Type: text/plain; charset=UTF-8
References: <20260710132339.7284-1-nishidafmly@gmail.com> <20260710132339.7284-3-nishidafmly@gmail.com>
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a6baf05+b2bb4c+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/10 21:23, Hiroshi Nishida =E5=86=99=E9=81=93:
> The resync read-ahead window (RAID5_SYNC_WINDOW) can fill the stripe
> cache with rebuild stripes and starve concurrent user I/O, producing a
> burst-starvation flip-flop between rebuild and application throughput.
>
> Add two yield points to the window-submission loop:
>   - stop the window immediately if any thread is waiting for a stripe
>     (waitqueue_active(&conf->wait_for_stripe)); the check is intentionall=
y
>     racy -- a waiter appearing just after is serviced by the next
>     sync_request call, so no barrier is needed.
>   - stop expanding once active_stripes reaches half the cache
>     (max_nr_stripes / RAID5_SYNC_HWMARK), but only when
>     preread_active_stripes > 0, i.e. user write I/O is actually competing=
.
>     Sync stripes never set STRIPE_PREREAD_ACTIVE, so during a pure rebuil=
d
>     the counter stays zero and the window fills freely; rebuild-only
>     throughput is unchanged.
>
> This bounds the share of the stripe cache a rebuild may hold while user
> I/O is present, so application latency no longer collapses during the
> read-ahead bursts, without throttling a rebuild that has the array to
> itself.
>
> Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
> ---
>   drivers/md/raid5.c | 21 +++++++++++++++++++++
>   drivers/md/raid5.h |  1 +
>   2 files changed, 22 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 574880e4f23f..6575bdb84bb2 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6656,6 +6656,27 @@ static inline sector_t raid5_sync_request(struct m=
ddev *mddev, sector_t sector_n
>   	     submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
>   	     win_sector < mddev->resync_max;
>   	     submitted++, win_sector +=3D RAID5_STRIPE_SECTORS(conf)) {
> +		/*
> +		 * Yield to user I/O: stop the read-ahead if anyone is waiting
> +		 * for a stripe.  The check is intentionally racy -- a waiter
> +		 * appearing just after is serviced by the next sync_request
> +		 * call, so no barrier is needed.
> +		 */
> +		if (waitqueue_active(&conf->wait_for_stripe))
> +			break;
> +		/*
> +		 * Reserve cache for user I/O only when it is actually competing.
> +		 * preread_active_stripes counts stripes queued for write I/O
> +		 * (including the read phase of RMW); sync stripes never set
> +		 * STRIPE_PREREAD_ACTIVE, so during a pure rebuild it stays zero
> +		 * and the window fills freely.  Competing user reads do not bump
> +		 * the counter but are caught by the waitqueue_active() check
> +		 * above.
> +		 */
> +		if (atomic_read(&conf->preread_active_stripes) > 0 &&
> +		    atomic_read(&conf->active_stripes) >=3D
> +		    conf->max_nr_stripes / RAID5_SYNC_HWMARK)
> +			break;

Please check md_do_sync(), if any user IO is active, sync speed and sync IO=
 depth is
limited there. Above is not the right place to throttle sync IO for user IO=
, when the
above checking failed, the array is already under heavy sync IO load.

>   		sh =3D raid5_get_active_stripe(conf, NULL, win_sector,
>   					     R5_GAS_NOBLOCK);
>   		if (!sh)
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 63b630118782..263330af4e7d 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -492,6 +492,7 @@ struct disk_info {
>   #define HASH_MASK		(NR_HASH - 1)
>   #define MAX_STRIPE_BATCH	8
>   #define RAID5_SYNC_WINDOW	32	/* stripes to pre-submit per sync_request =
call */
> +#define RAID5_SYNC_HWMARK	2	/* rebuild uses at most 1/N of stripe cache =
*/
>  =20
>   /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
>    * This is because we sometimes take all the spinlocks

--=20
Thanks,
Kuai
