Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0863727991E
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 07:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768808633; cv=none; b=cI7X+Ce6dehpIBG+Ded226LFmcigFncDDfD0nv0h4uroFNykce76uFJOHoZcA5riCNLzEqnMiLRquwe1fXrkOVNxJmg4yr5yA+g+1tjLDO+rotLPiRHNQRfIVIcjTpTSeeYKbooURiYaezl8O3y5UisV6xbwqUvuDOcK5SnfTOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768808633; c=relaxed/simple;
	bh=hCCndSOfqNPdKrQmKvy1kDHTbXbtgN3kwv6ixuWL1Gw=;
	h=Cc:Subject:Mime-Version:References:Content-Type:In-Reply-To:Date:
	 From:Message-Id:To; b=i8FEmEpFGV7qBQ7eySI8NWSApZ4Jt0uwCp3fw/ZFwnARnT+ZDsSW17GoyV9KBv1bzteU4XOn4lDX8CC73JKtVwa2IF/p68JLsz/7tjf73Isv35RES164buwLz/96CHVTOthGCiWT4CH2178O2otbXSLh0IFpvRw1U2SsRN6LMI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=R8Tfw2D0; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="R8Tfw2D0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768808618;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ICPM1D9g397gu/+6fpZ+IFnLawzhAcYRfYWt/YKQiWQ=;
 b=R8Tfw2D0QMe1I7E2n6amjJbGsX8xFDZJCKTFK9zrQwL2FORhnVee4UW6Fn8vWvZKi9zTsF
 kUOiXd0LQprjR9VXCa76QP4Zj28sAo+M8v01NXyRXoEb5n2vuPmU/7hehOhNuN8x0naONv
 QjQlqek0m0GF+lCKoJIIDPkcr9XjCIDSXjsbFNamm/yEMFfLU0DQwAsAP/7VYFRMz3GHqA
 U4paV/KM/8jaUhKE7dtRc91Th1Ecj0rEIcpwKjf7fgJsaIvak4MqpFEDt6zKoUGI+O9axx
 zjFOkeCJ6sCY3o3eXLEQIMV+/KJS22F6gEKrgbeLvw0VJsSFGiTWS+9remLkcA==
Cc: <linux-raid@vger.kernel.org>, <linan122@huawei.com>, <xni@redhat.com>, 
	<dan.carpenter@linaro.org>, <yukuai@fnnas.com>
Subject: Re: [PATCH v5 07/12] md: support to align bio to limits
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260114171241.3043364-1-yukuai@fnnas.com> <20260114171241.3043364-8-yukuai@fnnas.com> <aWpUYD1D1n-HJR9u@infradead.org> <df394803-b5fe-484f-a12d-dd10645d7a04@fnnas.com> <aW3Tc66fqSwv319o@infradead.org> <f7ba27c9-fc7b-44d5-9ddd-2bfb370e29d3@fnnas.com> <aW3cxxnbRmon9aYJ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.feishu.cn with ESMTPS; Mon, 19 Jan 2026 15:43:35 +0800
Content-Language: en-US
Reply-To: yukuai@fnnas.com
In-Reply-To: <aW3cxxnbRmon9aYJ@infradead.org>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+2696de0a8+c678b5+vger.kernel.org+yukuai@fnnas.com>
Date: Mon, 19 Jan 2026 15:43:34 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <8b44bd64-efc8-428a-ad2f-9a9fcda786a1@fnnas.com>
Content-Transfer-Encoding: quoted-printable
To: "Christoph Hellwig" <hch@infradead.org>

=E5=9C=A8 2026/1/19 15:27, Christoph Hellwig =E5=86=99=E9=81=93:

> On Mon, Jan 19, 2026 at 03:21:14PM +0800, Yu Kuai wrote:
>> Hi=EF=BC=8C
>>
>> =E5=9C=A8 2026/1/19 14:47, Christoph Hellwig =E5=86=99=E9=81=93:
>>> On Sun, Jan 18, 2026 at 07:40:23PM +0800, Yu Kuai wrote:
>>>> No, the chunk_sectors and io_opt are different, and align io to io_opt
>>>> is not a general idea, for now this is the only requirement in mdraid.
>>> The chunk size was added for (hardware) devices that require I/O split =
at
>>> a fixed granularity for performance reasons.  Which seems to e exactly
>>> what you want here.
>>>
>>> This has nothing to do with max_sectors.
>> For example, 32 disks raid5 array with chunksize=3D64k, currently the qu=
eue
>> limits are:
>>
>> chunk_sectors =3D 64k
>> io_min =3D 64k
>> io_opt =3D 64 * 31k
>> max_sectors =3D 1M
>>
>> It's correct to split I/O at 64k boundary to avoid performance issues, h=
owever
>> split at 64 *31k boundary is what we want to get best bandwidth.
>>
>> So, if we simply changes chunk_sectors to 64 * 31k, it will be incorrect=
, because
>> 64k boundary is still necessary for small IO.
> What do you mean with "necessary for small IO"?

io_min and io_opt is quite similar in mdraid, IO aligned with io_opt can ge=
t the best
bandwidth, and IO aligned with io_min can get the best iops. Currently chun=
k_sectors
is the same as io_min, and bio_split_rw() will try to align IO to io_min. I=
 don't think
we want to remove this behavior.

>
--=20
Thansk,
Kuai
