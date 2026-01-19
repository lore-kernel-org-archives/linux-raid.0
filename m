Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BF9310771
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841056; cv=none; b=V40k3IOw1m7DJ1TQMs3DyAgqF2lPxwFzsePJBFfiltN1gbeaHc3ty+5f/HLhXQj0eFcDoqMvBKeUCWTB3UjMG4Np7hWHXxPMvaZvl0hyhNJ7Nw70lbIf5mQwqCOmY+ULEhTD/Ra3Xpexq7n0Epana2gJKFWUiHOhy0Urny407+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841056; c=relaxed/simple;
	bh=gT4vR8YKqrd4662C9xJ5CTEJMmrHTl1DldueA0cfx7w=;
	h=Content-Type:From:References:Mime-Version:Subject:Date:Message-Id:
	 In-Reply-To:To; b=QFkig1TEOCXbnwdiMv1cxY15Nrw6zCN5COqq/NhENqkF1uTuYJJK15GCeyrZIwH3E1BK7YSTLF0vECza6GqrQzQ78L1O3wvUc1LrQvCcOypEgGOsLaUXAWZtJ/LnHZk3cT1ATz0VYDWAPPyrq6I4nbd7khkpjlG2wsTk1RRaLYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=CBjzw23+; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="CBjzw23+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768841046;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=gT4vR8YKqrd4662C9xJ5CTEJMmrHTl1DldueA0cfx7w=;
 b=CBjzw23+dXARYigqOCWaSeNv1zzyd8fmhfcKzDQ8XGXTED+bgsNA00oj+eMvARn+B588Mo
 haXRgsTVqktC3F3nHVeS0hS3hj7QayuI8C8jp7qq6cDHefhsCfarrOJDH3fJU/JbT8nReo
 lvPSKmPA6MZ0y4FOkOuIfZMlh5MiUBRTdvEBMLR4QV13/ZcrHlvwXx5jLwbW3KyZKHD01Y
 beail86PJu8FiwR4jXVB2XDpkcY/2W64HjfRTsTTxqTylEIuAsLwRbgR4uFum922csGxnu
 pNqYpHqhcRs+WlOohRGazEslInj94M9TL5y4IBvckn8nEQyQrXL0TBnOXCFSgA==
Content-Type: text/plain; charset=UTF-8
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
References: <CAMGffE=Mbfp=7xD_hYxXk1PAaCZNSEAVeQGKGy7YF9f2S4=NEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [BUG] md: race between bitmap_daemon_work and __bitmap_resize leading to use-after-free
Date: Tue, 20 Jan 2026 00:44:02 +0800
Message-Id: <b1824ba1-a051-4c4f-bbf9-c28fb225edfc@fnnas.com>
In-Reply-To: <CAMGffE=Mbfp=7xD_hYxXk1PAaCZNSEAVeQGKGy7YF9f2S4=NEA@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
To: "Jinpu Wang" <jinpu.wang@ionos.com>, 
	"linux-raid" <linux-raid@vger.kernel.org>, "Song Liu" <song@kernel.org>, 
	"open list" <linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.feishu.cn with ESMTPS; Tue, 20 Jan 2026 00:44:04 +0800
X-Lms-Return-Path: <lba+2696e5f54+7c4792+vger.kernel.org+yukuai@fnnas.com>
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com

Hi,

=E5=9C=A8 2026/1/19 23:14, Jinpu Wang =E5=86=99=E9=81=93:
> We are looking for suggestions on the best way to synchronize this. It
> seems we need to either: a) Ensure the md thread's daemon work is
> stopped/flushed before
>
> __bitmap_resize proceeds with unmapping. b) Protect bitmap->storage
> replacement with a lock that
> bitmap_daemon_work also respects.
>
> Any thoughts on the preferred approach?

create/free/resize and access bitmap other than IO path should all be
protected with mddev->bitmap_info.mutex.

--=20
Thansk,
Kuai
