Received: from mx.febas.net (mx.febas.net [168.119.129.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330C632ED5E
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.129.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756921649; cv=none; b=dx+LWB9oD9ZhkPrjgXxuUB37l23NeSR7Un1/3uGnUtG/dCJNV+7VQBsaN0mk0Dqbk5Wqpg51xGNevLl0KcA3DJKEh0xUBOEKlm83wlzZ6UA/jlDyzHJ4D803qI0jpISv/i/zbm/533Bcr217g2YnmGvRZPkLoCikZ6oHo7ecx3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756921649; c=relaxed/simple;
	bh=M0XxZD2/P1FniMwKKLOdunY0AjilnK1ur+NZwuG7clQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BVliao8IxjDImr+3n2zHrfbqBVsIL4WRRCJMN2kl3JpCRqrMhQGmb3lSAxku5yo5z+i/9g7Ag4wuA8JGhKdU34cQsMA3N9txQDzTCgXbbzS+ssUVB+G8cnRI90BdyteASFqncihPMx5mGl2k7t7UHh6FQnWv0BvXtDkLr2c2DhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de; spf=pass smtp.mailfrom=peter-speer.de; arc=none smtp.client-ip=168.119.129.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peter-speer.de
Received: from mx.febas.net (localhost [127.0.0.1])
	by mx.febas.net (Proxmox) with ESMTP id D30506136A;
	Wed,  3 Sep 2025 19:47:21 +0200 (CEST)
Message-ID: <0bec82b1-ab30-4d3b-b254-a461d1039dbf@peter-speer.de>
Date: Wed, 3 Sep 2025 19:47:15 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
 <20250903204521.44e91df1@nvm>
Content-Language: de-DE
From: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
In-Reply-To: <20250903204521.44e91df1@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 1.0.7 at mail.febas.net
X-Virus-Status: Clean

On 03.09.25 17:45, Roman Mamedov wrote:
> Do you have a free drive bay and connector in your computer (or just the
> connector)?
> 
> If so, the safest would be to connect all three drives, and then:
> 
>    mdadm --add (new drive)
>    mdadm --grow -n3 (array)
>    mdadm --fail --remove (old drive).
>    mdadm --grow -n2 (array)

I like this method, hopefully I have a free connector on the board.

But still two questions left:
- Do I need to turn off the computer for the new (3rd) disk to be known? 
If I remember correct I had try a hot spare in another scenario and 
wasn't able to expose the new hard disk to be recognized by lsblk or 
similar.

Also I see problems with the device naming as long as no hd uuids are 
not used by having a drive appearing as /dev/sdx and with next reboot as 
/dev/sdn. Are my concerns reasonable or am I just too afraid?

Thanks.

