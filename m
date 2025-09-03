Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8271B0439
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 18:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756924526; cv=none; b=cjGZ8mGD6dJaO8b65d0X9gwcurEgxUEnYJpHSfiEXdWPa9OyugWxFM6SaFgWJngkgnzHV8itJr7g+ra4lK0LmuejnzTwrTgmbRw+wc3l1B5zr9bolgRu6vM3BmLLm6lr7mnEAjoEJ7V8wD/J2X52s5S1NVf+rat4JkLDP4BwAGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756924526; c=relaxed/simple;
	bh=bIoylk9JzP5xDTUk4zGck2RyaXOAAoCQvRO5b/97SgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mr0SZnnmbPfcGm0eJ2+IRjNg9i2cnYc7rENjUuX+9xuhAwHEbXmHwbFBgpuCfDUk4GGZd65GE0RbI94dEgkx5EJ5o46UWZiJEx6n2tUW80OKi0RUsbV93Va/UqLLGPNCzto/IiLivRFTKBRzgf1Cb1y3tr+JU85BkiRF+3KdJiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.247]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1utrjN-00044u-UL; Wed, 03 Sep 2025 19:57:13 +0200
Message-ID: <b1fa1062-7414-400a-ab90-334977e18067@plouf.fr.eu.org>
Date: Wed, 3 Sep 2025 19:57:14 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
Content-Language: fr
To: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
Cc: linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
 <20250903204521.44e91df1@nvm>
 <0bec82b1-ab30-4d3b-b254-a461d1039dbf@peter-speer.de>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <0bec82b1-ab30-4d3b-b254-a461d1039dbf@peter-speer.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/09/2025 at 19:47, Stefanie Leisestreichler (Febas) wrote:
> 
> - Do I need to turn off the computer for the new (3rd) disk to be known? 

It depends whether the host adapter and port support hotplug. On some 
motherboards it must be enabled in BIOS/UEFI settings. Do not disconnect 
a disk while power is on if the port does not support hotplug either.

> Also I see problems with the device naming as long as no hd uuids are 
> not used by having a drive appearing as /dev/sdx and with next reboot 
> as /dev/sdn. Are my concerns reasonable or am I just too afraid?

/dev/sd* names are not persistent and cannot be relied upon. But md uses 
UUIDs for assembly, so it does not matter.
