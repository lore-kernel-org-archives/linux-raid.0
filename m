Received: from sg-1-17.ptr.blmpb.com (sg-1-17.ptr.blmpb.com [118.26.132.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55382EFD99
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 07:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768807591; cv=none; b=hz6/Go2j1yj3/xVfiRUwxmiIM5d6IeRU55xLGePh0KsCK8QUY/Dx5Hf5pdTHuA5ietCiOhodpemxsM6aaKB1CWFGHTh+L9jRmLR+hXNK/Yi995mBrT78UDecBXkmSggfG/RAcTjHNQ5A+xtftYD264N5+szql9aGw++tml86bGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768807591; c=relaxed/simple;
	bh=73Z8boUrUXWIIwfSxhPm6bZyWrqhzLrMb2d2nLcLqgU=;
	h=From:Subject:Message-Id:To:Date:Mime-Version:Cc:References:
	 In-Reply-To:Content-Type; b=mDxqcJpZnGHeUX4C4ajHOcBon+o/KVOzWLl1CgGb/GP1VQAx1J9+KbqkWXPb3/U05GBCzALrdVkoYjvqAaaJWdQmOze7jHJuUsE+0DTyYztms3onzYHsuC4nvMkX+02Y7NZ0pJfdJZzpfQd/dOKvtlKxA3BrqaJL8pXau0/xOmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=isIzbO/n; arc=none smtp.client-ip=118.26.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="isIzbO/n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768807464;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=36qiTnpBn6wk8ZVqpH8lbhBsm47otqhoQAZDG4Zg0Jw=;
 b=isIzbO/nQAT8zXLyhQw99+roAb0CpT6V9iELmiivwgacTl4U9JBMCB+IBzvZm2eSCJ+5Ho
 ZhqaZQioAGMvQ0dC8vhsl09IBFKr2TmIDGIl2qQ762MRFH/l5UjbxKdM8YPDKPO81qRrzN
 duHdHFhAPvJzXAR2I+oQcK49UUiwWVMbGFeQqBQ+2ZKiCVX6ct9jWFNdHOu7PRc1cuVfo3
 Rv63bMYqG68+M7mD3ucWBh/szM9QgpDyaq+A8M0xqojn6NInYstk8MgZ3sbDLqKRDdNN3R
 BCrKEoa9QY1wpOigEWfnxScEDpYvCk/OiXBfxmBk//8dLX3VZ/GpAhbhfzyaRA==
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+2696ddc26+43756f+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: [PATCH v5 12/12] md: fix abnormal io_opt from member disks
Message-Id: <9642ed5f-1e60-47dd-a333-abc5cb26ebe1@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "Christoph Hellwig" <hch@infradead.org>, "Coly Li" <colyli@fnnas.com>
Date: Mon, 19 Jan 2026 15:24:19 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.feishu.cn with ESMTPS; Mon, 19 Jan 2026 15:24:21 +0800
Cc: <linux-raid@vger.kernel.org>, <linan122@huawei.com>, <xni@redhat.com>, 
	<dan.carpenter@linaro.org>, <yukuai@fnnas.com>
References: <20260114171241.3043364-1-yukuai@fnnas.com> <20260114171241.3043364-13-yukuai@fnnas.com> <aWpUgGsZ7yvnnkgo@infradead.org> <BDF73A40-1E2F-425F-8D79-4C6ADCB7566D@fnnas.com> <aW3TuktsyQ0ADte7@infradead.org>
In-Reply-To: <aW3TuktsyQ0ADte7@infradead.org>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/1/19 14:48, Christoph Hellwig =E5=86=99=E9=81=93:
> On Sat, Jan 17, 2026 at 11:28:49AM +0800, Coly Li wrote:
>>> 2026=E5=B9=B41=E6=9C=8816=E6=97=A5 23:08=EF=BC=8CChristoph Hellwig <hch=
@infradead.org> =E5=86=99=E9=81=93=EF=BC=9A
>>>
>>> On Thu, Jan 15, 2026 at 01:12:40AM +0800, Yu Kuai wrote:
>>>> It's reported that mtp3sas can report abnormal io_opt, for consequence=
,
>>>> md array will end up with abnormal io_opt as well, due to the
>>> How do you define "abnormal=E2=80=9D?
>> E.g. a spinning hard drive connect to this HBA card reports its max_sect=
ors as 32767 sectors.
>> This is around 16MB and too large for normal hard drive.
> Which is larger than what we'd expect for the HDD itself, where it
> should be around 1MB.  But HBAs do weird stuff, so it might actually
> be correct here.  Have you talked to the mpt3sas maintainers?

We CC them in several previous threads, however, they're not responding. :(

>
--=20
Thansk,
Kuai
