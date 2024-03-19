Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D38228DD1
	for <linux-raid@vger.kernel.org>; Tue, 19 Mar 2024 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710870499; cv=none; b=d/MA7QCtXmz12zOVi0dtlQb35NmjlGQFctan7nc4bQ0TcqhjrPMYMLnYRqjO1XMt1i7w49FqJrsOgOS7urp5fdFYqJkc2RhtaFeRpsO1DAwQMrZStk7LDUQFi/DHgw2gUS0s2O9X1r3GaZ9sNE7kHar6j0FHkBL9yCWQbLgFvjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710870499; c=relaxed/simple;
	bh=EEXCHHxoySP+9kQ7LBOR5h3THEltAAYj3vY7OpEVi1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=dHDuSfyFPJW3DH00aWzC2LwObit63BU4HBw/Rs6j+JmAVTdicExh2lRT5PWrva+A1JxbdgUNAadO6pSrlaQzy/YzojPG0SwwENFP/sjC6gfbarz5pT/73f1aHixIa+LECb7JUXk9t2alN7vYonliel9vuh7C2fM9KWbSbPPotMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.178.112] (p57b378ee.dip0.t-ipconnect.de [87.179.120.238])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7FBD761E5FE35;
	Tue, 19 Mar 2024 18:48:06 +0100 (CET)
Message-ID: <9bbb9664-f42b-48cf-933e-cde0a588843e@molgen.mpg.de>
Date: Tue, 19 Mar 2024 18:48:05 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: heavy IO on nearly idle RAID1
Content-Language: en-US
To: Michael Reinelt <michael@reinelt.co.at>
References: <a0b4ad1c053bd2be00a962ff769955ac6c3da6cd.camel@reinelt.co.at>
 <abae1cb3-2ab1-d6cb-5c31-3714f81ef930@huaweicloud.com>
 <d26f7e96192abbbebd39448afe9a45e2fdd63d21.camel@reinelt.co.at>
 <ae0328a65c8a8df66dee1779036a941d2efd8902.camel@reinelt.co.at>
 <CAAMCDecDjUyLJi7QP9cmxOQfnsJdzbYDv70Ed0uB8uuf2Ry6-Q@mail.gmail.com>
 <58c66b62d0da6e5173d7f313aca27cd325aa0afb.camel@reinelt.co.at>
Cc: linux-raid@vger.kernel.org
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <58c66b62d0da6e5173d7f313aca27cd325aa0afb.camel@reinelt.co.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Michael,


I am sorry, that you hit a regression.

Am 19.03.24 um 18:43 schrieb Michael Reinelt:
> Good Point, thanks!
> 
> but I doubt that:
> 
> - I see heavy flickering of the USB Drive LED
> - the system has a very bad "responsiveness", it kind of "freezes"
> very often
> 
> none of these I see neither with Kernel 6.1 nor with 6.6 / UAS
> disabled

As you can reproduce this, and it works with an earlier version, the 
fastest way to resolve the issue is unfortunately to bisect the issue to 
find the commit causing the regression.


Kind regards,

Paul
