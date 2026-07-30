Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6245C42847B
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 12:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414045; cv=none; b=H5mt1pRdKU0SkRDXzry/BqCkDNskHsWLAVfcUf00psCoKnskL9nPToRn16eUt8Wl9+aTv8/I5PJFzOZr+z2+MN0ugpw5spcwLOJJ3ofuNAIVB9OKiCCCEraGcFLtwkUAJW0bQ4Lk0JmyR/w9AKE4wUHXHugyROGwNEIhjR9JMrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414045; c=relaxed/simple;
	bh=CczHqBSWvCR48VjEoucBf7cxlmwHOk7gS3EL/hrwV4s=;
	h=Content-Type:References:Cc:Date:In-Reply-To:To:Message-Id:
	 Mime-Version:From:Subject; b=p+HPiMppfhDlcYsqGImFeyQKrerKIKk/8UhI2gQOvhklnDJWBrvcHcxDc55JdF7r2nx3+heZ0kKtHvkfBeOrB9texEvPK2XiOSDgpvLF+TXx/o2hQhOigAHIJvLi+pXgWaG5FbXzoidbtJzYDiYzHLQkwNhEeYtu7cYj1lTMAmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=bPIIl1nS; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="bPIIl1nS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785414034;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jVFhC04+PYaAOg019N78blM/0FBci74mePMC6XgpXGk=;
 b=bPIIl1nSNrTmuwEXZ5qIoZVFhAwFCaW+I/1pWtTJJSdhcEPbXp3J37nD0vQlWhf6LjLLXE
 YuOOPuTmGqctkaHujOuUrICME1zR25tLSldTBr7c0wLimnuH9ApVE8q6QnbhoJdffp2uJq
 KEOnzUSkEVWg5Zi7jAHqiSwKJw2h4xpmr8loeGB1DCL9PUurzXQxZN0Iz1gz8d7qXuZRev
 BlDaW8UefcwqDhJMDIE1QpB0aiWxt/GWv0dkDEMyu3wmrEza42OpTKWWojt9+Slx2wTpxU
 78ZvJ2sJvNPe35peQjoYar7FBTKfR6P8MgxIzDjPsSns3y8X7w/SO6MQSKjfuA==
Reply-To: yukuai@fygo.io
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a6b4191+160127+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
References: <20260708112003.474537-1-abd.masalkhi@gmail.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"sashiko-bot" <sashiko-bot@kernel.org>
Date: Thu, 30 Jul 2026 20:20:28 +0800
In-Reply-To: <20260708112003.474537-1-abd.masalkhi@gmail.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<abd.masalkhi@gatech.edu>, "yu kuai" <yukuai@fygo.io>
Message-Id: <1d70cf5b-7519-4c95-b23a-0bdbe792268f@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2] md: recheck spare changes before starting sync
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 12:20:32 +0000

=E5=9C=A8 2026/7/8 19:20, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> remove_spares() and remove_and_add_spares() modify the array's rdev
> configuration. These operations are only safe after the array has been
> suspended.
>
> md_start_sync() checks whether spare configuration changes are needed
> before taking reconfig_mutex. However, the rdev state can change before
> the mutex is acquired, so the initial check can become stale. In that
> case, md_choose_sync_action() may remove or replace rdevs while normal
> I/O is still accessing them.
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
> Fix this by suspending the array when spare configuration changes are
> needed, including for non-read-write arrays, and checking again after
> taking reconfig_mutex. If the array was not already suspended and a
> change is now needed, release the mutex, suspend the array, and
> reacquire the mutex before continuing.
>
> Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need =
reconfiguration")
> Reported-by: sashiko-bot<sashiko-bot@kernel.org>
> Closes:https://sashiko.dev/#/patchset/20260628142420.1051027-1-abd.masalk=
hi@gmail.com?part=3D3
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
> Changes in v2:
>   - Recheck whether spare configuration changes are needed after taking
>     reconfig_mutex, and suspend the array before continuing if necessary.
>   - Account for read only arrays, where reshape_position may not be
>     MaxSector even though md_start_sync() can still modify the spare
>     configuration.
>   - Link to v1:https://lore.kernel.org/linux-raid/20260630075640.1081634-=
1-abd.masalkhi@gmail.com/
> ---
>   drivers/md/md.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
Applied to md-7.3

--=20
Thanks,
Kuai
