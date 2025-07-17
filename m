Received: from mail116.out.titan.email (mail116.out.titan.email [54.173.78.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0ED2F8C24
	for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.173.78.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752766066; cv=none; b=oapqIc8PouuGTdDvR47GfDs9+Aex2x3SnTvFJLGvk0lhDRPCGUbfK6Hw26axA5ycczyvVNeXonxMCyYG4wiY07p9jdWF1Z84vGaX+U25whOkoRs3y/mw3wIIfi0HYymv3THnQB2C/HenIdC3n2oYZdj+C7/KJR9iGbVtuDnq0qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752766066; c=relaxed/simple;
	bh=lCDx3xFGjTHG+lCrF+LTAb/j/3PreCnienOtmZeZwvo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=WTRQbcJC4ghfRSS0ksLpatOseyZ14DJAEBdTK7VLI2F6tNmrxAnwqvOj3qRG31TA8CdUTHLc4epYvfCcpfQ0eC/7CHjVQBNtl9FWwnMDSBe1Jwe+4hst57Zf0Df6XQAS+h7jMZw4hx7pJYgUs7fiuijwnS8466mHrqAoT3tw8Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=MKiLZpH6; arc=none smtp.client-ip=54.173.78.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="MKiLZpH6"
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 67465E005B;
	Thu, 17 Jul 2025 15:19:39 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=U8kJqlXH81v1gtyL+gZDVI2K6WZ0df1ag9Avg+G1m+I=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=mime-version:to:cc:message-id:references:subject:in-reply-to:from:date:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1752765579; v=1;
	b=MKiLZpH6uAwBw3ZjP4VkDHoQvXOT6Ht1ezRXW8BTH1cwOipa1PKO6A6Hiqj5mAZAcV65ApSq
	DgTpWAIFpKl0HXiatWsS7frooEBdhz0QTeHY3DiWDtEVIp1Ka/KnS5OcCpp6uqz5RlAC5Uwgn8B
	Q/ZZGWeC5qPr1gHeiunPmiys=
Received: from smtpclient.apple (ns3036696.ip-164-132-201.eu [164.132.201.48])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 531F3E0024;
	Thu, 17 Jul 2025 15:19:35 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <20250717045210.GA27227@lst.de>
Date: Thu, 17 Jul 2025 23:19:24 +0800
Cc: Yu Kuai <yukuai@kernel.org>,
 Coly Li <colyli@kernel.org>,
 linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org,
 Yu Kuai <yukuai3@huawei.com>,
 Xiao Ni <xni@redhat.com>,
 Hannes Reinecke <hare@suse.de>,
 Martin Wilck <mwilck@suse.com>,
 Keith Busch <kbusch@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <51F56854-4816-4CA4-AF2E-6985656C46CE@coly.li>
References: <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li>
 <20250716114121.GA32207@lst.de>
 <D12A8BDA-5C2B-4FA7-9C92-731BD321A611@coly.li>
 <20250716114533.GA32631@lst.de>
 <danlsghtalte7sku3vlfxkgngujgwzspanfayaxy4jfnk54jbf@yfvmr5plavmp>
 <20250716121449.GB2043@lst.de> <DE36C995-4014-44DC-A998-1C4FF9AFD7F9@coly.li>
 <20250716121745.GA2700@lst.de> <109C6212-FE63-4FD2-ACC3-F64C44C7D227@coly.li>
 <284433c9-c11d-401f-8015-41faa9d0fde1@kernel.org>
 <20250717045210.GA27227@lst.de>
To: Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1752765579274874111.26132.2787307015757015076@prod-use1-smtp-out1004.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=OcdiDgTY c=1 sm=1 tr=0 ts=6879148b
	a=cqlkUh1Psg5J4QAqX6BmHg==:117 a=cqlkUh1Psg5J4QAqX6BmHg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=u-Ikj0pI_giqZfaMg9UA:9
	a=QEXdDO2ut3YA:10



> 2025=E5=B9=B47=E6=9C=8817=E6=97=A5 12:52=EF=BC=8CChristoph Hellwig =
<hch@lst.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, Jul 17, 2025 at 12:29:27AM +0800, Yu Kuai wrote:
>>> If opt_io_size is (chunk_size * data_disks), setting new =
max_hw_sectors as rounddown(current max_hw_sectors, opt_io_size) is good =
idea.
>>=20
>> I think round down max_hw_sectors to io_opt(chunk_size * data_disks) =
will=20
>> really
>> make things much easier, perhaps Christoph means this way. All you =
need to=20
>> do is to
>> handle not aligned bio and split that part, and for aligned bio fall =
back=20
>> to use
>> bio_split_to_limits().
>=20
> If the raid5 code can handle multiple stripes per I/O, than you
> just need to round it down, yes.  I assumed it could only handle
> a single full or partial stripe at a time, but I guess I was wrong.
>=20
>=20

Thanks for the suggestion. I will compose a new version.

Coly Li=
