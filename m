Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEBE1B4F2C
	for <linux-raid@vger.kernel.org>; Sun, 23 Nov 2025 02:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763866425; cv=none; b=Jv1weaLz0mbCjE8M+q0fHlul1O4zl56Vs4AGSwjAN5kZawb2gimxKW1z18j0EEePQDQkEHfvzVjSTkzAlWr7lmhAqpdlujZyeXadt6PaBls7tomdNwfi5MdMatYQ8buBJx6JQCwW6jMYRxDXYmr/vjef6CjAp0mZvKDNfcEba/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763866425; c=relaxed/simple;
	bh=mh847J3unPTQbyMERRxaHNHORwAcSKABft1vuDCEGbo=;
	h=To:Cc:Subject:Message-Id:Mime-Version:From:Date:In-Reply-To:
	 References:Content-Type; b=IFJ9LLf+11J85LRMfZBY6Blh8DGxfm2lQrMjp/+Xk6OtTmN2ZMArQszzojamkz8FKFYb5agSkKX5p6hazVvhW5mEvhMiNQh07YEkkrtZoHezqHXH/G9gPrOvYXZ83xoswdOjbUw3PrVtfjOHGh9zh2wHhafny7oYdPkdPwHYC8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=rwdmSz5J; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="rwdmSz5J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1763866373;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=pc4oT0JK2ddakBfHidEKm10PDuZ0LU4qZLBDpU95TcU=;
 b=rwdmSz5JqwtPkLLgKt9jWHfNkR+LFBJ4Cb6nnXfdLNE81kdAZb4DwtBbhTC2b5aFDm6GzP
 rN/xRbWDp7f7bWN+oRt6wb4s1oWdOO7YH4fv/bA2uBNtKRoPMB9c6/FYMpHwXAvPThq/7M
 JySenj9BTzGaFBISUjzUlIfLX8cGmqjeGzGy7aoqZsUd9D7vQY72mGDTq3rmg/anJhK61O
 NkWkmcCmzN8/QPGnj11hvbpGAisEq2OJbD72Zoxq6+UI989CBbfCSKk+9SItaJeYvdyG13
 r2jNBnMP5+DgV4Ar6DrZaoConrMEQKrNRuKn5k0gmWay1shdwJv/Dnufvrf5nw==
Reply-To: yukuai@fnnas.com
To: "Tarun Sahu" <tarunsahu@google.com>, <linux-raid@vger.kernel.org>, 
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<song@kernel.org>
Cc: <berrange@redhat.com>, <neil@brown.name>, <hch@lst.de>, 
	<pasha.tatashin@soleen.com>, <mclapinski@google.com>, 
	<khazhy@google.com>
Subject: Re: [RFC PATCH v2] md: remove legacy 1s delay in md_notify_reboot
Message-Id: <5b448039-a4c0-41b0-89d8-af0aec3e76be@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Sun, 23 Nov 2025 10:52:50 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Sun, 23 Nov 2025 10:52:48 +0800
Organization: fnnas
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251121191422.2758555-1-tarunsahu@google.com>
References: <20251121191422.2758555-1-tarunsahu@google.com>
X-Lms-Return-Path: <lba+269227703+63fb3e+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2025/11/22 3:14, Tarun Sahu =E5=86=99=E9=81=93:
> During system shutdown, the md driver registered notifier function
> (md_notify_reboot) currently imposes a hardcoded one-second delay.
>
> This delay was introduced approximately 23 years ago and was likely
> necessary for the hardware generation of that time. Proposing this
> patch to make sure there are no known devices that need this delay.
>
> Signed-off-by: Tarun Sahu<tarunsahu@google.com>
> ---
> v2:
> 	Added linux-scsi mailing list
>
>   drivers/md/md.c | 11 -----------
>   1 file changed, 11 deletions(-)

LGTM
Reviewed-by: Yu Kuai<yukuai@fnnas.com>

--=20
Thanks,
Kuai
