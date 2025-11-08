Received: from sg-1-13.ptr.blmpb.com (sg-1-13.ptr.blmpb.com [118.26.132.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30141FCF41
	for <linux-raid@vger.kernel.org>; Sat,  8 Nov 2025 10:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762596139; cv=none; b=dATB86uWHe6JbzuPl67ALRms9/B3DDv/vQPlUc7waHPkfstrXmY8Am4vLV+WSK+WVVHOh7wGD4VPh7UDVGL0ZEIQoB9u07O5jeyu9OGDWbDn9yCcm3smZY5HC1QX2FwF3fiN3VLPSg1H3Dz0+XKTJut8m5gMd2WZ6qHmOFrio4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762596139; c=relaxed/simple;
	bh=9Hgl357mNt2GG/CIuXhbcPB4M+phwxb6IBIO2FyiNXI=;
	h=In-Reply-To:To:Cc:From:Message-Id:References:Content-Type:Subject:
	 Date:Mime-Version; b=GCbto+FKHf/aR4Uyurmp0TJYWI25t1V4LG0HqSZvYx7aQlL0er6HhHnH+hpRjNbAcQ5xrXgn0PrmU0dC/vkn2zFwjyj0nwZHlaL2Ma7whNUed5OA38BKf9HEiDeJRt0icE9XH/c+FIA6LWjG5eEpVwbxqUfD9XS0+n1yS17Jgbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=b0qVN2En; arc=none smtp.client-ip=118.26.132.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="b0qVN2En"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762596123;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=rYPdsycX/7NnC/4/QzWKifIGYh4RhCN2Wv2r2vLsVN0=;
 b=b0qVN2EnszWwjInBiQi1qAVGXBEbu6B/NO4NfDByxSfG7cZ/GfwjK9nP6nfFzXorYLLMJi
 f99pXDzboTSgGjbsonYX9/ZHsBC6ojdNJ+/mDdaYzFlI4cJxudezwqWhIRHw0iNN+fuHHR
 xr3x5Jb28dp+eRSJkkMj6XcIm4VafaTxJ0ZkJbjQvygsyN399tUVkP1DOM0gz23KtIroU6
 61EPdxNIPxXr4eG8uH7A4NTkNV5XDg+VJJGt5w7nhRI/1PzjHUPUDql24i1kC8JCGZUIM4
 YWb0aqsP6/awiEv7WonQK81qxul6LGZ/JnYFofFpchSBrqWQMuP7hmroXQ3qTQ==
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251106115935.2148714-2-linan666@huaweicloud.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<xni@redhat.com>, <k@mgml.me>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Message-Id: <8e564dcc-8bdf-4fc7-a8f0-4c0c7d3547cb@fnnas.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com> <20251106115935.2148714-2-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Organization: fnnas
X-Lms-Return-Path: <lba+2690f151a+36e93b+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH v2 01/11] md/raid1: simplify uptodate handling in end_sync_write
Date: Sat, 8 Nov 2025 18:02:00 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Sat, 08 Nov 2025 18:02:01 +0800

=E5=9C=A8 2025/11/6 19:59, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> In end_sync_write, r1bio state is always set to either R1BIO_WriteError
> or R1BIO_MadeGood. Consequently, put_sync_write_buf() never takes the
> 'else' branch that calls md_done_sync(), making the uptodate parameter
> have no practical effect.
>
> Pass 1 to put_sync_write_buf(). A more complete cleanup will be done in
> a follow-up patch.
>
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/raid1.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)

LGTM
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
