Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4112E7BD6
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 07:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768807294; cv=none; b=pG3ii/IP3hPSyviZD0Wt36H++xO7yfRT8D67NBN8UOOhJphrG0MIPQBeqfOCpf22djhAC3BmUOljKBmFzDYZJw4/Y8sFPUQZMB1Aep8xmslElczeo/RIiXUHVfgpfYiF88BRpF+G4a3Gw+cHx0y3oaoZrS78EQNQs9bZJG8JCjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768807294; c=relaxed/simple;
	bh=Fef7fFS/lcK/APg/B8aOt79iN7PTX//T65CiFgIHQ9s=;
	h=From:In-Reply-To:Subject:Date:Cc:Message-Id:Content-Type:To:
	 Mime-Version:References; b=e7z5dKmMeT4HRmVLhmyLcUvqaB5JsuDiWsgDffi24OiPhM+hUfLhiY1Rb6CDs2FKzzrY9h4E6VmnCj+RxqgiVwfMzOG20I5e1S/IBFaumoVslQYfVTVccLbHS7GrJ8r0YRrjeN0iG8qKYbA+9mczgg7JFWPtzC34x1gTGu9VKrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Q+SVUnES; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Q+SVUnES"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768807278;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Q4OEzOTfi5PsFcF4c/Lc5egzQX97b6NRPaiDtBYPLQs=;
 b=Q+SVUnESWjBj6PB3jPmeHgUHiYHAXbEHuAbzAbKK3hKJPIDuo3zE6y5Cmx1D4aenjbCGUt
 BADN8gQilYYfuK+9ujkU2wV5GOZmfIoqt2THtYtyw61L3SqRwOCIl3sikrKCdoGmrTB5M7
 grAwUuYkXMiHvFgV5iNTfXDjupdJE5uDDje/oI7K3ODArPTDJvtfI2alnJMvkimexoIapJ
 BTGIBXdWNHLV2wZ4dUBLEUqWEVTXifjYx1pVTxfaLjjH7nN6GtQGbYMQfGwx0FWHuVNhOE
 TViqUCaFOHt6Bocfi70FgaKEveXq8N9kqhN92vPOUyRzzIlb8DldN48SicDF/g==
From: "Yu Kuai" <yukuai@fnnas.com>
In-Reply-To: <aW3Tc66fqSwv319o@infradead.org>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH v5 07/12] md: support to align bio to limits
Date: Mon, 19 Jan 2026 15:21:14 +0800
Cc: <linux-raid@vger.kernel.org>, <linan122@huawei.com>, <xni@redhat.com>, 
	<dan.carpenter@linaro.org>, <yukuai@fnnas.com>
Message-Id: <f7ba27c9-fc7b-44d5-9ddd-2bfb370e29d3@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.feishu.cn with ESMTPS; Mon, 19 Jan 2026 15:21:15 +0800
To: "Christoph Hellwig" <hch@infradead.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260114171241.3043364-1-yukuai@fnnas.com> <20260114171241.3043364-8-yukuai@fnnas.com> <aWpUYD1D1n-HJR9u@infradead.org> <df394803-b5fe-484f-a12d-dd10645d7a04@fnnas.com> <aW3Tc66fqSwv319o@infradead.org>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
X-Lms-Return-Path: <lba+2696ddb6c+d6aa44+vger.kernel.org+yukuai@fnnas.com>

Hi=EF=BC=8C

=E5=9C=A8 2026/1/19 14:47, Christoph Hellwig =E5=86=99=E9=81=93:
> On Sun, Jan 18, 2026 at 07:40:23PM +0800, Yu Kuai wrote:
>> No, the chunk_sectors and io_opt are different, and align io to io_opt
>> is not a general idea, for now this is the only requirement in mdraid.
> The chunk size was added for (hardware) devices that require I/O split at
> a fixed granularity for performance reasons.  Which seems to e exactly
> what you want here.
>
> This has nothing to do with max_sectors.

For example, 32 disks raid5 array with chunksize=3D64k, currently the queue
limits are:

chunk_sectors =3D 64k
io_min =3D 64k
io_opt =3D 64 * 31k
max_sectors =3D 1M

It's correct to split I/O at 64k boundary to avoid performance issues, howe=
ver
split at 64 *31k boundary is what we want to get best bandwidth.

So, if we simply changes chunk_sectors to 64 * 31k, it will be incorrect, b=
ecause
64k boundary is still necessary for small IO.

So I'm not quite sure, are you suggesting following solution?

Add a max_chunk_sectors, and in this case it'll be 64 * 31k, for I/O:

1) First check and split to chunk_sectors boundary;
2) If I/O is already aligned to chunk_sectors, then check and split to
max_chunk_sectors boundary(BTW, this is what this set trying to do);

>
--=20
Thansk,
Kuai
