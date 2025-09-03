Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B6D2DEA84
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 20:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756930336; cv=none; b=bSPTTKVRSlaghf+pcqXvUj/5DVLtCSrR7gUQ1Su9UcBAvnqC0ms0GaGw+8TXSCXlq8XW/F19uqKlZgCjS0kEc+N1lbRPnybvWEH2jZMrFKtD78mWcYxXTkYc5hypM6epQCm8RW8EIr7lmNXtU+6rNvi+PdpBkAyjeroRB97vGsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756930336; c=relaxed/simple;
	bh=DvK0N5v3x2DlOGUlJTxNFDVWUq+JhbyfBh8CmnK/3E4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=i5iWny5tjqYwab6dwSptDuyqANjXi5iZAhOavRr2UK0XCYK3IadsEK2np0MUo9RVlGGqbHhG3GhFsc3RYlEVZGPD1Sy1uq7JIl/aSzgLslwbYquWsPv3CrrT2a45T7U9AX/pRIirpD69ymY9fV5PVmmXuw81utqWoqk75NkQ5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=fail smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=youngman.org.uk
Received: from host51-14-94-149.range51-14.btcentralplus.com ([51.14.94.149] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antmbox@youngman.org.uk>)
	id 1utptL-000000006rI-31vR;
	Wed, 03 Sep 2025 16:59:23 +0100
Message-ID: <5bc1ce31-7acb-4cdf-bd01-b6238b0e1ade@youngman.org.uk>
Date: Wed, 3 Sep 2025 16:59:24 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
To: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
Content-Language: en-GB
From: anthony <antmbox@youngman.org.uk>
In-Reply-To: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03/09/2025 12:55, Stefanie Leisestreichler (Febas) wrote:
> Hi.
> I have the system layout shown below.
> 
> To avoid data loss, I want to change HDs which have about 46508 hours of 
> up time.
> 
> I thought, instead of degrading, formatting, rebuilding and so on, I could
> - shutdown the computer

Why degrade? There's no need.

But yes, unless you have hot-swap, you will need to shut down the 
computer at some point ... and I'd recommend at least one reboot...

First things first - do you have a spare SATA port on your mobo? Or (I 
wouldn't particularly recommend it) an external USB thingy to drop 
drives in? The latter will let you hot swap and avoid one reboot.

Okay. Plug your new drive in however. You will know which drives are 
your raid, so you just partition the third identically to the other two.

I'm surprised if your drives are MBR not GPT - MBR has been obsolete 
since almost forever nowadays :-) I think there's a GPT command that 
will copy the partitioning from a different drive. "man gdisk" or "man 
fdisk" - ignore stuff that says fdisk can't do GPT, it's long been upgraded.

Okay, now you have a 2-disk mirror and a spare. Add the spare as drive 3 
(ie you need (a) to add it to the array as a spare and then (b) update 
the number of drives in the array to three.) You can do both in the same 
command.

Monitor /proc/mdstat, which will tell you the progress of the resync. 
Once you've got a fully functional 3-drive array, shut the computer 
down. Swap the new drive for the old one and reboot.

/proc/mdstat will now tell you you've got a degraded 3-drive array with 
one missing. fail and remove the missing drive, and you're now left with 
a fully functional 2-drive array again. And at no point has your data 
been at risk.

The removed drive is, as has already been said, a fully functional 
backup (which is why I would recommend only removing it when the system 
is shut down and you KNOW it's clean).

And I wouldn't recommend putting that drive back in the same computer, 
without wiping it first! I don't think it will do any damage, but in my 
experience, raid is likely to get thoroughly confused with a failed 
drive re-appearing, and it's simpler not to do it. If you want to get 
anything back off that drive, stick it in a different computer.


Google for "linux raid wiki". Ignore the crap about it being "obsolete" 
- the admins archived a site which was aimed at end users, and are 
referring people to the kernel documentation !!! Idiots !!! The two are 
aimed at completely different target markets!

(How big are your drives? If they're anything like modern, there's a 
very good chance they are GPT. Is the upper limit for MBR 2GB?)

Cheers,
Wol

> - take i.e. /dev/sda and do
> - dd bs=98304 conv=sync,noerror if=/dev/sda of=/dev/sdX (X standig for 
> device name of new disk)
> 
> Is it save to do it this way, presuming the array is in AA-State?
> 
> Thanks,
> Steffi
> 
> /dev/sda1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 68c0c9ad:82ede879:2110f427:9f31c140
>             Name : speernix15:0  (local to host speernix15)
>    Creation Time : Sun Nov 30 19:15:35 2014
>       Raid Level : raid1
>     Raid Devices : 2
> 
>   Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
>       Array Size : 976629568 (931.39 GiB 1000.07 GB)
>    Used Dev Size : 1953259136 (931.39 GiB 1000.07 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=261864 sectors, after=1840 sectors
>            State : active
>      Device UUID : 5871292c:7fcfbd82:b0a28f1b:df7774f9
> 
>      Update Time : Thu Aug 28 01:00:03 2025
>    Bad Block Log : 512 entries available at offset 264 sectors
>         Checksum : b198f5d1 - correct
>           Events : 38185
> 
>     Device Role : Active device 0
>     Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 68c0c9ad:82ede879:2110f427:9f31c140
>             Name : speernix15:0  (local to host speernix15)
>    Creation Time : Sun Nov 30 19:15:35 2014
>       Raid Level : raid1
>     Raid Devices : 2
> 
>   Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
>       Array Size : 976629568 (931.39 GiB 1000.07 GB)
>    Used Dev Size : 1953259136 (931.39 GiB 1000.07 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=261864 sectors, after=1840 sectors
>            State : active
>      Device UUID : 4bbfbe7a:457829a5:dd9d2e3c:15818bca
> 
>      Update Time : Thu Aug 28 01:00:03 2025
>    Bad Block Log : 512 entries available at offset 264 sectors
>         Checksum : 144ff0ef - correct
>           Events : 38185
> 
> 
> 

