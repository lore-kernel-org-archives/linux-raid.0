Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4C7342515
	for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 05:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785475107; cv=none; b=LCouwzu5KGcIX3ITYrooXLn5PW0zW1Ze4opLrNAGpdkCDyvsqHvMcekkt0Lw8DwTKZEUY4ZViz2ntqVLd2PWfefJthDnyaV/pV5kSMAICffdAVE2zDDSniW0DAfS3rrqrHxRa28lqnpvOiiSJsZR/EcCSWyTVDW5DClousyo1x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785475107; c=relaxed/simple;
	bh=QoL3hCfDA/YMdXcLQEIjLzdML/jMPfNmZKX8GoLCKGQ=;
	h=From:Content-Type:In-Reply-To:To:Date:Message-Id:Mime-Version:Cc:
	 Subject:References; b=r2gIdLuBm0olp5a0451kEnTXEOgU2p9M4LG0JlvrE3pX4uLRG/ymNsz+QpGPVq8LfpTsSyfvFLp9nsyZJ+UKgA41G+g8ElkrHXz/thj1JM4U7udb/AB8SBf+kPKzqtRm8wez7RmXLmwHw6I2XOEq7ugJQ3BYhZv61WjWswlLsr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RnfLewom; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RnfLewom"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785475089;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1gySXOeuiUNYTBd8Cs/vwcOoG/opGCLm1YSC4gEPkYk=;
 b=RnfLewomVyCIy0qs0A2v+I5S/s7D5EzHRHt/Rz9P08YDcRL2YFEV8zast54Es0SPezKsK9
 M7Qsj4VCOB9s0Jt9cq2euuUohdX/s3CCcvd582YOwTR0v8WFpLzwQUEGrrFEfbSm/xsuRP
 xhLAdyaKp+s0yQd7Nr+Wjd4AX3W7NyFQHYyJHmNpdojKWG2wJOVaxHG1s+vPJcUvpZqnxV
 B1+o8+BVDNhkf50hCc0N4clm0pJrUOIl+faUw1ukA9hfvNdmFm8/zRfZxBT0GSVnH3s+RG
 7I+j+Jw4cTGwctz7IpiTQ9F+Apmvt4Wbak6pF4t1XqwCHyuE1bcm+o4c0HYN3Q==
From: "yu kuai" <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260718034236.4119093-1-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a6c3011+670f8d+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Date: Fri, 31 Jul 2026 13:18:05 +0800
Message-Id: <0558f53e-270f-44b1-a952-a6135b480f00@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: <chencheng@fygo.io>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md/bitmap: resume array on backlog_store() error path
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Fri, 31 Jul 2026 05:18:08 +0000
References: <20260718034236.4119093-1-chencheng@fnnas.com>

=E5=9C=A8 2026/7/18 11:42, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> backlog_store() suspends the array before checking whether a write-mostly
> device exists. If no such device exists, the error path only unlocks
> reconfig_mutex and leaves the array suspended, blocking subsequent I/O.
>
> Use mddev_unlock_and_resume() to release both states.
>
> Fixes: 58226942ad3d ("md: use new apis to suspend array before mddev_crea=
te/destroy_serial_pool")
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/md-bitmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Applied to md-7.3

--=20
Thanks,
Kuai
