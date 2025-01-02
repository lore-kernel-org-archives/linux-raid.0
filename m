Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23906FB0
	for <linux-raid@vger.kernel.org>; Thu,  2 Jan 2025 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735825443; cv=none; b=VWVYKh8pYBXm7BSOmJe7GPIGka5u2LJ+IpLE9j9GgwD6dIsbJ1cJ3dKJC/NkKZh22YPQeBmGwCWK/JTkH6DrPJvnr3MKwq1NHJlG0r3ZZ1mb1FjTRmJ6dpd7IEMYaO0Vni/G+DgqAMugAa9BiEV8orIx6f0sAXlawLnYFzUFpf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735825443; c=relaxed/simple;
	bh=Y2RwD18mZzAqOQ31DTpPCuErfBWv/ZIMAQfcwj8qYuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=thHs42d0vL+j3CNhm/1MdZFL2FQV8W0kla52c7aWctQvGDPTWcD+gvtR76ph0QJsL42M49YrZymUFe/onnshdQvOSwcCnpClZeSLVnlz8CHIapbDNI2czRa2gBUo9r39q2i2DPpBLOKuNs2YGLDKOu8aE4+FSDSLPZ8aGvgDg9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1tTLAE-0001dX-52; Thu, 02 Jan 2025 14:23:02 +0100
Message-ID: <f0b0b5ad-2558-47f5-9e83-e8c6e066ab8a@plouf.fr.eu.org>
Date: Thu, 2 Jan 2025 14:22:59 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: md-linear accidental(?) removal, removed significant(?) use case?
Content-Language: en-US
To: Roman Mamedov <rm@romanrm.net>, Allen Toureg <thetanix@gmail.com>
Cc: linux-raid@vger.kernel.org
References: <CABrqrA6b2y29tC2Z-9H2vYsuP_t5c6uCw9DZrjY7DmeNcczf0w@mail.gmail.com>
 <20250102171637.15bdb26f@nvm>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <20250102171637.15bdb26f@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/01/2025 at 13:16, Roman Mamedov wrote:
> 
> I fully support keeping md-linear for users with existing deployments.

Of course. Breaking existing setups is bad.

> Wanted to only ask out of curiosity, did you try using md-raid0 for the same
> scenario?
> 
> It can use different sized devices in RAID0. In case of two disks it will
> stripe between them over the matching portion of the sizes, and then the tail
> of the larger device will be accessed in a linear fashion. Not sure it can
> handle 3 or more in this manner, will there be multiple steps of the striping,
> each time with a smaller number of the remaining larger devices (but would not
> be surprised if yes).

Yes. If I remember correctly, md-raid0 divides disks in as many zones as 
different disk sizes. The first zone contains the area equal the size of 
the smallest disk(s) on all disks, and the last zone contains the 
remaining area on the biggest disk(s).

> Given that a loss of one device in md-linear likely means complete data loss
> anyway (relying on picking up pieces with data recovery tools is not a good
> plan), seems like using md-raid0 here instead would have no downsides but
> likely improve performance by a lot.

A downside is that adding a disk to a RAID0 array requires a reshape.

> Aside from all that, the "industry" way to do the task of md-linear currently
> would be a large LVM LV over a set of multiple PVs in a volume group.

I fully agree. LVM adds some complexity but also provides much more 
flexibility. You cannot hot-swap, resize or remove a disk in a md-linear 
array.

