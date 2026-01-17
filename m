Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF87E136351
	for <linux-raid@vger.kernel.org>; Sat, 17 Jan 2026 03:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768620552; cv=none; b=LoGo4lTM6T3o7ZiE8PCR9BfDqaaO0FTlm+oJ6NvhNzmtT6Z7Gls4JYXwnGOycPIYoXJZawjJftDbOFVI01w45wXGVAcX+nEQLCagdYVPxzTYaRYmwmx0BayAaZpCFzZf/dgG/s/dZ6laVYTp4j+dN8l8q3njgld0YMDSBWeYAq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768620552; c=relaxed/simple;
	bh=gkrEMVR3ixstplNUoFSNELjOiiXYF28smfn9R7EXhyc=;
	h=References:To:Message-Id:Date:Content-Type:In-Reply-To:From:Cc:
	 Subject:Mime-Version; b=pvbtgzZ4mBq3luz59qlCWbIhi14ghm4X5iZYcbxiq2miy3M8ZOXjWt9EPkG5Klk7XBKDmlJkQdqOWoSoXpy3aNAuNw/7eo3ZOHdkMTo848yzJDrL1l4Vic5JByHcqS2RqBmhk9JsvxY7Aofl0mTJENV1TYZGA92MvXtNPy/FglM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ZbvJqM/o; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ZbvJqM/o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768620543;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=gkrEMVR3ixstplNUoFSNELjOiiXYF28smfn9R7EXhyc=;
 b=ZbvJqM/o+Bm9CS1eTd9kkHQnnalh3ri/gi5I7Qhh1A1KOavGVWC1oUUnu/iayKjyGkT596
 Rb556c7/umSsKRxt5P6588lUmGceUzs/DD+2EwCctoR7ueoQ1nAEV88hEq+6US5P+uLuxl
 T3iRW+FZC4Xg5kBWANeF2T1+sNLIiSJVGvDotGtjbhCdXudUhKKhZDKkHpudt/PB6kVA56
 SPfv7maRRP3JbJlOSJ5txcxAUWrxOraJNztJ3tZ/AFH5td4LxikDcuOVYEVUn+t2AiUWXs
 k2JTJzGCoRfttt656mOE6wdeDWpbVSfKRO/PEyWbyaXMHO2y/tXA7I6wXSJRLg==
References: <20260114171241.3043364-1-yukuai@fnnas.com> <20260114171241.3043364-13-yukuai@fnnas.com> <aWpUgGsZ7yvnnkgo@infradead.org>
X-Original-From: Coly Li <colyli@fnnas.com>
To: "Christoph Hellwig" <hch@infradead.org>
Message-Id: <BDF73A40-1E2F-425F-8D79-4C6ADCB7566D@fnnas.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
Date: Sat, 17 Jan 2026 11:28:49 +0800
X-Lms-Return-Path: <lba+2696b01fd+6e4b0d+vger.kernel.org+colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <aWpUgGsZ7yvnnkgo@infradead.org>
From: "Coly Li" <colyli@fnnas.com>
Received: from smtpclient.apple ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Sat, 17 Jan 2026 11:29:00 +0800
Content-Transfer-Encoding: quoted-printable
Cc: "Yu Kuai" <yukuai@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<linan122@huawei.com>, <xni@redhat.com>, <dan.carpenter@linaro.org>
Subject: Re: [PATCH v5 12/12] md: fix abnormal io_opt from member disks
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

> 2026=E5=B9=B41=E6=9C=8816=E6=97=A5 23:08=EF=BC=8CChristoph Hellwig <hch@i=
nfradead.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, Jan 15, 2026 at 01:12:40AM +0800, Yu Kuai wrote:
>> It's reported that mtp3sas can report abnormal io_opt, for consequence,
>> md array will end up with abnormal io_opt as well, due to the
>=20
> How do you define "abnormal=E2=80=9D?

E.g. a spinning hard drive connect to this HBA card reports its max_sectors=
 as 32767 sectors.
This is around 16MB and too large for normal hard drive.

Coly Li
