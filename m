Received: from mail78.out.titan.email (mail78.out.titan.email [3.216.99.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4C2F4A0E
	for <linux-raid@vger.kernel.org>; Wed, 16 Jul 2025 11:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.99.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752666810; cv=none; b=ZlrubA9ndGN/L8l3iUPYY2yEftv1/1f72k1h/x0Hu/rXbOIkNCD/p1w6yVyclHRUxQWhMLjuNtrlqJtl4Kecon8Y0rVZ741iCbLoZvqmY3JtQnty1mgyvVsdIzH6FrBWkYOQoBbbilXmAj08+pO1yPyi+sJoDA8Iu5FYqivaag8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752666810; c=relaxed/simple;
	bh=xBS3s+ZJ591tDEa1m82x/Nch4Mr3175WLQHH2VLziBk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mgpvBNQrd+3J1dAewhB3P2syWbmnZWSDA0o5xYjZVNIlEuRcYkNQTVQB90SBRLkAq8iF10h9jCT0CrTyjk0FEuZ6FswZYU2llDkQKu1ewm9bThpGxbfMHyHf4BgGa7WwuVDsU6TvVjqeLcMw6GuuARbzd90axWcJoXWbSbzeAEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=YaVjhx1M; arc=none smtp.client-ip=3.216.99.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="YaVjhx1M"
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id F0980140004;
	Wed, 16 Jul 2025 11:44:52 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=tQ4bjeYgTL2lbKmVh+X3U0hjcKIFDEp8g4H2VRXq0pA=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=subject:in-reply-to:date:cc:message-id:mime-version:from:to:references:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1752666292; v=1;
	b=YaVjhx1Md4sWCs7YcuZWLDaXy/KadUD5fYBVR8lGtrIjRg6PB1lZyP4WII+TEQayIF/z2cl5
	/7je1SyIX8YyG8TtBBdparVc3jVy3VpJyXtldHigzH9y/1qRtqwgFbRWYuJMgE1T9XhgiTE7Olu
	UZfAahFGctKaWzME6y+8a1Mk=
Received: from smtpclient.apple (ns3036696.ip-164-132-201.eu [164.132.201.48])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 698EF140024;
	Wed, 16 Jul 2025 11:44:50 +0000 (UTC)
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
In-Reply-To: <20250716114121.GA32207@lst.de>
Date: Wed, 16 Jul 2025 19:44:38 +0800
Cc: colyli@kernel.org,
 linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org,
 Yu Kuai <yukuai3@huawei.com>,
 Xiao Ni <xni@redhat.com>,
 Hannes Reinecke <hare@suse.de>,
 Martin Wilck <mwilck@suse.com>,
 Keith Busch <kbusch@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D12A8BDA-5C2B-4FA7-9C92-731BD321A611@coly.li>
References: <20250715180241.29731-1-colyli@kernel.org>
 <20250716113737.GA31369@lst.de>
 <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li>
 <20250716114121.GA32207@lst.de>
To: Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1752666292835436998.32042.2308300708089259128@prod-use1-smtp-out1003.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=OcdiDgTY c=1 sm=1 tr=0 ts=687790b4
	a=cqlkUh1Psg5J4QAqX6BmHg==:117 a=cqlkUh1Psg5J4QAqX6BmHg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=SoZIuoSYN6S1GEdF2LgA:9
	a=QEXdDO2ut3YA:10



> 2025=E5=B9=B47=E6=9C=8816=E6=97=A5 19:41=EF=BC=8CChristoph Hellwig =
<hch@lst.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Wed, Jul 16, 2025 at 07:39:18PM +0800, Coly Li wrote:
>>>> For raid level 4/5/6 such split method might be problematic and =
hurt
>>>> large read/write perforamnce. Because limits.max_hw_sectors are not
>>>> always aligned to limits.io_opt size, the split bio won't be full
>>>> stripes covered on all data disks, and will introduce extra read-in =
I/O.
>>>> Even the bio's bi_sector is aligned to limits.io_opt size and large
>>>> enough, the resulted split bio is not size-friendly to =
corresponding
>>>> raid456 level.
>>>=20
>>> So why don't you set a sane max_hw_sectors value instead of =
duplicating
>>> the splitting logic?
>>=20
>> Can you explain a bit more detail?  In case I misunderstand you like =
I
>> did with Kuai=E2=80=99s comments
>=20
> Just set the max_hw_sectors you want.

Do you mean setting max_hw_sectors as (chunk_size * data_disks)?=
