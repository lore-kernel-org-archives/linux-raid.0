Received: from outbound.soverin.net (outbound.soverin.net [185.233.34.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C2C182DB
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.233.34.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706088022; cv=none; b=Qr5Q+qXE43u1sAx2FrVoGSlkMwUSOKw4dbltnFHYnhQaS8152GRvsPvPB2F7BWfXu4SVN7/5SIc4YurvbORRg6SODWDhu23H6kXS+HyU9CX0LyqZydgYw6sDaynW5xfKj6PMC10AoU+aghikfp7IKs+NhxwxNipTr2w0t1ZHzaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706088022; c=relaxed/simple;
	bh=kSqSVicHRrWa9Sh9ryhf1zAbzuulJsC9BPiA9xcJLzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mVJWX4A/JpCvT4hDuEcaZbkO0Tf853q3NWtlDEaELsM6iffLyeALzl8dC7yQ8NFHOkfdOjcgveBqSse3bnl2hM3wrrTfU9CSct+q471hqgwFf3gEmxrL6WMdE0B5Wfzfwe6Tsc9ymplkCBa+YVf62g2rbW60ndMMsXGUiLErYhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=penguinpee.nl; spf=pass smtp.mailfrom=penguinpee.nl; dkim=pass (2048-bit key) header.d=penguinpee.nl header.i=@penguinpee.nl header.b=Yqh9kjzA; arc=none smtp.client-ip=185.233.34.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=penguinpee.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=penguinpee.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=penguinpee.nl header.i=@penguinpee.nl header.b="Yqh9kjzA"
Received: from smtp.soverin.net (c04cst-smtp-sov02.int.sover.in [10.10.4.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by outbound.soverin.net (Postfix) with ESMTPS id 4TKdVP1LX3z5x;
	Wed, 24 Jan 2024 09:11:09 +0000 (UTC)
Received: from smtp.soverin.net (smtp.soverin.net [10.10.4.100]) by soverin.net (Postfix) with ESMTPSA id 4TKdVN5rV6zLb;
	Wed, 24 Jan 2024 09:11:08 +0000 (UTC)
Authentication-Results: smtp.soverin.net;
	dkim=pass (2048-bit key; unprotected) header.d=penguinpee.nl header.i=@penguinpee.nl header.a=rsa-sha256 header.s=soverin1 header.b=Yqh9kjzA;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=penguinpee.nl;
	s=soverin1; t=1706087468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UwUJqvEt4IGlGTQIlyLuyEYEOs+5/mRAySbgo6sTvt0=;
	b=Yqh9kjzAvJkDhnU279hfbzi13UVKYE+5DWJiDAfxTDLYfc/Jmj9o51ALuq/SoUlraqEMvD
	LRUrZLHTMMz8+XAfdQb19aQCiDkOdU3dgzF3rz+mmwU98MSitSHhIx3c6V+B/3p/Bb2Ey5
	lwC9jBAkcB5Wk/KIMmYAyRL7LFlUSrMtSLXUSACP8VdngSmCfa59yN7lfWNHKnvRsp7w3Y
	Mc6KYODbIUwe45uwhJPKhaEfmDBVzcbQSoy/rslCXl1faHH/y/FqxwnZYNk+7EVCPbG75j
	/2vw41PGomebeXqzPjyA6xQ9pO3YXvvVYKS6zkjnNv1SPKo32Bb232qjbpff3Q==
Message-ID: <0915d016-2f46-45d3-8b2c-3b8b0973bd07@penguinpee.nl>
Date: Wed, 24 Jan 2024 10:11:08 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Requesting help recovering my array
Content-Language: en-US, nl, de-DE
To: RJ Marquette <rjm1@yahoo.com>
Cc: linux-raid@vger.kernel.org, David Niklas <simd@vfemail.net>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
 <432300551.863689.1705953121879@mail.yahoo.com>
 <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
 <1085291040.906901.1705961588972@mail.yahoo.com>
 <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net>
 <598555968.936049.1705968542252@mail.yahoo.com>
 <755754794.951974.1705974751281@mail.yahoo.com>
 <20240123110624.1b625180@firefly>
 <12445908.1094378.1706026572835@mail.yahoo.com>
 <c520a673-9b61-448c-999d-7e1b0b57c098@penguinpee.nl>
 <d051abe3-af97-47a4-a087-432c91beb57e@yahoo.com>
From: Sandro <lists@penguinpee.nl>
In-Reply-To: <d051abe3-af97-47a4-a087-432c91beb57e@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24-01-2024 01:55, RJ Marquette wrote:
> When you say manually, it's that adding the devices to the conf file then running assemble?

My conf file already contained entries regarding the raids. By manually 
I meant `mdadm --assemble` using either `--scan [--no-degraded]`, or, 
for more control, specify the devices making up the array as others 
suggested already.

-- Sandro

