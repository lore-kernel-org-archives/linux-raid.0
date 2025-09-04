Received: from mx.febas.net (mx.febas.net [168.119.129.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E742367D5
	for <linux-raid@vger.kernel.org>; Thu,  4 Sep 2025 17:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.129.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757005625; cv=none; b=T8vG+akMTY2dR65ogTl0JqLOBETldpGejc0uzlMKzNTh7cfw7FjKc4+1UKURRNYwjN4DK/Ug4XM6kJfZFp36XVAxd7XZ8dIwbRE98va0LIrspHa16GhNJCTv7+nW+hAT6fLoG02d3HGsLoK3kZUgtqD6oufjEqFKRWHliD6JuDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757005625; c=relaxed/simple;
	bh=zoxicY1fIyWwvr/7YIuucdImSKzJfar1pgBRp+GkMkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=orka43U4Bd3ntkT6wSk1/0XIFsnUeNCWdtktmwQhTD7KpMQ4rik88YV6nWZ68ZQabzbMzSMNITXlp4FeEWSRjLvMba/yEU+OnfbE3q1CvXgWblut74RVw0InSP6JXxXzq8d6OLgqp+s16UReuTvtxsbM4N6vwwa/Ts9jtlOnKtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de; spf=pass smtp.mailfrom=peter-speer.de; arc=none smtp.client-ip=168.119.129.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peter-speer.de
Received: from mx.febas.net (localhost [127.0.0.1])
	by mx.febas.net (Proxmox) with ESMTP id 2DB9160998;
	Thu,  4 Sep 2025 19:07:00 +0200 (CEST)
Message-ID: <2c9a65b6-d9e8-4a4e-b644-0d18913bc0f8@peter-speer.de>
Date: Thu, 4 Sep 2025 19:06:56 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
To: Wol <antlists@youngman.org.uk>, Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
 <20250903204521.44e91df1@nvm>
 <0bec82b1-ab30-4d3b-b254-a461d1039dbf@peter-speer.de>
 <ec124f5e-8849-49ce-bf8e-e537452c1dd3@youngman.org.uk>
Content-Language: de-DE
From: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
In-Reply-To: <ec124f5e-8849-49ce-bf8e-e537452c1dd3@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 1.0.7 at mail.febas.net
X-Virus-Status: Clean

On 03.09.25 21:50, Wol wrote:
> On 03/09/2025 18:47, Stefanie Leisestreichler (Febas) wrote:
>> I like this method, hopefully I have a free connector on the board.
>>
>> But still two questions left:
>> - Do I need to turn off the computer for the new (3rd) disk to be 
>> known? If I remember correct I had try a hot spare in another scenario 
>> and wasn't able to expose the new hard disk to be recognized by lsblk 
>> or similar.
> 
> As others have said, if your mobo doesn't support hotplug, DON'T TRY IT!
> 
> Otherwise, use eSATA (or USB).>
>> Also I see problems with the device naming as long as no hd uuids are 
>> not used by having a drive appearing as /dev/sdx and with next reboot 
>> as /dev/sdn. Are my concerns reasonable or am I just too afraid?
> As others have said, it doesn't matter. Not sure if as the other person 
> said md uses uuids, or if it just scans all partitions, and looks for a 
> superblock.
> What I would say (and it's not for raid1, but definitely raid 5/6) if 
> you do have parity raid then make sure every time you change the config, 
> generate an mdadm.conf file (or whatever it's called). While md doesn't 
> use it, if you have a problem with your raid you will wish you had it!
> 
> As I say, you're raid 1, you don't need it now, but if you ever do 
> change, DO IT!
> 
> Cheers,
> Wol

Thanks for the tips, very welcome.

