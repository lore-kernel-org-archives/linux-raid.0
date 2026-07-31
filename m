Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B20258EFF
	for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 00:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785458158; cv=none; b=eEKc+qMAvUJYpDHgTO1VkxSlgCLlGClEU9LDzylgKkp1pY+usG21rlpFrbzuyMZStqMqagMFM09OmQDYwTLyl5wQK15mdhw796hNOKLo+33VVTgnRwMfnLb90Bo8xTaB06xey/3qA7bOSHZW6PZOEccHSyIsLOrgSbLyD2AnNg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785458158; c=relaxed/simple;
	bh=IvQHO0zxrD1oRHxpyKnG9V+Ty5tK2qINhYyB5AXcpZE=;
	h=Date:References:To:Message-Id:In-Reply-To:Content-Type:Cc:From:
	 Subject:Mime-Version; b=EWCsIzaCpNHdxqDbuJpujQvIYn+l0S9VYTb7R8MDEO41J/EC6nOY+N2IeUGYEDvWqU+54uAoiOTnqRUE7IQUWhITGvyJJp7OANCHx/0g52I862ahae+a6Pp+3XatcxjANKef208H+gTQeX6pezaIaK+/ZtqREv7pyCV2HMG5nyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=IU2A41V6; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="IU2A41V6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785458147;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=qWwwrs460SZmSdE4nd94jK4w5WoqeNyfvIflzlgT+d4=;
 b=IU2A41V6W/L+n/NzuiZPhU76htvxN4DbOxH7y0koCi3YS36JtveTVghhQDv9jJwEUAzKjC
 k04AFNX7fkDGPp2zOZ2pUqkgW9YUY922yRV3nlbkokoL3vJKfbPi9wuFXGUoFdjgjoq7ki
 i8zDLxQOaW20EB/tzzJR17tiy9C0gpoJhh+GLE23IpHRNtd5JBFiwWlc3lhiD+eWSDBI+P
 DPRpkv8QeyHOfCfTThuWukLvhtJA8KXiPYkBEDW+U9UhBlZqYsR8OA9kokHX2yk7dHkkDk
 LilHboGiEfJA327WtxO6cF11xZK1rB61hhBa1yLMDlzf2D242s1ImLMcinP4Rg==
Date: Fri, 31 Jul 2026 08:35:42 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Fri, 31 Jul 2026 00:35:46 +0000
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <axboe@kernel.dk>, 
	<vverma@digitalocean.com>, <john.g.garry@oracle.com>, 
	<martin.petersen@oracle.com>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Message-Id: <41ecd70b-14af-4747-b24f-7cf9b9aa3e75@fygo.io>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260710101521.1714-1-abd.masalkhi@gmail.com>
X-Lms-Return-Path: <lba+26a6bede3+f25b48+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v4 0/7] md/raid10: fixes, atomic write handling, and error-path cleanup
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi,

=E5=9C=A8 2026/7/10 18:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> Hi,
>
> This v4 of series contains a mix of bug fixes and cleanups for RAID10,
> along with a related atomic write fix for RAID1.
>
> Changes in v4:
>   - Improve the commit message of patch 2.
>   - Add Reviewed-by tag from John Garry to patch 2.
>   - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-=
1-abd.masalkhi@gmail.com/
>
> Changes in v3:
>   - Set chunk_sectors to BARRIER_UNIT_SECTOR_SIZE instead of setting
>     atomic_write_hw_unit_max.
>   - Avoid enabling write-behind when the atomic write exceeds the
>     write-behind limit.
>   - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027=
-1-abd.masalkhi@gmail.com/
>
> Changes in v2:
>   - Expand the commit message to explain why the
>     allow_barrier()/wait_barrier() pair is no longer needed.
>   - Drop the early atomic write split check from raid1_write_request().
>   - Advertise the atomic write size limit via queue limits.
>   - Disable write-behind instead of failing atomic writes when the
>     BIO_MAX_VECS limit is encountered.
>   - Drop the early atomic write split check from raid10_write_request()
>     and rely on queue limits instead.
>   - Fix a compilation error (bi -> bio).
>   - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-=
1-abd.masalkhi@gmail.com/
>
> Thanks,
> Abd-alrhman,
>
> Abd-Alrhman Masalkhi (7):
>    md/raid10: fix r10bio leak in raid10_write_request() error paths
>    md/raid1: restrict atomic write limits and handle runtime constraints
>    md/raid10: consistently fail atomic writes that require splitting
>    md/raid10: remove unnecessary barrier around bio_submit_split_bioset()
>    md/raid10: replace wait loop with wait_event_idle()
>    md/raid10: simplify write request error handling
>    md/raid10: simplify read request error handling

Applied patch 2,3,4 to md-7.3

Both patch 1 and patch 5 is not needed after your nowait patch.

>
>   drivers/md/raid1.c  |  25 ++++------
>   drivers/md/raid10.c | 118 +++++++++++++++++++++-----------------------
>   2 files changed, 65 insertions(+), 78 deletions(-)
>
--=20
Thanks,
Kuai
