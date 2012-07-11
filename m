From: Dietrich Heise <dh@dhde.de>
Subject: Re: RAID5 faild while in degraded mode, need help
Date: Wed, 11 Jul 2012 20:50:24 +0200
Message-ID: <CACMY3vAqULU5aOApjtA4icSy+3+j=+pb3_mHUAVmniGhHj89sQ@mail.gmail.com>
References: <CACMY3vC=iAbKCssHH8CQ=msqNtmE1zF1muoZTusfRd989HvD_w@mail.gmail.com>
	<20120709101208.49528808@notabene.brown>
	<CACMY3vDNoZN4tt4TRoE=49q9hkrFZ+7NRKgHHQXKe1_=wi8byw@mail.gmail.com>
	<20120710090214.286059f2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120710090214.286059f2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey,

GREAT, it looks very good!
Everything is there :)

Thanks for help!

Dietrich

2012/7/10 NeilBrown <neilb@suse.de>:
> On Mon, 9 Jul 2012 13:02:04 +0200 Dietrich Heise <dh@dhde.de> wrote:
>
>> Hello,
>>
>> thanks for the hint.
>>
>> I do a backup with dd before that, I hope I can get back the data of the raid.
>>
>> The following is in the syslog:
>>
>> Jul  8 19:21:15 p3 kernel: Buffer I/O error on device dm-1, logical
>> block 365625856
>> Jul  8 19:21:15 p3 kernel: Buffer I/O error on device dm-1, logical
>> block 365625856
>> Jul  8 19:21:15 p3 kernel: lost page write due to I/O error on dm-1
>> Jul  8 19:21:15 p3 kernel: lost page write due to I/O error on dm-1
>> Jul  8 19:21:15 p3 kernel: JBD: I/O error detected when updating
>> journal superblock for dm-1.
>> Jul  8 19:21:15 p3 kernel: JBD: I/O error detected when updating
>> journal superblock for dm-1.
>> Jul  8 19:21:15 p3 kernel: RAID conf printout:
>> Jul  8 19:21:15 p3 kernel: RAID conf printout:
>> Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
>> Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
>> Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
>> Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
>> Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
>> Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
>> Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
>> Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
>> Jul  8 19:21:15 p3 kernel: disk 3, o:0, dev:sdd1
>> Jul  8 19:21:15 p3 kernel: disk 3, o:0, dev:sdd1
>> Jul  8 19:21:15 p3 kernel: RAID conf printout:
>> Jul  8 19:21:15 p3 kernel: RAID conf printout:
>> Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
>> Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
>> Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
>> Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
>> Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
>> Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
>> Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
>> Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
>> Jul  8 19:21:15 p3 kernel: md: recovery of RAID array md0
>> Jul  8 19:21:15 p3 kernel: md: recovery of RAID array md0
>> Jul  8 19:21:15 p3 kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> Jul  8 19:21:15 p3 kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> Jul  8 19:21:15 p3 kernel: md: using maximum available idle IO
>> bandwidth (but not more than 200000 KB/sec) for recovery.
>> Jul  8 19:21:15 p3 kernel: md: using maximum available idle IO
>> bandwidth (but not more than 200000 KB/sec) for recovery.
>> Jul  8 19:21:15 p3 kernel: md: using 128k window, over a total of 1465126400k.
>> Jul  8 19:21:15 p3 kernel: md: using 128k window, over a total of 1465126400k.
>> Jul  8 19:21:15 p3 kernel: md: resuming recovery of md0 from checkpoint.
>> Jul  8 19:21:15 p3 kernel: md: resuming recovery of md0 from checkpoint.
>>
>> I think the right order is sdf1 sde1 sdc1 sdd1, I am right?
>
> Yes, that looks right.
>
>>
>> So I have to do:
>>
>> mdadm -C /dev/md1 -l5 -n4 -e 1.2 -c 512 /dev/sdf1 /dev/sde1 missing /dev/sdd1
>>
>> The question is: sould I also add --assume-clean
>
> --assume-clean makes no difference to a degraded raid5 so it doesn't really
> matter.
> However I always suggest using --assume-clean when re-creating an array so
> on principle I would say "yes - you should add --assume-clean".
>
> NeilBrown
>
>
>>
>> Thanks!
>> Dietrich
>>
