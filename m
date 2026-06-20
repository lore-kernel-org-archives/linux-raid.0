Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9F35B1EB
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 20:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781988276; cv=none; b=NTOd9YJR2H8U61n9ZlmPepOL7hVyBmmMcQIUAra01Vpl93A1vVvUru9mqW7BYyN4jVFwMOhV/oV8p7nskOuLxttzaKhNMEo0DONLj0KbiQDLJ0n8VBjQ4plrYdQeogGF4OrMz79Ye9QqqGA+roys6HNESpHx3Hegi2mwXTuSLus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781988276; c=relaxed/simple;
	bh=4dYq9bwGNUFQpwK+sj/lDbgU9R1k6LsRqdBeYLqLU/g=;
	h=To:Message-Id:Content-Type:Cc:Subject:In-Reply-To:From:Date:
	 Mime-Version:References; b=nX6/GbfzeLL3l6EZoePQ9oJei78eAt8O2CT6RKXbepqGZsl2R5vj7MBVzQiYknANc/4c8nUtutIZBdpXWSv6XKwhhfafFuan/c+Clf+wBKjCX0GY+AD61fDMavPVNxOIZVc7rRLRa2O75rUqeTO49vT5OK/WNj693zrJXt87jBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=VToPlVV5; arc=none smtp.client-ip=209.127.231.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="VToPlVV5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781988267;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2w+ZGMjcrkBD4dMw8A5F1bpSaUYO/Mp7ig4pBhc9ELk=;
 b=VToPlVV5/a8zlz68h/TsPg26TCv33kRJUlEjvOrMAorAaXtfVIfreio87CVZHiSXCMUWPg
 l44JGRu0rwymhmt1RFx1fip65vkAqelv816d0urjhmVmG2RBc6dXKBiAI3dIDZV00cuywc
 m/9XiCc9TPoZHzyff6Pap1QNtFLTeSFqGrNWwYR3vBx53BGwRvgBE2Lo2kQYv2dJ/E4Qm8
 6Pe6hzh92/0UEWUuPvbt4e1X7T61lal+NfGmXau4bHaiGkGm2xlX2CQSRwVbwSeq+i9FrN
 nIqISgS5cfLKuJpwG4QfQ5TLyl2Cy2AgqC3LzEjYhpl6Saof/RtP+THkhvjxDQ==
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Message-Id: <63e12bca-7b3d-459f-864a-b7cf552454d1@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a36fbaa+064c11+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md/raid1: protect head_position for read balance
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 20:44:25 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20260619044114.1208456-1-chencheng@fnnas.com>
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 21 Jun 2026 04:44:22 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260619044114.1208456-1-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/6/19 12:41, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> KCSAN reports a data race between raid1_end_read_request() and
> raid1_read_request().
>
> The completion path updates conf->mirrors[disk].head_position in
> update_head_pos() without a lock, while the read-balance heuristic reads
> the same field locklessly in is_sequential() and choose_best_rdev().
>
> KCSAN report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>    BUG: KCSAN: data-race in raid1_end_read_request / raid1_read_request
>
>    write to 0xffff8f0306ba7868 of 8 bytes by interrupt on cpu 9:
>      raid1_end_read_request+0xb5/0x440
>      bio_endio+0x3c9/0x3e0
>      blk_update_request+0x257/0x770
>      scsi_end_request+0x4d/0x520
>      scsi_io_completion+0x6f/0x990
>      scsi_finish_command+0x188/0x280
>      scsi_complete+0xac/0x160
>      blk_complete_reqs+0x8e/0xb0
>      blk_done_softirq+0x1d/0x30
>     [...]
>
>    read to 0xffff8f0306ba7868 of 8 bytes by task 667002 on cpu 11:
>      raid1_read_request+0x497/0x1a10
>      raid1_make_request+0xdf/0x1950
>      md_handle_request+0x2c5/0x700
>      md_submit_bio+0x126/0x320
>      __submit_bio+0x2ec/0x3a0
>      submit_bio_noacct_nocheck+0x572/0x890
>     [...]
>
>    value changed: 0x0000000000000078 -> 0x00000000005fe448
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid1.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
Applied to md-7.2

--=20
Thanks,
Kuai
