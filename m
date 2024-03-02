Received: from bamako.nerim.net (bamako.nerim.net [178.132.17.28])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B37814284
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 09:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.132.17.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709372803; cv=none; b=rWpCfU9URE0Ao/oG0eE39NHl/SpTgerGfdzqwdZc2+BvJ1xTgpsyH8nsJN023A+M/ZGcf+Supyaq7xkS10UT5+lxbTaIOOTTSoKErshUI42bAej4OU3Lwz5o4lzzvHQvnRcwWKfoo8004PjKH4ya22QX+XSsRzcz6DrMcPHZU3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709372803; c=relaxed/simple;
	bh=BUqWTe8+xweBMNjueVhFu4m+D/6qhyGep2oTCiHIO4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pA2o1ECZd/9dhSdeB6tL4VQiEAJl5APv6LPE6keWKCSG1TiVo2+HCQrlPt8Wf4vBVy0jPBB8vbMm5uy9SSRFAjsXOMqARHAyVYT7ikjyk9eM1SQ3LLjgn+ejY+8cET9MmKh6aAvoR+UKFZguBoiXfcM+dDUJ0FVQPPiMfKFfFk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=178.132.17.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from localhost (localhost [127.0.0.1])
	by bamako.nerim.net (Postfix) with ESMTP id 3BD0C39DCE2;
	Sat,  2 Mar 2024 10:38:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at nerim.net
Received: from bamako.nerim.net ([127.0.0.1])
	by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wYgeMohGk745; Sat,  2 Mar 2024 10:37:33 +0100 (CET)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
	by bamako.nerim.net (Postfix) with ESMTPSA id 04AD339DC5F;
	Sat,  2 Mar 2024 10:37:32 +0100 (CET)
Message-ID: <bc3475bd-cdf7-4698-b21a-236e4d055537@plouf.fr.eu.org>
Date: Sat, 2 Mar 2024 10:37:33 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Requesting help with raid6 that stays inactive
To: Topi Viljanen <tovi@iki.fi>
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
References: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
 <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com>
 <59dc6165-38f7-407b-b57b-730ac9d4c267@plouf.fr.eu.org>
 <CADC_b1fJGMSsYjzh8nTnSi2ZgoGmzY_wube2MzgAtr5QwtRzGw@mail.gmail.com>
Content-Language: en-US
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <CADC_b1fJGMSsYjzh8nTnSi2ZgoGmzY_wube2MzgAtr5QwtRzGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/03/2024 at 09:50, Topi Viljanen wrote:
> 
> I was able to get the order of the devices from old syslog file
> (smartd) and then created the array again:
(...)
> Running fsck caused so many errors that the mounted ext4 was empty.
> I reset the overlay array and now I'm running analyze with testdisk.

Then I am afraid that the order was wrong and testdisk will not be able 
to retrieve much.
