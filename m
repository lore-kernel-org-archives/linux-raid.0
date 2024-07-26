Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70AE524B4
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 08:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721980926; cv=none; b=a+q5Bvi4G7LurnMUJcpYrGZ5PviqV/xD7149Yk6TNCHbMjAKXHxSAoHbRp+teY1fMjK8ZI2aY9vIPPPOS0TGn/+WCXm0hrv3Jyv4C/+VMnspDSeDzyUg5Luml88q1rc3Tcwz4ndTBCUPDT1RXweE3RcjvjqBSQ0NEucm4Mhmxkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721980926; c=relaxed/simple;
	bh=KhCpDU1QyUMZNXccHXPG/8y5JuxTG/TULEZjlhkuoNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=djexxQvg+BEfUVNTL6+5EaSLpsDJ2OYlPokrId1Z50mvrisJoqlcGPy8pd8tFp0aQ1Lqt2gcmXkSqvoZg51XySLY+xt4E2D6f1Mx6aFRROgnktT/JIT0pgPomrgCHUCFrRq/Tlm9IZOxuuRsKWMm1IdEfNKATydr5HWmB77I7rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.2] (ip5f5af4fb.dynamic.kabel-deutschland.de [95.90.244.251])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 58A5D61E5FE06;
	Fri, 26 Jul 2024 10:01:30 +0200 (CEST)
Message-ID: <657cd05c-cc98-4f98-bd02-3db72089356b@molgen.mpg.de>
Date: Fri, 26 Jul 2024 10:01:29 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 00/14] mdadm: fix coverity issues
To: Xiao Ni <xni@redhat.com>
Cc: mariusz.tkaczyk@linux.intel.com, ncroxon@redhat.com,
 linux-raid@vger.kernel.org
References: <20240726071416.36759-1-xni@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240726071416.36759-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Xiao,


Thank you for taking care of these things. Some comments on minor things.


Am 26.07.24 um 09:14 schrieb Xiao Ni:

[…]

> Xiao Ni (14):
>    mdadm/Grow: fix coverity issue CHECKED_RETURN
>    mdadm/Grow: fix coverity issue RESOURCE_LEAK
>    mdadm/Grow: fix coverity issue STRING_OVERFLOW
>    mdadm/Incremental: fix coverity issues.

I’d remove the dot/period at the end

>    mdadm/mdmon: fix coverity issue CHECKED_RETURN
>    mdadm/mdmon: fix coverity issue RESOURCE_LEAK
>    mdadm/mdopen: fix coverity issue CHECKED_RETURN
>    mdadm/mdopen: fix coverity issue STRING_OVERFLOW
>    mdadm/mdstat: fix coverity issue CHECKED_RETURN
>    mdadm/super0: fix coverity issue CHECKED_RETURN and EVALUATION_ORDER
>    mdadm/super1: fix coverity issue CHECKED_RETURN
>    mdadm/super1: fix coverity issue DEADCODE
>    mdadm/super1: fix coverity issue EVALUATION_ORDER
>    mdadm/super1: fix coverity issue RESOURCE_LEAK

In my opinion, naming the tool reporting the issue in the commit message 
summary is not beneficial, and I’d prefer to have more detail on the 
change in there. The tool could be named/credited in the commit message 
body.


Kind regards,

Paul
