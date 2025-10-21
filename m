Received: from sg-1-23.ptr.blmpb.com (sg-1-23.ptr.blmpb.com [118.26.132.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E980E23EA85
	for <linux-raid@vger.kernel.org>; Tue, 21 Oct 2025 12:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761048381; cv=none; b=i6dNcbB8D7O1MFVSOdYNaBOXLL8wFNm6/cE4nTgVk5DOZXp9V256tznz/4CWoMkj41ubIj4Qa9vox4zZG5J847njJJmURbhfgpYQPwJQkW1g9lKU+2EzaaxN0BIYHeQ51kFhVOUtOc2Jiw0JFa5IzNdRmYwDivDnnb9ZnVhpNZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761048381; c=relaxed/simple;
	bh=ds6EQDCNZa54CyyZGfqkWP2IvmjttGoZ1ZFeHkTVszg=;
	h=To:From:Content-Type:Date:References:Cc:Message-Id:In-Reply-To:
	 Subject:Mime-Version; b=SCfWrdQtc5TSet6FjMCuQHR8AubKwkeKkbMSLn0Hx5x54GLaH65BEVGMGNRJKUjJQMb8WK2FVHFcUlP0FWURvBOzDIps4z723MgpXORR0XcdYi8OPRie1nDPfHWrTsb/Th6MB+QZdHyvJjSc7dwtetg33K6KMDohF9B6dBrz1M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=mjvGSqem; arc=none smtp.client-ip=118.26.132.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="mjvGSqem"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761048368;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ds6EQDCNZa54CyyZGfqkWP2IvmjttGoZ1ZFeHkTVszg=;
 b=mjvGSqemOtSWGFjGp1HUVaHgRljECvHGVW8tSP69i4BFqUysQrpWYweX9l3mUuIhLeJnJg
 VjZnk0PcLt0zx6uGm6qAZ7x45ibpilPl7jkDEcxelJHVVgTwwblFBzWK+1hkduQDUOHdna
 Q7+DFyQyOOVDa5iCIWFQ376qZErriWB+dGN+BrJ5RW2S2Ub8rcQU4x9kzL9Oc6NdzOFB2Y
 dZg8KoXNDcTFoQcUfe/pxq3Ot5B0Ok01t3pzGtaFv0wha3GSp8b9S53oHaItszVBshMvNV
 ZK+gp13WIoH4Oxnhq4Wr8zSkl+xN2k7EofHLvtX8JBYGTaN2rKDnJnW1dCOTuw==
To: "John Garry" <john.g.garry@oracle.com>, 
	"Yu Kuai" <yukuai1@huaweicloud.com>, <song@kernel.org>
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+268f7772e+5f57fe+vger.kernel.org+yukuai@fnnas.com>
Date: Tue, 21 Oct 2025 20:06:04 +0800
User-Agent: Mozilla Thunderbird
References: <20250903161052.3326176-1-john.g.garry@oracle.com> <b6820280-cc1f-beae-2c1c-077d46bbf721@huaweicloud.com> <557f39a4-a760-4b10-80e3-229f7a4892cb@oracle.com> <84bbff83-b5db-6789-a668-61cc5cb7c761@huaweicloud.com> <c26f4b7f-f311-4cea-88b7-d1d6905c2c06@oracle.com>
Reply-To: yukuai@fnnas.com
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<martin.petersen@oracle.com>, "yukuai (C)" <yukuai3@huawei.com>
Message-Id: <5069c55a-5b3e-477d-99ef-731bacc6c427@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.169]) by smtp.feishu.cn with ESMTPS; Tue, 21 Oct 2025 20:06:05 +0800
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c26f4b7f-f311-4cea-88b7-d1d6905c2c06@oracle.com>
Subject: Re: [PATCH] md/md-linear: Enable atomic writes
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Organization: fnnas
X-Original-From: Yu Kuai <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/10/20 21:48, John Garry =E5=86=99=E9=81=93:
> On 23/09/2025 10:10, Yu Kuai wrote:
>>> Could I have this picked up now? Maybe it was missed.
>>>
>> Already picked last weekend, sorry that I forgot to reply.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git/=20
>> commit/?h=3Dmd-6.18&id=3Db481e72d24feac15017b579232370aa4b33d4129
>
> This does not look like to being it into v6.18-rc - was it missed?
>
Yeah, a few patches is not pushed to v6.18-rc, because I was switching job =
and the
old email yukuai3@huawei.com is not used anymore. If you don't mind, I'll r=
ebase with
my new mail address and push to for-6.19/block later.

Thanks,
Kuai

> Thanks,
> John
>
