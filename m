Received: from poutre.nerim.net (poutre.nerim.net [178.132.16.124])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474FC8F65
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 18:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.132.16.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709318755; cv=none; b=dhEN53xmeZ+0S4yYK1ZWjIHcU/65mw0iEwg3ocFB+RXl47ORAhegJ4gXZv6FcFHF0zAGqbkqhR4qEA/vcl5wmDwAuj0EJZe+RGH3Uj6e6dUeIMvtrqxJuodCLLa/wmNWb1KHQL8/GYehNfDSSZlmT+oEctdijcopQsju27tlLkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709318755; c=relaxed/simple;
	bh=k9QeUq88rc4AsYZR227h2Rsj1QaWDa+693n8CpYbJ+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dDlCV0La1zWg3sqgSFclMsiD0XshFTS76TI/2iQWRN8BOvI/U9zg6Z5zxo3NnYmYvTCR2GnUJtFfhRWcuOLj8b5I9NqToq5zkyIAhTU4uwaU3rNhiIVcZf+BMNk6Jc5V9Fn3/NgY/jKn+jn0KgkB6j90RgCg6Qds1h4b0BnM7SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=178.132.16.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id 543DC35EA34;
	Fri,  1 Mar 2024 19:45:48 +0100 (CET)
X-Virus-Scanned: amavisd-new at nerim.net
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lTTa1KcfHGiT; Fri,  1 Mar 2024 19:44:30 +0100 (CET)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
	by poutre.nerim.net (Postfix) with ESMTPSA id 38FBB35EA45;
	Fri,  1 Mar 2024 19:44:30 +0100 (CET)
Message-ID: <59dc6165-38f7-407b-b57b-730ac9d4c267@plouf.fr.eu.org>
Date: Fri, 1 Mar 2024 19:44:29 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Requesting help with raid6 that stays inactive
To: Roger Heflin <rogerheflin@gmail.com>, Topi Viljanen <tovi@iki.fi>
Cc: linux-raid@vger.kernel.org
References: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
 <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com>
Content-Language: en-US
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/03/2024 at 17:27, Roger Heflin wrote:
> 
> Do "fdisk -l /dev/sd[a-h]", given 4tb devices they are probably GPT partitions.

Not "probably". "type ee" means GPT protective MBR.

> Do not recreate the array, to do that you must have the correct device
> order and all other parameters for the raid correct.
> 
> You will also need to determine how/what created the partitions.
> There are reports that some motherboards will "fix" disks without a
> partition table.  if you dual boot into windows I believe it also
> wants to "fix" it.

For now there are two competing theories:
a) if the disk has no partition table, then the BIOS creates a new 
partition table;
b) if the disk has a backup GPT partition table but a missing or 
corrupted primary GPT partition table, then the BIOS restores the 
primary partition table from the backup partition table.

Theory a) implies that even if you manage to re-create the RAID 
superblocks, they will be overwritten again at next boot. Your options are:
- back-up the data before the next boot, re-create the RAID array in 
partitions instead of whole disks and restore tha data;
- or back-up the data before the next boot and re-create the RAID array 
in partitions with --data-offset value set so that the data area remains 
at the same disk offset.

Theory b) implies that if you manage to re-create the RAID superblocks, 
they will be overwritten again at next boot unless you also erase the 
protective MBR and primary and backup GPT partition table signatures 
with wipefs.

> You should likely also read the last 2-4 weeks of this group's
> archive.  Another guy with a very similar partition table accident
> recovered his array and posted some about the recovery steps he
> needed.

The discussion subject was "Requesting help recovering my array" and 
started in January.
<https://marc.info/?t=170595323800003&r=1&w=2>
