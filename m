Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD336B06D
	for <linux-raid@vger.kernel.org>; Sun, 22 Mar 2026 18:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774204351; cv=none; b=DanfKlClNGLERJj3paIox3HyZyuT8GwSPeX9QnBVtoWIl33tgGEfCYlOGjeZzQ84YU+tbChUxQmfSrnH9NeniObho0YLQkMH1UDVuwqwEJeH5EAQZ51JL38IICIaCW6GA9HtF1/rnJLdLpGbgjZoLhZ5lGnzuOcWyffZDkI3wPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774204351; c=relaxed/simple;
	bh=b6zoHGNIUd9Yj9oZJgWdQ25RO3n1Bw1TWHKN9KvniQk=;
	h=Message-Id:From:In-Reply-To:Content-Type:References:To:Cc:Subject:
	 Date:Mime-Version; b=Vw8fLmzWUCvBjklbIm8Z2Uq++kNR0KV9QUl5hqC6DdibxAyLSgCnZYxFBpH0J9mQU/DQPyiZ9kYdoyKRhG5IY2OvoOQM4+Y9tGeUKApfn9kIISmlDwmeSPB87qlpublmMp8s3Djmzepr0uHeaja4q96SbOSSD2RBWodzYrfOYqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=JnxTdzGE; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="JnxTdzGE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774204342;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UDsST8nY1v79sYbL0CVH8MXzz5Zz9phnijXPkGOzNYs=;
 b=JnxTdzGEky5Epq1gRZ3hTNjIHdx7k/qvQbYzIUu+Qn9DQF5k3H+eBrAxR1kllsBD1w3Fdq
 flfSxHQ0A77KWr0Yt7ISW6ceLAGYE1DLGrzBG7nRw9Fc8K0HsrEjXE1+b4nA0fM8BNBTob
 35BWkxZa+/20FjLceXoO1lshbe8tnc1F/mj5JsPZJ/FFli+u0LaUiuo+Xtu9Nr6xtAji8c
 gMDZt7l7S20/a/tanJ9tUU6bmVfodgTelx1kkaq6mKFHgpjilQjsnx5TMjekhGvumBYMCN
 LEBYGt+dJh0Ra7t4CMG0nXrTuE538uszQabckfOpk1+24VNa2Rgx0/G5+TfZ9A==
Reply-To: yukuai@fnnas.com
Message-Id: <1bc00d97-ace7-4911-8805-a72a0a605af6@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
From: "Yu Kuai" <yukuai@fnnas.com>
In-Reply-To: <20260304111417.20777-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
X-Lms-Return-Path: <lba+269c035b5+be8ce7+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.158]) by smtp.feishu.cn with ESMTPS; Mon, 23 Mar 2026 02:32:20 +0800
References: <20260304111417.20777-1-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
To: "Chen Cheng" <chencheng@fnnas.com>, "Song Liu" <song@kernel.org>, 
	<yukuai@fnnas.com>
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] md: remove unused mddev argument from export_rdev
Date: Mon, 23 Mar 2026 02:32:18 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

=E5=9C=A8 2026/3/4 19:14, Chen Cheng =E5=86=99=E9=81=93:

> The mddev argument in export_rdev() is never used. Remove it to
> simplify callers.
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/md.c | 28 ++++++++++++++--------------
>   1 file changed, 14 insertions(+), 14 deletions(-)
Applied

--=20
Thansk,
Kuai
