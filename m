Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9F61E481
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 12:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716466851; cv=none; b=UMdo9mst0xYJH8XVXUe73pXmgT1MWkv8Jj/uSzC3/jiIhT4O8hQkrmUh6VSpDMtjEf6Xd3C8TDKczYPBjgxNZkB+PjvuzAKz/y4Yg5+HquOoGMTD6Cc/13f9gKSP/KtNKPPYt4k6HRstIKSDWqS5WgALeIGD7UXe3SwI+AHzRxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716466851; c=relaxed/simple;
	bh=aETsU+ZVwMxmXTxZOexTFzSEqH1DNjx7NM9ts0R4RLI=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Hgx6+7UXpdx73wZF0Prdin40Hq9tWAHvDT8CIeyJfHG3ZDUjT3nZTFhmo2Y6TU+WKRZKp0eYl/shFOFinreDlFEs2IdcYwfsNKpfLwWkPFJflxK7tlY1Ibn+MC67L8o94vNEzQ6FsubXV4cHRjKx1JnGWqgebKMmAXOXOKcGt0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VlS1Z3Ptyz4f3lfQ
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 20:20:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 046C81A0FAE
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 20:20:45 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX6RGUNE9mVPjUNQ--.7237S3;
	Thu, 23 May 2024 20:20:37 +0800 (CST)
Subject: Re: RAID-1 not accessible after disk replacement
To: Richard <richard@radoeka.nl>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <1910147.LkxdtWsSYb@selene>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <26966548-7e1e-d187-4694-2056e2ecb04d@huaweicloud.com>
Date: Thu, 23 May 2024 20:20:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1910147.LkxdtWsSYb@selene>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX6RGUNE9mVPjUNQ--.7237S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtr4xJr48Jr43XrWfWr45Jrb_yoW7tryDpa
	yftFyxurWktw1xW3s7Z3W2g3WFkFyfCr45Xr1F9r18K3s8K3s7XF18GrWFva4qvry0g3Zr
	ZayDWr9FvF98JFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/05/23 19:47, Richard Ð´µÀ:
> Hello,
> 
> I was reference to this mailinglist via the https://raid.wiki.kernel.org/
> index.php/RAID_Recovery page, "Make sure to contact someone who's experienced
> in dealing with md RAID problems and failures - either someone you know in
> person, or, alternatively, the friendly and helpful folk linux-raid mailing
> list".
> 
> 
> As I've a problem with an RAID-1 array after replacing a failed disk, I hope
> that you can help me to make it at least readable again.
> 
> 
> 
> Information about the RAID:
> 
> /dev/sda3 is the disk partition that has the data on it.
> /dev/sdb6 is the new disk partition - no data on it.
> 
> 
> Information of the involved RAID before the disk replacement:
> 
> /dev/md126:
>             Version : 1.0
>       Creation Time : Sat Apr 29 20:30:27 2017
>          Raid Level : raid1
>          Array Size : 247464768 (236.00 GiB 253.40 GB)
>       Used Dev Size : 247464768 (236.00 GiB 253.40 GB)
> 
> I grew (--grow) the RAID to an smaller size as it was complaining about the
> size (no logging of that).

This is insane, there is no way ext4 can mount again. And what's
worse, looks like you're doing this with ext4 still mounted.

> After the this action the RAID was functioning and fully accessible.
> 
> After reboot the RAID is not accessible anymore.
> 
> The actual data on the RAID is about 37GB.
> 
> After reboot it became md125.
> 
> [   23.872267] md/raid1:md125: active with 1 out of 2 mirrors
> [   23.903300] md125: detected capacity change from 0 to 488636416
> 2024-05-23T12:13:29.708106+02:00 cloud kernel: [  632.338266][ T2913] EXT4-fs
> (md125): bad geometry: block count 6186598
> 4 exceeds size of device (61079552 blocks)

And kernel log already told you the reason.

I'll suggest you to grow the raid to it's orginal size, however, there
is no guarantee you won't lost your data.

Thanks,
Kuai

> 
> 
> # mount /dev/md125 /srv
> mount: /srv: wrong fs type, bad option, bad superblock on /dev/md125, missing
> codepage or helper program, or other error
> 
> # LANG=C fsck /dev/md125
> fsck from util-linux 2.37.4
> e2fsck 1.46.4 (18-Aug-2021)
> The filesystem size (according to the superblock) is 61865984 blocks
> The physical size of the device is 61079552 blocks
> Either the superblock or the partition table is likely to be corrupt!
> 
> # cat /proc/mdstat
> md125 : active raid1 sda3[2]
>       244318208 blocks super 1.0 [2/1] [U_]
>       bitmap: 1/2 pages [4KB], 65536KB chunk
> mdadm --detail /dev/md125
> /dev/md125:
>            Version : 1.0
>      Creation Time : Sat Apr 29 20:30:27 2017
>         Raid Level : raid1
>         Array Size : 244318208 (233.00 GiB 250.18 GB)
>      Used Dev Size : 244318208 (233.00 GiB 250.18 GB)
>       Raid Devices : 2
>      Total Devices : 1
>        Persistence : Superblock is persistent
> 
>      Intent Bitmap : Internal
> 
>        Update Time : Mon May 20 18:40:03 2024
>              State : clean, degraded
>     Active Devices : 1
>    Working Devices : 1
>     Failed Devices : 0
>      Spare Devices : 0
> 
> Consistency Policy : bitmap
> 
>               Name : any:srv
>               UUID : d96112c1:4c249022:96b4488c:642e84a6
>             Events : 576774
> 
>     Number   Major   Minor   RaidDevice State
>        2       8        3        0      active sync   /dev/sda3
>        -       0        0        1      removed
> 
> # LANG=C fdisk -l /dev/sda
> Disk /dev/sda: 465.76 GiB, 500107862016 bytes, 976773168 sectors
> Disk model: WDC WD5000LPCX-2
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disklabel type: dos
> Disk identifier: 0xc28b197d
> Apparaat   Op.     Begin     Einde  Sectoren Grootte ID Type
> /dev/sda3       46139392 891291647 845152256    403G fd Linux raidautodetectie
> 
> 
> # LANG=C fdisk -l /dev/sdb
> Disk /dev/sdb: 298.09 GiB, 320072933376 bytes, 625142448 sectors
> Disk model: WDC WD3200BUCT-6
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disklabel type: dos
> Disk identifier: 0x975182e6
> Device     Boot     Start       End   Sectors   Size Id Type
> /dev/sdb6       136321024 625142447 488821424 233.1G fd Linux raid autodetect
> 
> # mdadm --examine /dev/sda3
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : d96112c1:4c249022:96b4488c:642e84a6
>            Name : any:srv
>   Creation Time : Sat Apr 29 20:30:27 2017
>      Raid Level : raid1
>    Raid Devices : 2
> 
> Avail Dev Size : 845151976 sectors (403.00 GiB 432.72 GB)
>      Array Size : 244318208 KiB (233.00 GiB 250.18 GB)
>   Used Dev Size : 488636416 sectors (233.00 GiB 250.18 GB)
>    Super Offset : 845152240 sectors
>    Unused Space : before=0 sectors, after=356515808 sectors
>           State : clean
>     Device UUID : d75cd979:3401034d:41932cc1:4c98b232
> 
> Internal Bitmap : -16 sectors from superblock
>     Update Time : Mon May 20 18:40:03 2024
>   Bad Block Log : 512 entries available at offset -8 sectors
>        Checksum : f6864782 - correct
>          Events : 576774
> 
> 
>    Device Role : Active device 0
>    Array State : A. ('A' == active, '.' == missing, 'R' == replacing)
> 
> 
> # mdadm --examine /dev/sdb6
> /dev/sdb6:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : d96112c1:4c249022:96b4488c:642e84a6
>            Name : any:srv
>   Creation Time : Sat Apr 29 20:30:27 2017
>      Raid Level : raid1
>    Raid Devices : 2
> 
> Avail Dev Size : 488821392 sectors (233.09 GiB 250.28 GB)
>      Array Size : 244318208 KiB (233.00 GiB 250.18 GB)
>   Used Dev Size : 488636416 sectors (233.00 GiB 250.18 GB)
>    Super Offset : 488821408 sectors
>    Unused Space : before=0 sectors, after=184976 sectors
>           State : clean
>     Device UUID : c077a12d:9ba6c3a0:9c5749ba:600e9aef
> 
> Internal Bitmap : -16 sectors from superblock
>     Update Time : Mon May 20 18:15:52 2024
>   Bad Block Log : 512 entries available at offset -8 sectors
>        Checksum : 899ae2ec - correct
>          Events : 576771
> 
> 
>    Device Role : Active device 1
>    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
> 
> 
> Is there anything that can be done, to access the data on /dev/sda3?
> 
> 
> 
> --
> Thanks in advance,
> 
> 
> Richard
> 
> 
> 
> 
> .
> 

