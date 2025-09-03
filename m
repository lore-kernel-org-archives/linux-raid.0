Received: from mx.febas.net (mx.febas.net [168.119.129.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48D3305070
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 13:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.129.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756905636; cv=none; b=re/1g+RivRSNsfLxI+QpTX2DHLxbbVXGqnca7MhONheycrtHrnLYbqvnpIX5P5Fb0UzPDn8ffNU3kZMaL09aMn8IpqWhe5k0OKeUYl3W6V8BIpiWG/8kub1PFrziidKXKuYFb+ey2Ua4wGFFPebYAL+mi3M04SIbprjhS+mONKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756905636; c=relaxed/simple;
	bh=wWXbp1gYh08ByoIz0hDr7k0PZSkfLsMlHnbL1RBuYtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VCbKlgr6opduT5bl7QgaQE/LMTTpavBVwLF6BreMny5jFC8yZZ34CLrQ19zOkL9YUczQ7HMaDYEcJLxmZdCnzuBItTta/+fs+0mIecd4PlZTPeZY1nyUqQpOwhn3d9T5CFX+qMar3t1Ee1iFC+jCie6umK1b+lUzS25Tb+7A/kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de; spf=pass smtp.mailfrom=peter-speer.de; arc=none smtp.client-ip=168.119.129.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peter-speer.de
Received: from mx.febas.net (localhost [127.0.0.1])
	by mx.febas.net (Proxmox) with ESMTP id D8B8F6134B;
	Wed,  3 Sep 2025 15:20:29 +0200 (CEST)
Message-ID: <f5b4a63a-708a-40ab-a2c5-6dc348c6eed8@peter-speer.de>
Date: Wed, 3 Sep 2025 15:20:26 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
To: Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
 <f8117d4a-d0d7-46ad-95ec-1eb8374a692d@thelounge.net>
Content-Language: de-DE
From: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
In-Reply-To: <f8117d4a-d0d7-46ad-95ec-1eb8374a692d@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 1.0.7 at mail.febas.net
X-Virus-Status: Clean

Hi Harald.
Thanks for your Answer and the script.

Setup is not GPT, no UUID-Problems.

Should I fail/remove first or is it not mandatory?
mdadm --manage /dev/md0 --fail /dev/sdb1
mdadm --manage /dev/md0 --remove /dev/sdb1

Then clone partiton data
sfdisk -d /dev/sda | sfdisk /dev/sdX --force

(/dev/sdX = new HD, /dev/sda = remaining old HD, not removed from array)

followed by
mdadm --manage /dev/md0 --add /dev/sdX

And if synced install grub
grub[2]-install /dev/sdX

Thanks for a short review.


On 03.09.25 14:19, Reindl Harald wrote:
> makes no sense especially in case of RAID1
> 
>   * shut down the computer
>   * replace one disk
>   * boot
>   * resync RAID
> 
> the old disk is 100% identical and can be seen as a full backup
> 
> the whole purpose of RAID is that you can replace disks, frankly it's 
> desigend to survive a exploding disk at full operations
> 
> also you should know what to do when a disk dies - the excatly same 
> steps with the difference that your old replaced disk currently is a 
> 100% fallback even if you confuse source/target and destroy everything
> 
> --------------
> 
> in case it's a BIOS setup you can clone the whole partitioning with dd 
> of the first 512 blocks
> 
> the script below is from a setup with 3 RAID1 and doe sthe whole stuff 
> including install GRUB2 on the new disk - for UEFI you need some steps 
> more because UUIDs must be unique
> 
>   * boot
>   * system
>   * data
> 
> 
> [root@south:~]$ cat /scripts/raid-recovery.sh
> #!/usr/bin/bash
> # define source and target
> GOOD_DISK="/dev/sda"
> BAD_DISK="/dev/sdb"
> # clone MBR
> dd if=$GOOD_DISK of=$BAD_DISK bs=512 count=1
> # force OS to read partition tables
> partprobe $BAD_DISK
> # start RAID recovery
> mdadm /dev/md0 --add ${BAD_DISK}1
> mdadm /dev/md1 --add ${BAD_DISK}3
> mdadm /dev/md2 --add ${BAD_DISK}2
> # print RAID status on screen
> sleep 5
> cat /proc/mdstat
> # install bootloader on replacement disk
> grub2-install "$BAD_DISK"
> 
> Am 03.09.25 um 13:55 schrieb Stefanie Leisestreichler (Febas):
>> Hi.
>> I have the system layout shown below.
>>
>> To avoid data loss, I want to change HDs which have about 46508 hours 
>> of up time.
>>
>> I thought, instead of degrading, formatting, rebuilding and so on, I 
>> could
>> - shutdown the computer
>> - take i.e. /dev/sda and do
>> - dd bs=98304 conv=sync,noerror if=/dev/sda of=/dev/sdX (X standig for 
>> device name of new disk)
>>
>> Is it save to do it this way, presuming the array is in AA-State?
>>
>> Thanks,
>> Steffi
>>
>> /dev/sda1:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x0
>>       Array UUID : 68c0c9ad:82ede879:2110f427:9f31c140
>>             Name : speernix15:0  (local to host speernix15)
>>    Creation Time : Sun Nov 30 19:15:35 2014
>>       Raid Level : raid1
>>     Raid Devices : 2
>>
>>   Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
>>       Array Size : 976629568 (931.39 GiB 1000.07 GB)
>>    Used Dev Size : 1953259136 (931.39 GiB 1000.07 GB)
>>      Data Offset : 262144 sectors
>>     Super Offset : 8 sectors
>>     Unused Space : before=261864 sectors, after=1840 sectors
>>            State : active
>>      Device UUID : 5871292c:7fcfbd82:b0a28f1b:df7774f9
>>
>>      Update Time : Thu Aug 28 01:00:03 2025
>>    Bad Block Log : 512 entries available at offset 264 sectors
>>         Checksum : b198f5d1 - correct
>>           Events : 38185
>>
>>     Device Role : Active device 0
>>     Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
>> /dev/sdb1:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x0
>>       Array UUID : 68c0c9ad:82ede879:2110f427:9f31c140
>>             Name : speernix15:0  (local to host speernix15)
>>    Creation Time : Sun Nov 30 19:15:35 2014
>>       Raid Level : raid1
>>     Raid Devices : 2
>>
>>   Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
>>       Array Size : 976629568 (931.39 GiB 1000.07 GB)
>>    Used Dev Size : 1953259136 (931.39 GiB 1000.07 GB)
>>      Data Offset : 262144 sectors
>>     Super Offset : 8 sectors
>>     Unused Space : before=261864 sectors, after=1840 sectors
>>            State : active
>>      Device UUID : 4bbfbe7a:457829a5:dd9d2e3c:15818bca
>>
>>      Update Time : Thu Aug 28 01:00:03 2025
>>    Bad Block Log : 512 entries available at offset 264 sectors
>>         Checksum : 144ff0ef - correct
>>           Events : 38185


