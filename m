Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294BE36AB5E
	for <linux-raid@vger.kernel.org>; Sun, 22 Mar 2026 18:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774204241; cv=none; b=ic6GaxdzMtW7FEs/J5SUtxLX42ADjBPV8GlmOeNnnWgx7d8Gut0+bsZQE/mBUf9ZrwCpKPQrudhxheg77pZirW111lk8/g82oz1rjSVrsDnt5cGd7/F8/ZYwuwCkynoC0QZ6dBO4kEgJu+ee0pY9iGavw/L99I+IXByGlrDhQuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774204241; c=relaxed/simple;
	bh=j3Ed4yKFN631jNV3eiYaFoDb5difrf+by4q+Q9GBVlY=;
	h=From:Message-Id:In-Reply-To:References:Cc:Date:Subject:To:
	 Mime-Version:Content-Type; b=XVWbUkoWi2CiZzODmc1Z/S6pjabjZ1Bit0qnxCR8J0Qdllv9MrOpGkgHZxPqz//+fm4JG2s0UFu38QG+E95JVAyxHZSSR+s3OQuYmA54RGC/BA82zLbWJ7cZnXz/AXpr/0Y7wstvBtcRvnVEhZOeZeGG/djGfvc+fPzOYAcjpDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=dd7IDSoh; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="dd7IDSoh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774204230;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=gBgfIgopAA9P25tS6I+gUPUCQd3Q2nbahtxBbgaQZ3U=;
 b=dd7IDSohRuHWsB6gX30+HBkOxU/0XiLY1rZW8NqkYvTYQ+U5sXEB1ppeQd8O4x+/DsGPfl
 P5l5UdJXCDCaVaV8WFM44Fd4higOc1aj/meoAHYNfhrU2gArUbPJSx1KE1o1oo4qwEqISA
 I7fNquMaJ1SRCquv41LST8ucUEecZYA/P8bSiq43vN01fZx+Zggzv0S/DBclSiF5K0EQBB
 +avUzwpA6XlZZiHQh6I2Xe2KQNCeHR8ejsCmEUmBDlJ+ycOtohTduOKyRROkAJiNmcBguH
 ioQzB6UqiraUhQKJTw3/rjUC0W8gut9bHf8YgBTkzpMKzojNC3db1k5UhuJrKQ==
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <1bb3659d-4911-4cd8-bb2c-d2399e5a02c2@fnnas.com>
In-Reply-To: <20260223024038.3084853-1-yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20260223024038.3084853-1-yukuai@fnnas.com>
Cc: <linan122@huawei.com>, <xni@redhat.com>, <colyli@fnnas.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
Date: Mon, 23 Mar 2026 02:30:25 +0800
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.158]) by smtp.feishu.cn with ESMTPS; Mon, 23 Mar 2026 02:30:27 +0800
Subject: Re: [PATCH v2 0/5] md/md-llbitmap: fixes and proactive parity building support
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269c03544+405f30+vger.kernel.org+yukuai@fnnas.com>
Content-Language: en-US
To: <song@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/2/23 10:40, Yu Kuai =E5=86=99=E9=81=93:
> Changes in v2:
>   - add error message in error path in patch 3;
>
> This series contains fixes and enhancements for the md-llbitmap (lockless
> bitmap) implementation.
>
> Patches 1-2 are bug fixes:
> - Patch 1 fixes bitmap data being read from spare disks that are not yet
>    in sync, which could lead to incorrect dirty bit tracking.
> - Patch 2 fixes a race condition where the state machine could transition
>    before the barrier is properly raised.
>
> Patch 3 improves compatibility with older mdadm versions by detecting
> on-disk bitmap version and falling back to the correct bitmap_ops when
> there's a version mismatch.
>
> Patch 4 adds support for proactive XOR parity building in RAID-456 arrays=
.
> This allows users to pre-build parity for unwritten regions via sysfs
> before any user data is written, which can improve write performance for
> workloads that will eventually use all storage. New states (CleanUnwritte=
n,
> NeedSyncUnwritten, SyncingUnwritten) are added to track these regions
> separately from normal dirty/syncing states.
>
> Patch 5 optimizes initial array sync for RAID-456 arrays on devices that
> support write_zeroes with unmap. By zeroing all disks upfront, parity is
> automatically consistent (0 XOR 0 =3D 0), allowing the bitmap to be
> initialized to BitCleanUnwritten and skipping the initial sync entirely.
> This significantly reduces array initialization time on modern NVMe SSDs.
>
> Yu Kuai (5):
>    md/md-llbitmap: skip reading rdevs that are not in_sync
>    md/md-llbitmap: raise barrier before state machine transition
>    md: add fallback to correct bitmap_ops on version mismatch
>    md/md-llbitmap: add CleanUnwritten state for RAID-5 proactive parity
>      building
>    md/md-llbitmap: optimize initial sync with write_zeroes_unmap support
>
>   drivers/md/md-llbitmap.c | 213 +++++++++++++++++++++++++++++++++++----
>   drivers/md/md.c          | 117 ++++++++++++++++++++-
>   2 files changed, 309 insertions(+), 21 deletions(-)

Apply patch 1 and 2 to md-7.1, will send a new version for others soon.

--=20
Thansk,
Kuai
