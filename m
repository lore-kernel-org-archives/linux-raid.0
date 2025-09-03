Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A3C28727F
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 12:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.118.73.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756903075; cv=none; b=KsFLab2zZ0drPiEU+kxHXCjRe1GarEZ5DJzxuV+y0iEqmUbQO1AMcZkeFwiRlKzaHImFLKUg4Zt1dQPMY4x91bdqvQVuqZLJfBthcqWdNpuP0yiWOdxfoI3btYPksBuxa2adkgvoSOdk2+lVgrjEWc6j8BnEo7lTFdCtYAUS3Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756903075; c=relaxed/simple;
	bh=MA6HemaURooJ95AFGpZNrsC9JPcI+lJrOdvRrIYdfXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CKPG+qozevoyiORP2DOMuuampHoXab08exetO5AV63VAZ2Uc+MrcpLZYcNB2zpXoEgmfIVhfRbIMsCaJvJl24dqoV3ndMl9x3/Q2T+dp24OP+ohcerswRBJhcVYvxekksYWPBCi3GOaj0/PXZiTZMmeoDg+J1bqxCS5UwJklcwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net; spf=pass smtp.mailfrom=thelounge.net; arc=none smtp.client-ip=91.118.73.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelounge.net
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: h.reindl@thelounge.net)
	by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4cH1rH3Fk6zXLl;
	Wed, 03 Sep 2025 14:19:27 +0200 (CEST)
Message-ID: <f8117d4a-d0d7-46ad-95ec-1eb8374a692d@thelounge.net>
Date: Wed, 3 Sep 2025 14:19:27 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
Content-Language: en-US
To: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
From: Reindl Harald <h.reindl@thelounge.net>
Autocrypt: addr=h.reindl@thelounge.net; keydata=
 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
 K4rYsjPimkSIVdrNM//wVKdCTbO+
Organization: the lounge interactive design
In-Reply-To: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

makes no sense especially in case of RAID1

  * shut down the computer
  * replace one disk
  * boot
  * resync RAID

the old disk is 100% identical and can be seen as a full backup

the whole purpose of RAID is that you can replace disks, frankly it's 
desigend to survive a exploding disk at full operations

also you should know what to do when a disk dies - the excatly same 
steps with the difference that your old replaced disk currently is a 
100% fallback even if you confuse source/target and destroy everything

--------------

in case it's a BIOS setup you can clone the whole partitioning with dd 
of the first 512 blocks

the script below is from a setup with 3 RAID1 and doe sthe whole stuff 
including install GRUB2 on the new disk - for UEFI you need some steps 
more because UUIDs must be unique

  * boot
  * system
  * data


[root@south:~]$ cat /scripts/raid-recovery.sh
#!/usr/bin/bash
# define source and target
GOOD_DISK="/dev/sda"
BAD_DISK="/dev/sdb"
# clone MBR
dd if=$GOOD_DISK of=$BAD_DISK bs=512 count=1
# force OS to read partition tables
partprobe $BAD_DISK
# start RAID recovery
mdadm /dev/md0 --add ${BAD_DISK}1
mdadm /dev/md1 --add ${BAD_DISK}3
mdadm /dev/md2 --add ${BAD_DISK}2
# print RAID status on screen
sleep 5
cat /proc/mdstat
# install bootloader on replacement disk
grub2-install "$BAD_DISK"

Am 03.09.25 um 13:55 schrieb Stefanie Leisestreichler (Febas):
> Hi.
> I have the system layout shown below.
> 
> To avoid data loss, I want to change HDs which have about 46508 hours of 
> up time.
> 
> I thought, instead of degrading, formatting, rebuilding and so on, I could
> - shutdown the computer
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
