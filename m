Received: from sg-1-33.ptr.blmpb.com (sg-1-33.ptr.blmpb.com [118.26.132.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96923D564B
	for <linux-raid@vger.kernel.org>; Thu,  5 Mar 2026 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731917; cv=none; b=jzXji2gbkkLQ+R/3qgx8IyMdWnoaFLFGFfRFxPPN9NdZ6FiaWE1yKWrjP5dpkWOo8eY/i612PtaTF7FCNkAMwU9trAEsLB3EnJ9UeHOYpISl+niaFHoEi533Cq73NLGKHdGCHoQu7/X5KIZT5SeB/I2oeIvIBtXNznHxuMgy5Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731917; c=relaxed/simple;
	bh=wKerzeUjCRw3P3s+jjIvX12svchWsLwwviiYdLN+ANQ=;
	h=Mime-Version:References:Subject:Cc:Date:Content-Type:Message-Id:
	 From:In-Reply-To:To; b=uafRUGpKoWbG/eC6toW2z6EJhIjjWHwvxM1yZVYCo3E3cviTY+YUlmYIEPR0IxjJDoCgUoHO3Vu3DzAheMvmouuTH/NwlK/uya8+UkjaJYBOGInm0wQQF+g/E2iRABjOCiT2raoBbFWrDUWJdho8jz314TWPWlRfDZsY5QHKKU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=hMozYoJ0; arc=none smtp.client-ip=118.26.132.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="hMozYoJ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772731904;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ukQgBz6w9t7VXQKpZjnWjKWekptfw0GYDYW5hdxAoaI=;
 b=hMozYoJ0Etp2K2Ei+ESXEjASOgrVb9C2CEu12jzGaOjwBTR5wfqhzWrEQPjj8FALW8L9k9
 fEKftifn2mbNCe2pqkGAahlSPL4nthVnXTyjxDflbvpmkuUdyRGrSNcqi4dreGNkoh6biA
 Fo63AJ5Kv9xye/MT1R/FgJtdlug2Qzgvf//D2+yqdMvVtGny3USlneoMfjOWi6qVeuJ2LW
 9xmKdoKN/mISgCeYJREa1VSHw95hQO6IBEN8w0nsjGbaNQnVdK4uLAT54o6hHCaI+HDQYq
 faU5M3MBNIuVn96GrzuNcUV9DUOAaREOQUgEgpRb5RB+SVg9WHeOFz46t2+ycw==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.182]) by smtp.feishu.cn with ESMTPS; Fri, 06 Mar 2026 01:31:41 +0800
References: <20260304111001.15767-1-chencheng@fnnas.com>
Subject: Re: [PATCH 2/2] md/raid5: move handle_stripe() comment to correct location
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>
Date: Fri, 6 Mar 2026 01:31:40 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+269a9bdfe+d4be04+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Content-Language: en-US
Message-Id: <f9dd10e2-7c0c-4357-b91d-06fe9b42c78a@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
In-Reply-To: <20260304111001.15767-1-chencheng@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: "Chen Cheng" <chencheng@fnnas.com>, "Song Liu" <song@kernel.org>, 
	<yukuai@fnnas.com>

=E5=9C=A8 2026/3/4 19:10, Chen Cheng =E5=86=99=E9=81=93:

> Move the handle_stripe() documentation comment from above
> analyse_stripe() to directly above handle_stripe() where it belongs.
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 26 ++++++++++++--------------
>   1 file changed, 12 insertions(+), 14 deletions(-)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai
