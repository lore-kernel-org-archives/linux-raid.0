Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C45380FF3
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 07:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782114808; cv=none; b=tddav/Bv7dkgbLKz4cqdqmha9YOA/sBCyxoLuxubHIdqQ9/oXPGuc02rqwCLz6nvvmPFMpNP7XanQoZPCkqiK3IaTBCXkRcpgGm8OLOci+sILXcxIbrpduQMuLlmcR1+2oCDcuBmFzBr8A1N0smf17CSiA2cKd5TwlieCZtPRJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782114808; c=relaxed/simple;
	bh=V/7SyqWeZ63J9bjzu+3gMO5QE+LgnDOUkz97APGSf8A=;
	h=From:In-Reply-To:References:Mime-Version:Content-Type:To:Date:
	 Message-Id:Cc:Subject; b=hZwZOHyZkhZYiqxXKu6RH6A61fQgdSfxvGpWTPX2cOGQJFYVFLdObr3wVl4zMXueRoaelZ7Lw3wGfRElFOQoXQR2Zw+c3Q8ATTbMljAEkMV11iXUk/q6KvkDZUOkcWxdAgZC16AjE6UA8sy/ifeIZIgHNNSWfG14TVxd0jVKIwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=T9TDU3gG; arc=none smtp.client-ip=209.127.231.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="T9TDU3gG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1782114792;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=V/7SyqWeZ63J9bjzu+3gMO5QE+LgnDOUkz97APGSf8A=;
 b=T9TDU3gGsX0trPg0YrzcnJ+feSxHOdIX9pU/s+gl0tgRpXgB+SoxTcyxFH4EE4y3q5m2V8
 JCngiyXT2QUdG5rXGAP/m2QrSp4Pt8wjlhDNDfLENWWXD7cR6aD9nPX9gSr2cTgOPFN/sv
 MngGXDZ4xvroLdDZ0boQlK5Mj3E1UV1Yvgg7/1V9n5ZLlSqrYjhgbGSLdXdwPV19CIdZ08
 02bcOXuXY7aEgHt6uZ55L8W1uZmAlXzyAp96xPT+1Nau5y604fZ9xBeHMiVyjoL0lyjEWp
 iarOJHoe+BaD0Ub2KKAE30r2p+jFrLTvfpWpO78Wt1oEgXQNGMagx9u4zU4yiw==
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <f877d9f4-4912-4331-8c14-e7726adf24bc@fnnas.com>
X-Lms-Return-Path: <lba+26a38e9e8+bc45d7+vger.kernel.org+yukuai@fygo.io>
References: <20260603035925.217847-1-chencheng@fnnas.com> <20260603035925.217847-4-chencheng@fnnas.com> <21def978-3c6e-4a9f-8c60-c213e760fb7c@fygo.io> <f877d9f4-4912-4331-8c14-e7726adf24bc@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>
Date: Mon, 22 Jun 2026 15:53:07 +0800
Message-Id: <a2f3a5da-71c3-4cff-ba97-db39e3ec4964@fygo.io>
Cc: <linux-kernel@vger.kernel.org>, <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Mon, 22 Jun 2026 07:53:11 +0000
Subject: Re: [PATCH v4 3/3] md/raid10: bound reused r10bio devs[] walks by used_nr_devs

Hi=EF=BC=8C

=E5=9C=A8 2026/6/22 14:34, Chen Cheng =E5=86=99=E9=81=93:
> The true dangerous is in-flight r10bio which use old geometry.

You didn't explain why there can be inflight r10bio when array is suspended=
,
if this can happen, this is the root cause need to be fixed.

--=20
Thanks,
Kuai
