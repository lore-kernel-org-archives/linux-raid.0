Received: from mx.febas.net (mx.febas.net [168.119.129.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA8F2D374A
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.129.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756927192; cv=none; b=V9DBfiUZRjSReo2uGcUqkroFwaviBoysfuf05LB++tslyNmtVqwVmGkQgqLT/I/1apx3rDnCEt4sEPEVCc+NbyBRHUVCeppB5ihgs3ov+qJUY4Vh8kfU9Fod7BFQ4jVECnMSB9HP+NPWaUkm9N5jcUfsqqjL5bY1jKUKL0r1LSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756927192; c=relaxed/simple;
	bh=5ZSN7SousGqq+DKlzJFdAU4/Bs096Nk9eYCqQLsmp5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=USJHEKMbixSwTJf8XkN2ryBSjxIs3XwgNIg4TXuiHAH9aEQIn0utaKb4NPSzmLrVbbelT6KASPW22PbZhyZw8BgoPIBgY/f/bG86huTMKSvP/CrXjKjmtuWgbDbxnLVcBKlW89llW94sFF2UGiFtWBFB9R1xta4yT1TqZRhoAEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de; spf=pass smtp.mailfrom=peter-speer.de; arc=none smtp.client-ip=168.119.129.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peter-speer.de
Received: from mx.febas.net (localhost [127.0.0.1])
	by mx.febas.net (Proxmox) with ESMTP id 0CE0B61324;
	Wed,  3 Sep 2025 21:19:44 +0200 (CEST)
Message-ID: <7b2f14b4-caa1-4446-a773-687bd9fbfbd5@peter-speer.de>
Date: Wed, 3 Sep 2025 21:19:39 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
To: Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc: linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
 <20250903204521.44e91df1@nvm>
 <0bec82b1-ab30-4d3b-b254-a461d1039dbf@peter-speer.de>
 <b1fa1062-7414-400a-ab90-334977e18067@plouf.fr.eu.org>
Content-Language: de-DE
From: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
In-Reply-To: <b1fa1062-7414-400a-ab90-334977e18067@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 1.0.7 at mail.febas.net
X-Virus-Status: Clean

On 03.09.25 19:57, Pascal Hambourg wrote:
> On 03/09/2025 at 19:47, Stefanie Leisestreichler (Febas) wrote:
>>
>> - Do I need to turn off the computer for the new (3rd) disk to be known? 
> 
> It depends whether the host adapter and port support hotplug. On some 
> motherboards it must be enabled in BIOS/UEFI settings. Do not disconnect 
> a disk while power is on if the port does not support hotplug either.
> 
>> Also I see problems with the device naming as long as no hd uuids are 
>> not used by having a drive appearing as /dev/sdx and with next reboot 
>> as /dev/sdn. Are my concerns reasonable or am I just too afraid?
> 
> /dev/sd* names are not persistent and cannot be relied upon. But md uses 
> UUIDs for assembly, so it does not matter.

Thanks, Pascal for explaination.

