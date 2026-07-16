Received: from va-2-19.ptr.blmpb.com (va-2-19.ptr.blmpb.com [209.127.231.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27682EDD78
	for <linux-raid@vger.kernel.org>; Thu, 16 Jul 2026 09:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193925; cv=none; b=U5xHqN7C9vI1lhEeWCIR4xwI84Q07sgDb9qi+WfnDYFxrDBDeeZayFmyNYKfHBb0Ja0xrMvmfI4VkIEDYjJYd3xuN2D5du3oWbBQsSQFAMuNMWZD2FXcMjzlAVxyhzLwpG4SbKIgaHsMfwIZP70rkI0OQlbnPcC/AI4q7FFSk9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193925; c=relaxed/simple;
	bh=toCBGIMJj3MNnqRwHfYy/aN1HypA8d/Nm7FgrIH9F7Q=;
	h=Subject:Content-Type:Message-Id:Mime-Version:References:
	 In-Reply-To:Cc:From:Date:To; b=u6X9QstZ49y+gsVJCjBupY4n5oLPeEay0bX4rfM3nXJSPfjYxigcUxiVsmx7XssZCKnIv1Tjr1S4uGk+l6TiO0rOmZZzD7DNiecgbPDxgn4FmlF99pt9I6zuk76DK+1Y8yDvDMMpqYK2un3P5XdKYKscj+BB3J4E4jYzFrMCobo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=B55khWLw; arc=none smtp.client-ip=209.127.231.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="B55khWLw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784193915;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0bggss4ERdj20SIN5YVh0zguosiYGFVOtbOiE7jfwvk=;
 b=B55khWLwZLoebQbfaEkSUq5HkLRQBGGiiMpavvM2t8pI6VxRgHK7S3hU+3DLGJDCFm+pvk
 yM/yw2j2WJEkkKp6kxy9Sn0rzVQwh7WhI8bfV2EGX5eKUhTdQ5AlS2Pmm0v8K7OJTGM4fz
 Eg9grcZqrtgjfAb9ZN1fjBHhCFRlCAr+eJ3t1+oGDcez+LwAX7TjMJNWRrFZ6ryB3+8Apa
 oZrIwgke6dXq4dvkkax7F+ROHdUnJY5FO0gJFbB+mxWPQaVXD7O2u7PF1maDoa27lEWDCt
 KV01ZwjqTB2oRdGd4mjtXSbc/3UYj+kPeZqjRC81U7cjc8W52krgVyr8tNtgmA==
X-Lms-Return-Path: <lba+26a58a37a+76d17d+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Thu, 16 Jul 2026 09:25:14 +0000
Subject: Re: [PATCH v4 5/7] md/raid10: replace wait loop with wait_event_idle()
Content-Type: text/plain; charset=UTF-8
Message-Id: <b1de7d3f-cac6-48c4-9daf-09a14b176719@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
References: <20260710101521.1714-1-abd.masalkhi@gmail.com> <20260710101521.1714-6-abd.masalkhi@gmail.com>
In-Reply-To: <20260710101521.1714-6-abd.masalkhi@gmail.com>
Cc: <linux-raid@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Date: Thu, 16 Jul 2026 17:25:10 +0800
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <axboe@kernel.dk>, 
	<vverma@digitalocean.com>, <john.g.garry@oracle.com>, 
	<martin.petersen@oracle.com>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>

=E5=9C=A8 2026/7/10 18:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> The wait loop is equivalent to wait_event_idle() and can be simplified
> by usaing it for improving readability.
>
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
> Changes in v4:
>   - No changes.
>   - Link to v3:https://lore.kernel.org/linux-raid/20260708101341.473750-6=
-abd.masalkhi@gmail.com/
>
> Changes in v3:
>   - No changes.
>   - Link to v2:https://lore.kernel.org/linux-raid/20260628142420.1051027-=
6-abd.masalkhi@gmail.com/
>
> Changes in v2:
>   - No changes.
>   - Link to v1:https://lore.kernel.org/linux-raid/20260623072456.333437-6=
-abd.masalkhi@gmail.com/
> ---
>   drivers/md/raid10.c | 15 +++++----------
>   1 file changed, 5 insertions(+), 10 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
