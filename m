From: Alex <mysqlstudent@gmail.com>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Wed, 18 Jul 2012 22:44:06 -0400
Message-ID: <CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com>
	<50071C0A.8080307@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50071C0A.8080307@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi,

>> What is the proper procedure to remove the disk from the array,
>> shutdown the server, and reboot with a new sda?
...
>> I'd appreciate a pointer to any existing documentation, or some
>> general guidance on the proper procedure.
>>
>
> Once the drive is failed about all you can do is add another drive as a
> spare, wait until the rebuild completes, then remove the old drive from the
> array. If you have a new kernel, 3.3 or newer you might have been able to
> use the undocumented but amazing "want_replacement" action to speed your
> rebuild, but when it is so bad it gets kicked I think it's too late.
>
> Neil might have a thought on this, the option makes the rebuild vastly
> faster and safer.

I've just successfully replaced the failed disk. I marked it as
failed, removed it from the array, powered the server off, switched
the disk with a replacement, rebooted and added the new disk, and it's
now starting the rebuild process.

However, it's extremely slow. This isn't a super-fast machine, but it
should at least be able to do 40M/sec as I've seen it do before. Why
would it be going at only 11M?

[root@pixie ~]# echo 100000 > /proc/sys/dev/raid/speed_limit_max
[root@pixie ~]# echo 100000 > /proc/sys/dev/raid/speed_limit_min
[root@pixie ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active raid5 sda3[5] sdb2[1] sdd2[4] sdc2[2]
      2890747392 blocks super 1.1 level 5, 512k chunk, algorithm 2 [4/3] [_UUU]
      [>....................]  recovery =  4.0% (38872364/963582464)
finish=1347.4min speed=11437K/sec
      bitmap: 8/8 pages [32KB], 65536KB chunk

md0 : active raid5 sda2[5] sdb1[1] sdd1[4] sdc1[2]
      30715392 blocks super 1.1 level 5, 512k chunk, algorithm 2 [4/3] [_UUU]
        resync=DELAYED
      bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>

I'm not sure what stats I could provide to troubleshoot this further.
At this rate, the 2.7T array will take a full day to resync. Is that
to be expected?

Thanks,
Alex
