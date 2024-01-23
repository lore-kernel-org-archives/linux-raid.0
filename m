Received: from outbound.soverin.net (outbound.soverin.net [185.233.34.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296D14120C
	for <linux-raid@vger.kernel.org>; Tue, 23 Jan 2024 23:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.233.34.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706050822; cv=none; b=f3jS+mXUSD1Yndmmi7pjEZeyd37jHN1oEKq9H3R3fepqOFDHo0eGKzYGDkujNkyrzTvE0/PESGDnFQGUjRnXaWvBTe6X0X2Klq8TM997qGEmLCJN+mXExXueci9m51EGcYPxbmO/7tKH+hU+lVOSvqmxDnaoSvASgEbTTIt2gCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706050822; c=relaxed/simple;
	bh=flmgbYB1DpZbfbJvcBEAp8lmotRWvOeCp0jaIrfy1gw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NmyNvxPZE3cBo1RCX/mDexEfhW94Rt/Ndv0NTQ0BsPhvkx0S+5wxFI4dSrUt4/hH3DgzgcojfwfRsCZy5ajeoxLXRW89Ha34RboaXrzJd05fowABM+NG0qVvFjZpdwjNr5ynCZQQdJXPTi7zQntCoOmP3Hd9fYGJvdcAAPyL4JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=penguinpee.nl; spf=pass smtp.mailfrom=penguinpee.nl; dkim=pass (2048-bit key) header.d=penguinpee.nl header.i=@penguinpee.nl header.b=WkF9O2/N; arc=none smtp.client-ip=185.233.34.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=penguinpee.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=penguinpee.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=penguinpee.nl header.i=@penguinpee.nl header.b="WkF9O2/N"
Received: from smtp.soverin.net (c04cst-smtp-sov01.int.sover.in [10.10.4.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by outbound.soverin.net (Postfix) with ESMTPS id 4TKMjs3Xyqz35;
	Tue, 23 Jan 2024 22:50:09 +0000 (UTC)
Received: from smtp.soverin.net (smtp.soverin.net [10.10.4.99]) by soverin.net (Postfix) with ESMTPSA id 4TKMjr5tNvz2k;
	Tue, 23 Jan 2024 22:50:08 +0000 (UTC)
Authentication-Results: smtp.soverin.net;
	dkim=pass (2048-bit key; unprotected) header.d=penguinpee.nl header.i=@penguinpee.nl header.a=rsa-sha256 header.s=soverin1 header.b=WkF9O2/N;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=penguinpee.nl;
	s=soverin1; t=1706050209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VoCBR8Qv1aVD7CWuAWtHn+Uit+vhF0JVJt7ZRerOtPU=;
	b=WkF9O2/NcUrj3DVekBoZJIAdtNe3k9xd0H7x/YZAPlT5I81BWmP4477EtKblYPtdzvRjsc
	weixX/R/ti+HLNU3XDHJqJ5GCZ6uzsbkJOml1COI8pw+mz0nDGvLaNbkaPoE3Kbuh0yvpM
	NJtHKAE11qnJTki4nv3Fm93Zshd57wvPCNZnlJgrhNlgzN0hT0LTzs5C5H1BL+AbFSU06M
	lwi3CsqZ+Kna7ilP5doMhCpYNunz2ydA3n0EUeLp8vOtAWJ9sDXu0EqljWveQJxZAobMy4
	uYawoPfF/WAipouPn2Z9cCmdWtNet14E2CcZW0RuBe35aDMQqxr6JAoBjbNOgg==
Message-ID: <c520a673-9b61-448c-999d-7e1b0b57c098@penguinpee.nl>
Date: Tue, 23 Jan 2024 23:50:08 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Requesting help recovering my array
Content-Language: en-US, nl, de-DE
To: RJ Marquette <rjm1@yahoo.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 David Niklas <simd@vfemail.net>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
 <432300551.863689.1705953121879@mail.yahoo.com>
 <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
 <1085291040.906901.1705961588972@mail.yahoo.com>
 <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net>
 <598555968.936049.1705968542252@mail.yahoo.com>
 <755754794.951974.1705974751281@mail.yahoo.com>
 <20240123110624.1b625180@firefly>
 <12445908.1094378.1706026572835@mail.yahoo.com>
From: Sandro <lists@penguinpee.nl>
In-Reply-To: <12445908.1094378.1706026572835@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23-01-2024 17:16, RJ Marquette wrote:
> It's like mdadm was assembling them automatically upon bootup, but that
> stopped working with the new motherboard for some reason.

Just a hunch, since you wrote that you updated your system as well:

https://bugzilla.redhat.com/show_bug.cgi?id=2249392

If that's affecting you, `blkid` will be missing some information 
required for RAID assembly during boot. On the other hand, I was able to 
assemble my RAID devices manually.

-- Sandro

