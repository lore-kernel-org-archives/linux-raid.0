Received: from beast.visionsuite.biz (beast.visionsuite.biz [85.163.23.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81012189539
	for <linux-raid@vger.kernel.org>; Fri, 23 Aug 2024 15:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.163.23.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724428512; cv=none; b=ArVW2MGeBXeICmraYPA89MH41LsmnUq5ORlBCl3eNLzerT91pXS/SYg241ij31MUB4UzzSa1xQkLE/11eJlfWecX+fy7OtuAZ5fqdWbN0hH3/rh41WowKvfLESs5CoYIf5WVAx4NZBZBbbETQPMdLIhXe9XNTMA8/4Wh8zxnmhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724428512; c=relaxed/simple;
	bh=ohPzeZ1cyjtvdL9Mmob4nbEv9JUckrAJuwalZlWSB6k=;
	h=MIME-Version:Date:From:To:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=TaKjmdqATRnH1UO/VMjws6Y+NCL0eCsVcCHa6/yNMkvksU+9DszsHPsv3rII3rKjXhEmCa+vXCiQpSOlsHBR14tW9GZOCUCS8BlxLwq/EuEo6vW55pnfU6Voi53Vaeh1jUXz6B9+E5RmFlWk9ACoO8oQDjBCpYclx2zyDCW5Qec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fordfrog.com; spf=pass smtp.mailfrom=fordfrog.com; dkim=pass (1024-bit key) header.d=fordfrog.com header.i=@fordfrog.com header.b=FttXIQnz; arc=none smtp.client-ip=85.163.23.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fordfrog.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fordfrog.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fordfrog.com header.i=@fordfrog.com header.b="FttXIQnz"
Received: from localhost (beast.visionsuite.biz [127.0.0.1])
	by beast.visionsuite.biz (Postfix) with ESMTP id 216254E1F2B5
	for <linux-raid@vger.kernel.org>; Fri, 23 Aug 2024 17:54:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at visionsuite.biz
Received: from beast.visionsuite.biz ([127.0.0.1])
	by localhost (beast.visionsuite.biz [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id tBEv5H9EPYu6 for <linux-raid@vger.kernel.org>;
	Fri, 23 Aug 2024 17:54:58 +0200 (CEST)
Received: from roundcube.visionsuite.biz (beast.visionsuite.biz [127.0.0.1])
	by beast.visionsuite.biz (Postfix) with ESMTPA id 4FF5D4E1F2A6
	for <linux-raid@vger.kernel.org>; Fri, 23 Aug 2024 17:54:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fordfrog.com;
	s=beast; t=1724428498;
	bh=fldzPiZjBAAD0/A6kTLVYNmd9M22tczuOwXfDorI5K4=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=FttXIQnzJtV6goBD6VQf/mU99AR8r/CFgIeAcAlptJ3tuIOpzk53Q0LCbAmwN64PD
	 C0esElu+09W7U6KefBpSA5inOUQCYDSpXsbFbGEFVe3qApHp0yRzYXL0LEutgM6gWm
	 jAKKAKkvcX7+uQgsk3AYg6DGA3RhnY40Bi1zkajU=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 23 Aug 2024 17:54:58 +0200
From: =?UTF-8?Q?Miroslav_=C5=A0ulc?= <miroslav.sulc@fordfrog.com>
To: linux-raid@vger.kernel.org
Subject: Re: problem with synology external raid
In-Reply-To: <20240823135041.00003e05@linux.intel.com>
References: <d963fc43f8a7afee7f77d8ece450105f@fordfrog.com>
 <20240823135041.00003e05@linux.intel.com>
Message-ID: <7586a690b53ca45fafc6fd0d6700315f@fordfrog.com>
X-Sender: miroslav.sulc@fordfrog.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

hi Mariusz, thanks for your reply. please find my comments below.

Dne 2024-08-23 13:56, Mariusz Tkaczyk napsal:
> On Thu, 22 Aug 2024 17:02:52 +0200
> Miroslav Šulc <miroslav.sulc@fordfrog.com> wrote:
> 
>> hello,
>> 
>> a broken synology raid5 ended up on my desk. the raid was broken for
>> quite some time, but i got it from the client just a few days back.
>> 
>> the raid consisted of 5 disks (no spares, all used):
>> disk 1 (sdca): according to my understanding, it was removed from the
>> raid, then re-added, but the synchronization was interrupted, so it
>> cannot be used to restore the raid
> 
> Hi Miroslav,
> (If I send something earlier - sorry missclick)
> 
>    Array State : AAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
>    Events : 60223
> 
> There is no info about interrupted rebuild in the metadata. This drive
> looks like removed from array, it has old Events number. If it was
> rebuilt, it finished correctly.

there is this line in the metadata from which i supposed the rebuild 
didn't finish:

Recovery Offset : 4910216 sectors

i also tried to recreate the raid from disks 1, 2, 4, and 5, using 
--assume-clean. the raid was set up, i was able to read lvm from the 
raid, but when i checked the btrfs filesystem on it or tried to mount 
it, i faced a serious corruption of the filesystem. btrfs recovery 
recovered nothing.

> The metadata on the drive is frozen on the last state of the device in 
> array,
> other members were updated that this device is gone.
> 
>> disk 2 (sdcb): is ok and up to date
>> disk 3 (sdcc): seems to be up to date, still spinning, but there are
>> many issues with bad sectors
> 
>            Events : 60283
> 
>            Layout : left-symmetric
>        Chunk Size : 64K
> 
>      Device Role : Active device 2
>      Array State : .AAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> 
> It is outdated, Events number is smaller than on "ok" members. Sadly, 
> probably
> mdadm will refuse to start this array because you have 2 outdated 
> drives.

i was able to start the array from disks 2-4 in degraded mode. i even 
tried to add disk 1 to the array and rebuild it, but that failed. my 
guess is it was because of disk 3.

> 
> On "ok" disks, it is:
>  Events : 60286
> Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> Second failure is not recorded in metadata and I don't know why events 
> number is
> higher. I would expect kernel to stop updating metadata after device 
> failure.
> 
> I will stop here and give a chance more native experienced users to 
> elaborate.
> 
> Looks like raid recreation with --assume-clean is a simplest solution 
> but it
> is general advice I can give you (and I propose it too often). You have 
> copies,
> you did right first step!
> 
> Mariusz
> 
>> disk 4 (sdcd): is ok and up to date
>> disk 5 (sdce): is ok and up to date
>> 
>> the raid ran in degraded mode for over two months, client trying to 
>> make
>> a copy of the data from it.
>> 
>> i made copies of the disk images from disks 1, 2, 4, and 5, at the 
>> state
>> shown below. i didn't attempt to make a copy of disk 3 so far. since
>> then i re-assembled the raid from disk 2-5 so the number of events on
>> the disk 3 is now a bit higher then on the copies of the disk images.
>> 
>> according to my understanding, as the disk 1 never finished the sync, 
>> i
>> cannot use it to recover the data, so the only way to recover the data
>> is to assemble the raid in degraded mode using disk 2-5, if i ever
>> succeed to make a copy of the disk 3. i'd just like to verify that my
>> understanding is correct and there is no other way to attempt to 
>> recover
>> the data. of course any hints are welcome.
>> 
>> here is the info from the partitions of the raid:
>> 
>> /dev/sdca5:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x2
>>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>>             Name : DS_KLIENT:4
>>    Creation Time : Tue Mar 31 11:40:19 2020
>>       Raid Level : raid5
>>     Raid Devices : 5
>> 
>>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>>      Data Offset : 2048 sectors
>>     Super Offset : 8 sectors
>> Recovery Offset : 4910216 sectors
>>     Unused Space : before=1968 sectors, after=0 sectors
>>            State : clean
>>      Device UUID : 681c6c33:49df0163:bb4271d4:26c0c76d
>> 
>>      Update Time : Tue Jun  4 18:35:54 2024
>>         Checksum : cf45a6c1 - correct
>>           Events : 60223
>> 
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>> 
>>     Device Role : Active device 0
>>     Array State : AAAAA ('A' == active, '.' == missing, 'R' == 
>> replacing)
>> /dev/sdcb5:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x0
>>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>>             Name : DS_KLIENT:4
>>    Creation Time : Tue Mar 31 11:40:19 2020
>>       Raid Level : raid5
>>     Raid Devices : 5
>> 
>>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>>      Data Offset : 2048 sectors
>>     Super Offset : 8 sectors
>>     Unused Space : before=1968 sectors, after=0 sectors
>>            State : clean
>>      Device UUID : 0f23d7cd:b93301a9:5289553e:286ab6f0
>> 
>>      Update Time : Wed Aug 14 15:09:24 2024
>>         Checksum : 9c93703e - correct
>>           Events : 60286
>> 
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>> 
>>     Device Role : Active device 1
>>     Array State : .AAAA ('A' == active, '.' == missing, 'R' == 
>> replacing)
>> /dev/sdcc5:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x0
>>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>>             Name : DS_KLIENT:4
>>    Creation Time : Tue Mar 31 11:40:19 2020
>>       Raid Level : raid5
>>     Raid Devices : 5
>> 
>>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>>      Data Offset : 2048 sectors
>>     Super Offset : 8 sectors
>>     Unused Space : before=1968 sectors, after=0 sectors
>>            State : clean
>>      Device UUID : 1d1c04b4:24dabd8d:235afb7d:1494b8eb
>> 
>>      Update Time : Wed Aug 14 12:42:26 2024
>>         Checksum : a224ec08 - correct
>>           Events : 60283
>> 
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>> 
>>     Device Role : Active device 2
>>     Array State : .AAAA ('A' == active, '.' == missing, 'R' == 
>> replacing)
>> /dev/sdcd5:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x0
>>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>>             Name : DS_KLIENT:4
>>    Creation Time : Tue Mar 31 11:40:19 2020
>>       Raid Level : raid5
>>     Raid Devices : 5
>> 
>>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>>      Data Offset : 2048 sectors
>>     Super Offset : 8 sectors
>>     Unused Space : before=1968 sectors, after=0 sectors
>>            State : clean
>>      Device UUID : 76698d3f:e9c5a397:05ef7553:9fd0af16
>> 
>>      Update Time : Wed Aug 14 15:09:24 2024
>>         Checksum : 38061500 - correct
>>           Events : 60286
>> 
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>> 
>>     Device Role : Active device 4
>>     Array State : .AAAA ('A' == active, '.' == missing, 'R' == 
>> replacing)
>> /dev/sdce5:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x0
>>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>>             Name : DS_KLIENT:4
>>    Creation Time : Tue Mar 31 11:40:19 2020
>>       Raid Level : raid5
>>     Raid Devices : 5
>> 
>>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>>      Data Offset : 2048 sectors
>>     Super Offset : 8 sectors
>>     Unused Space : before=1968 sectors, after=0 sectors
>>            State : clean
>>      Device UUID : 9c7077f8:3120195a:1af11955:6bcebd99
>> 
>>      Update Time : Wed Aug 14 15:09:24 2024
>>         Checksum : 38177651 - correct
>>           Events : 60286
>> 
>>           Layout : left-symmetric
>>       Chunk Size : 64K
>> 
>>     Device Role : Active device 3
>>     Array State : .AAAA ('A' == active, '.' == missing, 'R' == 
>> replacing)
>> 
>> 
>> thank you for your help.
>> 
>> miroslav
>> 
