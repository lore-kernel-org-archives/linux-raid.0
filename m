Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A75A348883
	for <linux-raid@vger.kernel.org>; Sun, 31 May 2026 10:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780222899; cv=none; b=GJiQObQ0hbh/O6eqekmXZTKEGgO0ihIQ5CrfvSnqSLxknAjCtHC+g3KGkkd9pHEz3zun7PEoi3nl5KSKAtwo6mMvIjSQTJ+BeVPib+VdCnxXBCdPHXOx7XMce0XlUzosfi1zp6fU8d48j/CQzUhab1a/62CrN+90o0BcHT9e47g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780222899; c=relaxed/simple;
	bh=LxUVujT/JvJflGlOIRiAGtPpRmiZoNTFPjvzto5pZVI=;
	h=Cc:From:Message-Id:In-Reply-To:To:Subject:Mime-Version:References:
	 Content-Type:Date; b=I6g0gR1f7Ymz7cScpUbgF5rPGY8Yfph0RLxPM4Pj+HSBeff2EJ9wT3wCbSlcyvdUPh0qwuUa43Gho8+yua61j5a28nrmZSMpeB//RnjZTIrM70rCCklOSgwPrdXrZIPuAUct0Q/7eheqkecmdITCc97rFPSdfCCzljPGJbrvA3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=OJJuW3aZ; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="OJJuW3aZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1780222886;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UTL/B/skHuUid09qAIk8RUYGQS1Lj2UJVoinAzj1hoc=;
 b=OJJuW3aZuu2Rxabaqq67b891lSMwJ5suQF+d6kcJXu71xxfklBm6nghI6c4ULfzgA7mTAx
 xYEBxiWlNAUWB1pLbR131KAFOGrDxbmo9Kmwn7riYAmw+U1Qe2Yoq7TZY7Q6UJ+/nwQLXC
 ArfGGH5zuTZ39RCcpTDWikiZojhKc+CD+jIEt9tr7ZbWk4spPpYwRYnESLJ2GJQt5SW+eN
 xyAlfIC6ImFUsUNe2AmsJjxahKChLb49VZ+jBFH6uVHBJcgx54UnQ+S9k3dUEbdznasJyg
 gwBc1TRv/ZBiOtr9cv9dFCYrWS397VOVOyqsGqLVs5Udw2eVMKDtBRnyOF3PsQ==
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "Yu Kuai" <yukuai@fygo.io>
Message-Id: <b2039620-0d48-427b-aeea-16edc06b4f92@fygo.io>
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <20260530151411.4119-1-abd.masalkhi@gmail.com>
Content-Transfer-Encoding: quoted-printable
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<yukuai@fygo.io>, <john.g.garry@oracle.com>, 
	<martin.petersen@oracle.com>, <axboe@kernel.dk>
Subject: Re: [PATCH] raid1: fix nr_pending leak in REQ_ATOMIC bad-block error path
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260530151411.4119-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a1c0ba6+1802f6+vger.kernel.org+yukuai@fygo.io>
Date: Sun, 31 May 2026 18:21:17 +0800
Received: from [192.168.1.104] ([39.182.0.134]) by smtp.larksuite.com with ESMTPS; Sun, 31 May 2026 10:21:25 +0000
X-Original-From: Yu Kuai <yukuai@fygo.io>

=E5=9C=A8 2026/5/30 23:14, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> In raid1_write_request(), each per-mirror loop iteration begins by
> incrementing rdev->nr_pending. If a REQ_ATOMIC write encounters a
> badblock within the requested range, the code jumps to err_handle
> without dropping the reference taken for the current mirror.
>
> err_handle's cleanup loop will only decrements for k < i and
> r1_bio->bios[k] is non-NULL. The current slot is therefore skipped,
> leaving its nr_pending reference leaked permanently. The reference
> prevents the rdev from ever being removed, since raid1_remove_conf()
> refuses to remove an rdev with nr_pending > 0.
>
> Fix this by calling rdev_dec_pending() before jumping to err_handle.
>
> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
>   drivers/md/raid1.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
Applied to md-7.2

--=20
Thansk,
Kuai
