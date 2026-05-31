Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA348345CBC
	for <linux-raid@vger.kernel.org>; Sun, 31 May 2026 10:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780222799; cv=none; b=fcUlQ5J7krgoMdiIeMkl+xtTE60doAmRtNkJQ/LO0q85psJ/raXPWge8iZjHpouRZbCTOSahOPFPRytXTO18hjyqgbfzzZ/MMmR5nBMZvUi10lQy2r4FlkHzcQBLn66yYSG68PaWe0oOikreW+XvCcomaQ87Ea7vdVlVBWOzULk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780222799; c=relaxed/simple;
	bh=Ua9rAG5gcL6vQolNQnn7Xkg1GkDytmVwc7UBoNKyN+Q=;
	h=To:Message-Id:In-Reply-To:Subject:Date:From:References:
	 Content-Type:Cc:Mime-Version; b=HJgGDPzkdT6buuuFKkUqWg8PiPI8qpiuiTGvowdgtOk7tAf1mU5GaRj5hnzY1EeweLRF1a29ZB2xS1xV89tJJSooOZmUHEZeZG0G+kmgHrZ/Q9FBec/M7q/YQEuB2eMpvUwzyFJFDum5AYQh23vkO+x1ciaJbr7DR1u+CaISBmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ZltCJIGb; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ZltCJIGb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1780222783;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=XShzQNXw4mFL6f+WUaXWbcueFyMOqDSdLqE7RUAa7r0=;
 b=ZltCJIGbDzb5o5IoaKN9RfPJImDRO42bEvNQF0ZFXRuUo4iVSL3464WLRy66Dq94MRzobq
 R9v03udsU5g9PMREDV5sv5mW0K/vP30y30+rvgSiYi+guPfajfrlHEA9arLpWvSNvrw3C3
 uS3k2KjuDS46OvsiFDyhZWkN2vNEHNh/Sve3fiX4rQ8PXR5RBx6BCnmbSPJXb2coilZIrb
 9S6AAWeF1edDSYmpJRAvgaewcuCVwGzvMowHnaVfB1RWTrDhMROm1CAUPYcThF4HM7f0Uv
 yotyn0N+0+4oM+1MdhmQE8Cb+m99jC/Ft7KaP1xhJe925DqARgsDZrYVapEg2w==
To: "Christoph Hellwig" <hch@lst.de>, "Song Liu" <song@kernel.org>, 
	<yukuai@fygo.io>
Message-Id: <22fdee10-2268-4fc3-a140-8e654edccca4@fygo.io>
In-Reply-To: <20260529054308.2720300-1-hch@lst.de>
Subject: Re: two small RAID1 cleanups
Date: Sun, 31 May 2026 18:19:39 +0800
From: "Yu Kuai" <yukuai@fygo.io>
X-Original-From: Yu Kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
References: <20260529054308.2720300-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Cc: "Li Nan" <linan122@huawei.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
Received: from [192.168.1.104] ([39.182.0.134]) by smtp.larksuite.com with ESMTPS; Sun, 31 May 2026 10:19:42 +0000
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a1c0b3e+34aab2+vger.kernel.org+yukuai@fygo.io>

=E5=9C=A8 2026/5/29 13:42, Christoph Hellwig =E5=86=99=E9=81=93:

> Hi all,
>
> this series has two little cleanups that helped me understand the
> code when reading through it.
>
> Diffstat:
>   raid1.c |   44 ++++++++++++++++++++------------------------
>   1 file changed, 20 insertions(+), 24 deletions(-)
Applied to md-7.2

--=20
Thansk,
Kuai
