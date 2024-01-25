Received: from plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E55C2C69D
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 10:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706179793; cv=none; b=oZlpJTtWv7WzFi2Hq/T0SkDPi9vGqP68GuWbn6Q2VgK0SsUSSP6+E5oz1VLwC2AZS3E0+ZvuUFNaN4t43X01x3jMBM0PBj1EdFXxLNbXCLDmP7p6Dh+4Nnks7rR5c7umgXQzlD+4qY6bbQe1AyIUFCV4UPwyjDdPTbDT52mx2jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706179793; c=relaxed/simple;
	bh=kUWnHdQkwkWmUME72TtPPotQqmMNmMGRyqlXrU+E1B4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ra7vLFrBb41nRjV1DbsoD8oM9MTFXB+a4klbMTvJIZpWCi5ZPnTubZ9JvwFVMGcsclsBjrRageG4Dcvu0HJGxKQ29n1o6NVgpO3uI13Uj+QbKk9cCvqqYW95LpIRQa1WtX6oDwCpCM6yirUmOfaC2GYHQF8cCsyV/8TVKnar9Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Message-ID: <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org>
Date: Thu, 25 Jan 2024 10:49:32 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Requesting help recovering my array
To: RJ Marquette <rjm1@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
 <432300551.863689.1705953121879@mail.yahoo.com>
 <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
 <1085291040.906901.1705961588972@mail.yahoo.com>
 <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net>
 <598555968.936049.1705968542252@mail.yahoo.com>
 <755754794.951974.1705974751281@mail.yahoo.com>
 <20240123110624.1b625180@firefly>
 <12445908.1094378.1706026572835@mail.yahoo.com>
 <20240123221935.683eb1eb@firefly>
 <1979173383.106122.1706098632056@mail.yahoo.com>
 <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl>
 <2058198167.201827.1706119581305@mail.yahoo.com>
 <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
 <544664840.269616.1706131905741@mail.yahoo.com>
 <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
 <5112393.323817.1706145196938@mail.yahoo.com>
 <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com>
Content-Language: en-US
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/01/2024 at 02:57, Roger Heflin wrote:
> 
> dd if=/dev/zero of=/dev/sdb bs=512 count=1     (for each disk).

I'm afraid it won't help.
As far as I can see, having an MBR signature in the first sector does 
not prevent blkid or mdadm from detecting the RAID superblock.
Also, previous mail from the OP show that the disks have GPT partition 
tables (as expected with 3 TiB) which usually span (~16 KiB) beyond the 
beginning of the 1.2 RAID superblock (4 KiB) so I suspect that the RAID 
superblock was overwritten.

A tiny hope is that the RAID member was actually in a partition but the 
geometry in the partition table is wrong or the kernel does not read it 
properly (I have seen this once). You can check the partition table and 
how the kernel sees the partition with

fdisk -l /dev/sdb
cat /sys/block/sdb/sdb1/start
cat /sys/block/sdb/sdb1/size

> On Wed, Jan 24, 2024 at 7:13â€¯PM RJ Marquette <rjm1@yahoo.com> wrote:
>>
>> It looks like this is what happened after all.  I searched for "MBR Magic aa55" and found someone else with the same issue long ago:  https://serverfault.com/questions/580761/is-mdadm-raid-toast  Looks like his was caused by a RAID configuration option in BIOS.  I recall seeing that on mine; I must have activated it by accident when setting the boot drive or something.
>>
>> I swapped the old motherboard back in, no improvement, so I'm back to the new one.  I'm now running testdisk to see if I can repair the partition table.
