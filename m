Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E34F339A0
	for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 06:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726640901; cv=none; b=qhq0Zx2TqW1+1uKddagp0HkQWgmbUyP5ZRhmwBZuGe287AnpZpo/dyQfmXhZPEnAWHV3MIajq8npOYSxyn2c5ieJ9m+fvmXaxeeZsKtUsR4qDRQ8dXyESRJ7PBFObq3QBtYgmrtaBx8omIiQUKnq4duHART/WHZEoMZqwRaLn60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726640901; c=relaxed/simple;
	bh=OkOsLqWqVfnqfYFugozPYgGjzBWPGZdSL0pk2NEBOlA=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jpzQ3OmTTobKRh4CPp5CxJY7McnriDPiL3WGeWFo32PWlD5rEtA0n2npPLoCz0vqNjdF95+RugJlWpWGhsn0KznMUgLAJecP4Q+HvttqEdha8wjkK860384mHQ2S+6aUYmQFkjePjAl7j7PvKdSceDPj2pX9+QO9GeqM7H99wZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4X7pBB3JHGz4f3jsY
	for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 14:08:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 486531A0568
	for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 14:09:06 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAnXMiAbupmxz+VBg--.2607S3;
	Wed, 18 Sep 2024 14:09:06 +0800 (CST)
Subject: Re: RAID 10 reshape is stuck - please help
To: William Morgan <therealbrewer@gmail.com>,
 linux-raid <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com>
Date: Wed, 18 Sep 2024 14:09:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnXMiAbupmxz+VBg--.2607S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF13Kw18Aw4UKFW8GryDWrg_yoW3Ar1fpF
	yrtF1xCw48JrW7AFWaya4jgFy5KF97J3y7Wr98tr9rA3yF9a4ft3yUKr4jga47ursYyrW8
	X345XFW5u3WYvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/09/16 10:47, William Morgan 写道:
> A suggestion was made by Dragan Milivojević to try booting a liveOS
> with the same kernel and mdadm version from the time the array was
> originally made. That would have been Ubuntu 21.10, with kernel 5.13,
> and mdadm v4.2. (That conversation isn't archived here because we
> forgot to hit reply all.)

Perhaps can you try latest kernel?(6.11)
> 
> I was able to complete this task but unfortunately I am afraid it made
> no difference at all. Exactly the same behavior is seen.

You should assemble the array as read-only, so that the reshape won't
start, and you'll able to copy the data.

Thanks,
Kuai

> 
> I'm going to try to enable more verbose logging from my HBA controller.
> 
> On Sun, Sep 15, 2024 at 2:36 PM William Morgan <therealbrewer@gmail.com> wrote:
>>
>> Hello,
>>
>> I posted about this problem several months ago and unfortunately I
>> never received any suggestions. I haven't been able to fix the problem
>> on my own, so I am hoping someone here can help.
>>
>> I have a raid10 array that originally consisted of 6x EXOS 16TB drives
>> connected through an LSI 9601-16e (SAS2116). Needing more space, I
>> added 4 more 16TB drives. I used the following commands to add and
>> grow the array:
>>
>> [2024-06-24 19:38:12] sudo mdadm /dev/md2 --add /dev/sd[i-l]1
>> [2024-06-24 19:39:27] sudo mdadm --grow /dev/md2 --raid-devices=10
>>
>> After 10-11 hours of reshaping (I knew it would take a long time), the
>> reshape seemed to freeze at 22.1% completed.
>>
>> In dmesg I saw the following error:
>>
>> [260007.679410] md: md2: reshape interrupted.
>> [260144.852441] INFO: task md2_reshape:242508 blocked for more than 122 seconds.
>> [260144.852459]       Tainted: G           OE 6.9.3-060903-generic #202405300957
>> [260144.852466] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [260144.852471] task:md2_reshape     state:D stack:0     pid:242508
>> tgid:242508 ppid:2      flags:0x00004000
>> [260144.852484] Call Trace:
>> [260144.852489]  <TASK>
>> [260144.852496]  __schedule+0x279/0x6a0
>> [260144.852512]  schedule+0x29/0xd0
>> [260144.852523]  wait_barrier.part.0+0x180/0x1e0 [raid10]
>> [260144.852544]  ? __pfx_autoremove_wake_function+0x10/0x10
>> [260144.852560]  wait_barrier+0x70/0xc0 [raid10]
>> [260144.852577]  raid10_sync_request+0x177e/0x19e3 [raid10]
>> [260144.852595]  ? __schedule+0x281/0x6a0
>> [260144.852605]  md_do_sync+0xa36/0x1390
>> [260144.852615]  ? __pfx_autoremove_wake_function+0x10/0x10
>> [260144.852628]  ? __pfx_md_thread+0x10/0x10
>> [260144.852635]  md_thread+0xa5/0x1a0
>> [260144.852643]  ? __pfx_md_thread+0x10/0x10
>> [260144.852649]  kthread+0xe4/0x110
>> [260144.852659]  ? __pfx_kthread+0x10/0x10
>> [260144.852667]  ret_from_fork+0x47/0x70
>> [260144.852675]  ? __pfx_kthread+0x10/0x10
>> [260144.852683]  ret_from_fork_asm+0x1a/0x30
>> [260144.852693]  </TASK>
>>
>> Some other info which may be helpful:
>>
>> bill@bill-desk:~$ mdadm --version
>> mdadm - v4.3 - 2024-02-15 - Ubuntu 4.3-1ubuntu2
>>
>> bill@bill-desk:~$ uname -a
>> Linux bill-desk 6.9.3-060903-generic #202405300957 SMP PREEMPT_DYNAMIC
>> Thu May 30 11:39:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
>>
>> bill@bill-desk:~$ sudo mdadm -D /dev/md2
>> /dev/md2:
>>             Version : 1.2
>>       Creation Time : Sat Nov 20 14:29:13 2021
>>          Raid Level : raid10
>>          Array Size : 46877236224 (43.66 TiB 48.00 TB)
>>       Used Dev Size : 15625745408 (14.55 TiB 16.00 TB)
>>        Raid Devices : 10
>>       Total Devices : 10
>>         Persistence : Superblock is persistent
>>
>>       Intent Bitmap : Internal
>>
>>         Update Time : Tue Jun 25 10:05:18 2024
>>               State : clean, reshaping
>>      Active Devices : 10
>>     Working Devices : 10
>>      Failed Devices : 0
>>       Spare Devices : 0
>>
>>              Layout : near=2
>>          Chunk Size : 512K
>>
>> Consistency Policy : bitmap
>>
>>      Reshape Status : 22% complete
>>       Delta Devices : 4, (6->10)
>>
>>                Name : bill-desk:2  (local to host bill-desk)
>>                UUID : 8a321996:5beb9c15:4c3fcf5b:6c8
>> b6005
>>              Events : 77923
>>
>>      Number   Major   Minor   RaidDevice State
>>         0       8       65        0      active sync set-A   /dev/sde1
>>         1       8       81        1      active sync set-B   /dev/sdf1
>>         2       8       97        2      active sync set-A   /dev/sdg1
>>         3       8      113        3      active sync set-B   /dev/sdh1
>>         5       8      209        4      active sync set-A   /dev/sdn1
>>         4       8      193        5      active sync set-B   /dev/sdm1
>>         9       8      177        6      active sync set-A   /dev/sdl1
>>         8       8      161        7      active sync set-B   /dev/sdk1
>>         7       8      145        8      active sync set-A   /dev/sdj1
>>         6       8      129        9      active sync set-B   /dev/sdi1
>>
>> bill@bill-desk:~$ cat /proc/mdstat
>> Personalities : [raid10] [raid0] [raid1] [raid6] [raid5] [raid4]
>> md1 : active raid10 sdd1[3] sdc1[2] sdb1[1] sda1[0]
>>        15627786240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>>        bitmap: 0/117 pages [0KB], 65536KB chunk
>>
>> md2 : active raid10 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdn1[5] sdh1[3]
>> sdf1[1] sde1[0] sdg1[2] sdm1[4]
>>        46877236224 blocks super 1.2 512K chunks 2 near-copies [10/10]
>> [UUUUUUUUUU]
>>        [====>................]  reshape = 22.1%
>> (10380906624/46877236224) finish=2322382.1min speed=261K/sec
>>        bitmap: 59/146 pages [236KB], 262144KB chunk
>>
>> unused devices: <none>
>>
>> In the meantime I have rebooted several times, done some system
>> software updates, etc. Nothing has improved or fixed it.
>>
>> I just have no idea how to help this along. It won't finish the
>> reshape, and i can't mount the array to copy the data off. I have
>> enough spare disk space to copy the data to a temporary home if I
>> could access it, but the array won't mount. Or, I don't know if it is
>> safe to attempt to mount it. Recently one difference I've noticed is
>> that upon rebooting, the array is called md127 instead of md2 as
>> before.
>>
>> BTW, md1 is an unrelated array on the same system, and it's working
>> fine. Upon reboot, the reshape begins, but 4 seconds later it is
>> interrupted:
>>
>> [    2.451982] md/raid10:md1: active with 4 out of 4 devices
>> [    2.471053] md1: detected capacity change from 0 to 31255572480
>> [    2.517951] md/raid10:md127: not clean -- starting background reconstruction
>> [    2.517956] md/raid10:md127: active with 10 out of 10 devices
>> [    2.541203] md127: detected capacity change from 0 to 93754472448
>> [    2.928687] raid6: sse2x4   gen()  7064 MB/s
>> [    2.945680] raid6: sse2x2   gen()  8468 MB/s
>> [    2.962690] raid6: sse2x1   gen()  6369 MB/s
>> [    2.962691] raid6: using algorithm sse2x2 gen() 8468 MB/s
>> [    2.979680] raid6: .... xor() 7029 MB/s, rmw enabled
>> [    2.979682] raid6: using ssse3x2 recovery algorithm
>> [    5.946619] EXT4-fs (md1): mounted filesystem
>> 8f645711-4d2b-42bf-877c-a8c993923a7c r/w with ordered data mode. Quota
>> mode: none.
>> [  401.676363] md: reshape of RAID array md127
>> [  405.049914] md: md127: reshape interrupted.
>> [  615.617649] INFO: task md127_reshape:5304 blocked for more than 122 seconds.
>> [  615.617684] task:md127_reshape   state:D stack:0     pid:5304
>> tgid:5304  ppid:2      flags:0x00004000
>> [  615.617747]  wait_barrier.part.0+0x188/0x1e0 [raid10]
>> [  615.617781]  wait_barrier+0x70/0xc0 [raid10]
>> [  615.617798]  raid10_sync_request+0x1545/0x183d [raid10]
>> [  615.617831]  md_do_sync.cold+0x609/0xa1f
>> [  615.617862]  md_thread+0xa3/0x1a0
>> [  615.617875]  ? __pfx_md_thread+0x10/0x10
>>
>> The portion of dmesg that starts with INFO: repeats several times
>> every two minutes or so.
>>
>> I really don't know what to do here. I've been struggling for a few
>> months trying to get it back to working with no success.
>>
>> If the reshape isn't ultimately going to be successful, can anyone
>> explain how to at least mount the array safely so I can copy the data
>> off?
>>
>> I can provide further info as needed.
>>
>> Thank you,
>> Bill Morgan
> 
> .
> 

