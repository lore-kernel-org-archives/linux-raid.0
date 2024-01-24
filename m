Received: from outbound.soverin.net (outbound.soverin.net [185.233.34.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D937E58B
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.233.34.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706115995; cv=none; b=T/800G7lx4hIft86fna3MHPIHA8xcXFbqm6XQC5FnQE/4h/1GHE6bFIpr7xG0/V95Coev2Hgtu0R8W5yHGjTOKPTS3HalztH23bqXDFjyCAoRlQNveZVmlMKK/BJo6T3qHfvhpZ5Gzyhd7IXKmP+ioqHbDkrNen8d6/v/ahuss0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706115995; c=relaxed/simple;
	bh=5LWM3FDsiG1PHE5KvqTKbWosvE2OtR26aASL8oMAUUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KmtLPvWCfKJOBS/Moutdfci+II6YL6jFL0xzwcAV/6gH0UNHbGIfBidjppKIAUtaBKOEA6gFbRHuhOtugfg+l7M4LQnM7IEnGZAeoYh3Ny5BO7y90f/sv/Xt23bNACmJnZtfNM9W4nlAw3/HTEyiS/NaEljWNOY5UavMPV7r7DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=penguinpee.nl; spf=pass smtp.mailfrom=penguinpee.nl; dkim=pass (2048-bit key) header.d=penguinpee.nl header.i=@penguinpee.nl header.b=Q8ZU1vbm; arc=none smtp.client-ip=185.233.34.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=penguinpee.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=penguinpee.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=penguinpee.nl header.i=@penguinpee.nl header.b="Q8ZU1vbm"
Received: from smtp.soverin.net (c04cst-smtp-sov01.int.sover.in [10.10.4.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	by outbound.soverin.net (Postfix) with ESMTPS id 4TKr2l1kBpz57;
	Wed, 24 Jan 2024 17:06:23 +0000 (UTC)
Received: from smtp.soverin.net (smtp.soverin.net [10.10.4.99]) by soverin.net (Postfix) with ESMTPSA id 4TKr2k60k7z43;
	Wed, 24 Jan 2024 17:06:22 +0000 (UTC)
Authentication-Results: smtp.soverin.net;
	dkim=pass (2048-bit key; unprotected) header.d=penguinpee.nl header.i=@penguinpee.nl header.a=rsa-sha256 header.s=soverin1 header.b=Q8ZU1vbm;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=penguinpee.nl;
	s=soverin1; t=1706115983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rkb4i43Vh/kitORHY0+RITQ/+Vnb3H/8mvOhhGVgRNg=;
	b=Q8ZU1vbmQiTLdPAWwPK7uI3Bngncm4ENBOFb63TOyDL6z3EIm8U2U6uBdbHnXcEwWMY2xX
	t5Sr/cikVPRTD/A42hvj6EuodFRy8LmkYH5t0vM8RbZ/XUV2bvbCWySPRKOJdD+Lau6aMA
	K+6sX/w2QKi4W9SygmBRDyBrQJCKvqSMuDRmcvxZO2P/7Dbhy30k8Vu7SjqdalngV+kXUX
	WNI9lNnY7RMUWnRNFVSgGEk7OCFUmbwM9FD1HIdbBln63Cb4fn7EBr+KngnxSYWRSdE9Ow
	13xWInAdN541TmuxDebkiDW3RaRTN4pagYvxgJ3Xj7/6RtaNF3RdzwWJVMouww==
Message-ID: <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl>
Date: Wed, 24 Jan 2024 18:06:22 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Requesting help recovering my array
Content-Language: en-US, nl, de-DE
To: RJ Marquette <rjm1@yahoo.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
 <432300551.863689.1705953121879@mail.yahoo.com>
 <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
 <1085291040.906901.1705961588972@mail.yahoo.com>
 <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net>
 <598555968.936049.1705968542252@mail.yahoo.com>
 <755754794.951974.1705974751281@mail.yahoo.com>
 <20240123110624.1b625180@firefly>
 <12445908.1094378.1706026572835@mail.yahoo.com>
 <20240123221935.683eb1eb@firefly>
 <1979173383.106122.1706098632056@mail.yahoo.com>
From: Sandro <lists@penguinpee.nl>
In-Reply-To: <1979173383.106122.1706098632056@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24-01-2024 13:17, RJ Marquette wrote:
> When I try the command you suggested below, I get:
> root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sd{a,b,e,f,g}1
> mdadm: no recogniseable superblock on /dev/sda1
> mdadm: /dev/sda1 has no superblock - assembly aborted

Try `mdadm --examine` on every partition / drive that is giving you 
trouble. Maybe you are remembering things wrong and the raid device is 
/dev/sda and not /dev/sda1.

You can also go through the entire list (/dev/sd*), you posted earlier. 
There's no harm in running the command. It will look for the superblock 
and tell you what has been found. This could provide the information you 
need to assemble the array.

Alternatively, leave sda1 out of the assembly and see if mdadm will be 
able to partially assemble the array.

-- Sandro

