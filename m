Received: from sg-1-17.ptr.blmpb.com (sg-1-17.ptr.blmpb.com [118.26.132.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCAA184E
	for <linux-raid@vger.kernel.org>; Sun, 30 Nov 2025 01:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764467397; cv=none; b=P6/7Nstv6VsKSqb29yANptpcaoLET+RornjI1Na3Iu+xu+G6dBy4dd3nyap8/yYAEKBBKK8KJJUp/mibApmBd0hSOyPDmXyMTk0Goj2C5c+l3eBOta+N+GKN6enyZDsDj9x4RoP1Pu/WaB15pvb5sh5Hp8BJpFr+S/WS0XrwsYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764467397; c=relaxed/simple;
	bh=3kDl5JcVyz6d4yNlhQO5SQy5fWnDJqY7KgI7OFkhLlI=;
	h=References:Mime-Version:Cc:Subject:Message-Id:Date:Content-Type:
	 In-Reply-To:To:From; b=ixmWuOWUoeCA/JeUkVUWSnBt3XtGO0cWV7BMdO//VF+/Suxo6zPWwq5G4ukWiEqknJPfo/53pXXkn8zVcTWOofODxYFB39NoVfsqDWSPShWt1aPvVqz9jXvq6Q0VALhJNgz9hSeyfHxdCTGe/NXxAzLjSYQ1fAJNOzHlI569n5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=iVYa/8Or; arc=none smtp.client-ip=118.26.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="iVYa/8Or"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764467383;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=19mcmFgmeBo4xA4G6l9XBGQmiTJWtx237WdJItP+nX4=;
 b=iVYa/8OrDzS0+JEq8WJrqNwBWMe9i+7l9mQzY+IuiQ2oDHMP9jA0r2MH4OKX9k4xsGP1cO
 f9psydzNVWdoFHBhazKOc5OlclkD1GAcmaXXQnt/IE8Gv89mEBtt1a5FXO8e2HyuFihjfG
 qi8eyph4YymR7YYnaE/BlUxNkoquSWwXQDCpebcyTu8bagS3sfZmCfNsiLThYkwQsQFVoV
 ZajhSeGqwpn2a3YHWShcHqLz2N6qNNUqItYv1mwVmVMbrZEar1Wo6uQBiiSINMfBpJvpmj
 usGVi8sgb3PifccEXiUqfIUbUHXgvj9eZ2pWy0t7zeYWZejZMLh9yzQwScP2Yw==
References: <20251117085557.770572-1-yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] md/raid5: fix IO hang when array is broken with IO inflight
Message-Id: <03118da6-8c79-4235-9818-fdb694b2e477@fnnas.com>
Content-Language: en-US
Reply-To: yukuai@fnnas.com
Date: Sun, 30 Nov 2025 09:49:39 +0800
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Sun, 30 Nov 2025 09:49:40 +0800
Content-Type: text/plain; charset=UTF-8
Organization: fnnas
X-Lms-Return-Path: <lba+2692ba2b5+e47b3e+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
In-Reply-To: <20251117085557.770572-1-yukuai@fnnas.com>
To: <linux-raid@vger.kernel.org>, "Yu Kuai" <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>

=E5=9C=A8 2025/11/17 16:55, Yu Kuai =E5=86=99=E9=81=93:

> Yu Kuai (2):
>    md: warn about updating super block failure
>    md/raid5: fix IO hang when array is broken with IO inflight
>
>   drivers/md/md.c    | 1 +
>   drivers/md/raid5.c | 6 ++++--
>   2 files changed, 5 insertions(+), 2 deletions(-)
>
Applied to md-6.19

--=20
Thanks,
Kuai
