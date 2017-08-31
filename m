From: Joel Walberg <joel.walberg@gmail.com>
Subject: Re: debian9/raid1 assembly/unexpected failure opening device
Date: Thu, 31 Aug 2017 07:27:39 -0600
Message-ID: <CAGv-CELfNVch=o6oKzDz0YG6ji6wFrXkJKPOgj439XhNDSNw2A@mail.gmail.com>
References: <CAGv-CE+UwWraQpVF8hG+OBxj1B7Gwbh7tUcMq7hKz0MQ0NWd-w@mail.gmail.com>
 <20170831132226.GA6058@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170831132226.GA6058@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks, that looks like it did the trick.  Yes, I was already aware
that sdc needs to be replaced at some point, just not during my OS
upgrade.

root@jowahome:~# mdadm --assemble --update=name --name=md0 /dev/md0
/dev/sdb1 /dev/sdc1
mdadm: /dev/md0 has been started with 2 drives.

root@jowahome:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active (auto-read-only) raid1 sdc1[0] sdb1[2]
      2930133824 blocks super 1.2 [2/2] [UU]

unused devices: <none>

On Thu, Aug 31, 2017 at 7:22 AM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Thu, Aug 31, 2017 at 06:06:42AM -0600, Joel Walberg wrote:
>> ## root@jowahome:~# mdadm -A /dev/md2014 /dev/sdc1 /dev/sdb1
>> ## mdadm: unexpected failure opening /dev/md2014
>> ## root@jowahome:~# mdadm -A /dev/md/md2014 /dev/sdc1 /dev/sdb1
>> ## mdadm: unexpected failure opening /dev/md2014
>
> Could be related to the name. Try assembling it as /dev/md0.
>
> If that works, change the name to something that isn't md<number>.
>
> (--assemble --update=name --name=xyz I guess)
>
>> ## SMART Extended Self-test Log Version: 1 (1 sectors)
>> ## Num  Test_Description    Status                  Remaining
>> LifeTime(hours)  LBA_of_first_error
>> ## # 1  Short offline       Completed without error       00%
>> 21086         -
>
> This is a personal preference... but you should run self tests
> more regularly (automated, smartd) to detect HDD errors in time.
>
>> ##   5 Reallocated_Sector_Ct   PO--CK   097   097   010    -    3344
>
> That's quite a lot of reallocated sectors already.
> This is the kind of drive that will make your rebuilds fail.
>
> I would consider replacing such a drive / putting it to some use
> where data loss is acceptable.
>
> Regards
> Andreas Klauer



-- 

___________________________
Joel A. Walberg
joel.walberg@gmail.com
