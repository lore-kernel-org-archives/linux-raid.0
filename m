Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEBF470440
	for <linux-raid@vger.kernel.org>; Fri,  7 Aug 2026 11:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102745; cv=none; b=t2aK/Rz8S/kU/gXE3mnh8oVNyaV6s2UYpauj31feGOz9BNDH5cTeRcHae2Fw8jcZqDV1J6A9XQvVUVic5tnqcI2iQ54yfiVUERVHGs2BcWWuyuP5oWLQe9tAy/dQpcORX8NTv/nGy1sBZABiku9QYx9OuKwgOYuabUNCwDFUeak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102745; c=relaxed/simple;
	bh=WT8l9WHPmdXo+70MAIyVUKDrmErJu545N45huh8+Nu4=;
	h=To:From:Subject:Date:Cc:Mime-Version:References:Content-Type:
	 Message-Id:In-Reply-To; b=J9XwXL2dIMmUVpo4oZ03PuDq7DHu0h/Ww4zgbUMy3lC1lSWaiEFxzjWeX/ke8YqmX5p7xDeYoRzd5NTmv70k3Q+EsfscWh4EqYDl7JlcpKGzm5wf5gjEnHzQYuB+6/7hNu9Md1Qtsiro6CPFjZ8OGm3ceKBwRhXrvhdKy6Vhycs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=SQo1VNsa; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="SQo1VNsa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1786102732;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Vj3jtAemr8HDmFHHf1O/KvUyNKFyYPZ/oQbP3XLpuBQ=;
 b=SQo1VNsaP5rzDiMUFSjXb0ul7czS/Q/5ADVB4OjYyyrSACMjIHpGYjneY2Wjr2jE3egjV/
 4QwHzxLEh270y8FkLIsI4UkIJEG6wDQjvD2wcPWZza8y4omzSNMvBFPjNQ28SVXTeb/luo
 jlaz6AKfCNIMvdK/823cNibW+A3ienl1rUkKxRYlPdog+vyUe1XImx2z63ZyHbGKUDU10a
 LFROo2h66XOW6GS7HnYTRuqOeOxcbHmt4DdCW2WU8MyMOytYNjltB7VQpitLDYygr+lDYY
 P05OucNSPRFqgxRZZyniurKqrbrXXafoMF25IBiiSSfjhAGF0odz2Kej5z6ahg==
Reply-To: yukuai@fygo.io
To: "Bruce Johnston" <bjohnsto@redhat.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid1: don't set array_frozen in raid1_takeover()
Date: Fri, 7 Aug 2026 19:38:47 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a75c3cc+dd776e+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260803180240.1177104-1-bjohnsto@redhat.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <b43300cf-953a-4374-ab5f-ac5f98cde48a@fygo.io>
Received: from [192.168.1.104] ([39.182.0.170]) by smtp.larksuite.com with ESMTPS; Fri, 07 Aug 2026 11:38:51 +0000
In-Reply-To: <20260803180240.1177104-1-bjohnsto@redhat.com>

=E5=9C=A8 2026/8/4 2:02, Bruce Johnston =E5=86=99=E9=81=93:

> raid1_takeover() sets conf->array_frozen =3D 1 on the newly-allocated
> r1conf and nothing ever clears it, so every I/O to the array stalls
> permanently once _wait_barrier() sees it stuck at 1.
>
> This used to be harmless: level_store() called mddev_resume() right
> after pers->run(), which called raid1_quiesce(mddev, 0) and cleared
> array_frozen back to 0 regardless of what raid1_takeover() set. Commit
> b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removed that
> quiesce(mddev, 0) call, so the pre-set now sticks.
>
> setup_conf() already zero-initializes the new r1conf via kzalloc, so
> just don't set array_frozen here.
>
> Same class of bug as commit 892da88d1cd9 ("md/raid10: fix a
> 'conf->barrier' leakage in raid10_takeover()"), also triggered by
> b39f35ebe86d.
>
> Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
> Link:https://issues.redhat.com/browse/RHEL-191802
> Signed-off-by: Bruce Johnston<bjohnsto@redhat.com>
> ---
>   drivers/md/raid1.c | 2 --
>   1 file changed, 2 deletions(-)
Applied to md-7.3

--=20
Thanks,
Kuai
