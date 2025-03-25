Received: from mail68.out.titan.email (mail68.out.titan.email [3.216.99.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6E01EE7A7
	for <linux-raid@vger.kernel.org>; Tue, 25 Mar 2025 11:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.99.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742903687; cv=none; b=sXLnAZPAqyibyLiZB6/88TLhqZjoblo8WX3+n+f5RoGy+Q2bDF2ZSLISVI7dyInv/+Ld2ciIzVxjag++xgjaX3fMdaCZ/8+ITimA4Ii16P4w0J13JWNLgckMg72fdR3PcevPmoey7khli3Qoyxy1wYGVujY7DXBgedlXUIYkCF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742903687; c=relaxed/simple;
	bh=JT3aIXZbV2GEP8lc7Sl8Xb/3pdQ9Rs9u+JTKvTe4+x0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=B+aB/F3fEFgzG+dzr1S22CR28wNhF4ID8DwcaQlsFIBf9X24D1/SfjAehE3CW2LpmRBsncNQycRMlBFjzo7JIfasAevrM3d2hkCUz35/I+6ccFo7RednfviWNEb3oaJmIyW0w/5oJCP3fGNuo6QnLy2E8iMaTnCdPz25ecmPvrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=fkIYwozL; arc=none smtp.client-ip=3.216.99.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="fkIYwozL"
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 6824C1004B5;
	Tue, 25 Mar 2025 11:48:40 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=bDDNFMTDDoJPuB4LnRqlAWuTzWTx5ucgEN3AgGVM4Ak=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=cc:mime-version:subject:date:from:message-id:to:references:in-reply-to:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1742903320; v=1;
	b=fkIYwozLuqPF6WeiCIrubvaw3XsS4LeUc+2k15xZI9eqVv3pxItV88O9gSzcte6/7/JZWsKe
	Ol6WDsJIWzP2IolEcPGRMp57wP1bdeVHT8mU4wu8e7ngpvA2Or3kd1UtdudRmx/wLHO1qcuOnZF
	MyZjKgK9i2V5fzLPRA5OZw8o=
Received: from smtpclient.apple (ns3036696.ip-164-132-201.eu [164.132.201.48])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 9CDF31004CB;
	Tue, 25 Mar 2025 11:48:37 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] md/raid10: fix missing discard IO accounting
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <36f1f74b-4376-89f3-0690-09f36e05d6e1@huaweicloud.com>
Date: Tue, 25 Mar 2025 19:48:24 +0800
Cc: Coly Li <colyli@kernel.org>,
 song@kernel.org,
 jgq516@gmail.com,
 linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com,
 yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <761DA302-0E21-4CDD-ACCE-85958DBD48D5@coly.li>
References: <20250325015746.3195035-1-yukuai1@huaweicloud.com>
 <brtjiiejckcekwq4racmjgpzq7dod5bg2t4csj7caevnl4pkqm@zaanpogvtvus>
 <36f1f74b-4376-89f3-0690-09f36e05d6e1@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1742903320252286929.20113.3586250469236701842@prod-use1-smtp-out1002.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=I9+fRMgg c=1 sm=1 tr=0 ts=67e29818
	a=cqlkUh1Psg5J4QAqX6BmHg==:117 a=cqlkUh1Psg5J4QAqX6BmHg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=AiHppB-aAAAA:8 a=i0EeH86SAAAA:8
	a=RN-FF68yhb4yU0s_A_oA:9 a=QEXdDO2ut3YA:10



> 2025=E5=B9=B43=E6=9C=8825=E6=97=A5 15:27=EF=BC=8CYu Kuai =
<yukuai1@huaweicloud.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi,
>=20
> =E5=9C=A8 2025/03/25 15:04, Coly Li =E5=86=99=E9=81=93:
>> On Tue, Mar 25, 2025 at 09:57:46AM +0800, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>=20
>>> md_account_bio() is not called from raid10_handle_discard(), now =
that we
>>> handle bitmap inside md_account_bio(), also fix missing
>>> bitmap_startwrite for discard.
>>>=20
>>> Test whole disk discard for 20G raid10:
>>>=20
>>> Before:
>>> Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
>>> md0    48.00     16.00     0.00   0.00    5.42   341.33
>>>=20
>>> After:
>>> Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
>>> md0    68.00  20462.00     0.00   0.00    2.65 308133.65
>>>=20
>>> Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> Should we treat discard request as real I/O?
>> Normally IMHO discard request should not be counted as real data =
transfer,
>> correct me if I am wrong.
>=20
> Normally it's not, that's why discard IOs are accounted separately in
> the block layer.
>=20
> Also notice that discard should be treated as write, because after
> discard, reading will get zero data.

I see, it is for the separated discard counting.  Sure, I reply my =
Acked-by on the original patch.

Thank you for the explanation.

Coly Li=
