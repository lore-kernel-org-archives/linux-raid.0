Received: from mallaury.nerim.net (smtp-104-thursday.noc.nerim.net [178.132.17.104])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9296633F0
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.132.17.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706194636; cv=none; b=n9nBLq/Wtcd96nBLdfoF141dFm6eWiRnW2ULm4TryFZECZK6cfcTKVjQMViC/nes1X4A+/daKbXSdmDcsBGB+/579DEePrOcpSm90oah2cdFhhm9NjXjWBkZnNYBG62lXkVcJIlBq0jYl8h903A4MyvsIpuKLqxhf0aGDa26lA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706194636; c=relaxed/simple;
	bh=zG4Mms9RGYqnolfeec0tsY19jV523MJRGisUtnLS5Tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fiMCRC9KwQkibqTn1nMHaku/YtIGjFPhDBnCRJCBTE4ERhsv+jbUtAqf5fiqnEmMjpBS7QkHvSyg4f6FAiGPfakchvKGYbMDgm9SBBm88mvOq3I3O1ui1EAulS27nAhKOo5A4gRcRana2T8qll33vnC1Dt2L9voyVLz1+j1PLCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=178.132.17.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
	by mallaury.nerim.net (Postfix) with ESMTPS id 72BA8DB17C
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 15:57:08 +0100 (CET)
Message-ID: <ab04e35d-b099-441b-b829-428a2c9c2dd8@plouf.fr.eu.org>
Date: Thu, 25 Jan 2024 15:57:07 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Requesting help recovering my array
Content-Language: en-US
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
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
 <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org>
 <1822211334.391999.1706183367969@mail.yahoo.com>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <1822211334.391999.1706183367969@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/01/2024 at 12:49, RJ Marquette wrote:
> root@jackie:/home/rj# /sbin/fdisk -l /dev/sdb
> Disk /dev/sdb: 2.73 TiB, 3000592982016 bytes, 5860533168 sectors
> Disk model: Hitachi HUS72403
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disklabel type: gpt
> Disk identifier: AF5DC5DE-1404-4F4F-85AF-B5574CD9C627
> 
> Device     Start        End    Sectors  Size Type
> /dev/sdb1   2048 5860532223 5860530176  2.7T Microsoft basic data
> 
> root@jackie:/home/rj# cat /sys/block/sdb/sdb1/start
> 2048
> root@jackie:/home/rj# cat /sys/block/sdb/sdb1/size
> 5860530176

The partition geometry looks correct, with standard alignment.
And the kernel view of the partition matches the partition table.
The partition type "Microsoft basic data" is neither "Linux RAID" nor 
the default type "Linux flesystem" set by usual GNU/Linux partitioning 
tools such as fdisk, parted and gdisk so it seems unlikely that the 
partition was created with one of these tools.

>>> It looks like this is what happened after all.  I searched for "MBR
>>> Magic aa55" and found someone else with the same issue long ago:
>>> https://serverfault.com/questions/580761/is-mdadm-raid-toast  Looks like
>>> his was caused by a RAID configuration option in BIOS.  I recall seeing
>>> that on mine; I must have activated it by accident when setting the boot
>>> drive or something.

I am a bit suspicious about this cause for two reasons:
- sde, sdf and sdg are affected even though they are connected to the 
add-on Marvell SATA controller card which is supposed to be outside the 
motherboard RAID scope;
- sdc is not affected even though it is connected to the onboard Intel 
SATA controller.

What was contents type of the RAID array ? LVM, LUKS, plain filesystem ?
