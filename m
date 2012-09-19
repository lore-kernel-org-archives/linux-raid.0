From: Bryan Bush <bbushvt@gmail.com>
Subject: Re: MD device always starting as /dev/md127
Date: Tue, 18 Sep 2012 20:44:02 -0400
Message-ID: <CAJ72viOVgO=fO+UaM8A0kRTayi_OHakgrzuXEb9DYhFGZsGmRg@mail.gmail.com>
References: <CAJ72viOHn_TxQ_gB7mp9Nu1ac+VBR96tCecOeOYJoXEfNvEw+g@mail.gmail.com>
	<20120919094432.040013d4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120919094432.040013d4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

an
update-initramfs -u
fixed it.
Thanks
-Bryan


On Tue, Sep 18, 2012 at 7:44 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 18 Sep 2012 19:19:53 -0400 Bryan Bush <bbushvt@gmail.com> wrote:
>
>> I've moved the drives from one system to another and when the array
>> starts up its always /dev/md127.
>> /etc/mdadm/mdadm.conf has:
>>
>>
>> # mdadm.conf
>> #
>> # Please refer to mdadm.conf(5) for information about this file.
>> #
>>
>> # by default (built-in), scan all partitions (/proc/partitions) and all
>> # containers for MD superblocks. alternatively, specify devices to scan, using
>> # wildcards if desired.
>> DEVICE partitions containers
>>
>> # auto-create devices with Debian standard permissions
>> CREATE owner=root group=disk mode=0660 auto=yes
>>
>> # automatically tag new arrays as belonging to the local system
>> HOMEHOST <system>
>>
>> # instruct the monitoring daemon where to send mail alerts
>> MAILADDR root
>>
>> # definitions of existing MD arrays
>> ARRAY /dev/md1 level=raid6 metadata=1.2 num-devices=13
>> UUID=fa32e2c5:e7bda20b:32af7c90:c7ee61eb
>>
>>
>> mdadm --detail gives me
>>
>>
>>
>> /dev/md127:
>>         Version : 1.2
>>   Creation Time : Sat Sep 18 17:05:52 2010
>>      Raid Level : raid6
>>      Array Size : 21488647488 (20493.17 GiB 22004.38 GB)
>>   Used Dev Size : 1953513408 (1863.02 GiB 2000.40 GB)
>>    Raid Devices : 13
>>   Total Devices : 13
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Tue Sep 18 17:40:47 2012
>>           State : clean
>>  Active Devices : 13
>> Working Devices : 13
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>            Name : 1
>>            UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
>>          Events : 56603
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8      177        0      active sync   /dev/sdl1
>>       14       8      161        1      active sync   /dev/sdk1
>>        2       8       81        2      active sync   /dev/sdf1
>>        3       8      145        3      active sync   /dev/sdj1
>>        4       8      209        4      active sync   /dev/sdn1
>>        8       8       65        5      active sync   /dev/sde1
>>        6       8       49        6      active sync   /dev/sdd1
>>        7       8       33        7      active sync   /dev/sdc1
>>       13       8      225        8      active sync   /dev/sdo1
>>       15      65       17        9      active sync   /dev/sdr1
>>       11      65        1       10      active sync   /dev/sdq1
>>       10       8      241       11      active sync   /dev/sdp1
>>        9       8      193       12      active sync   /dev/sdm1
>>
>>
>> If I do
>> mdadm --stop /dev/md127
>> then
>> mdadm --assemble --scan
>> It starts the array at /dev/md1
>>
>> Any idea why it always starts as md127?
>>
>
> My guess is that it is being started while the initrd is running, and the
> initrd doesn't have that mdadm.conf.
> So mdadm doesn't know what number to associated with the uuid, and so chooses
> an unused one.
>
> The metadata does say "Name : 1", but that isn't trusted unless there is some
> reason to believe that the array belongs to "this" host.
>
> If you:
>   mdadm -S /dev/md127
>   mdadm -A /dev/md1 --update=name /dev/sd[lkfjnedcorqpm]1
> then it should update the metadata so that it is known to belong to "this"
> host.  Then providing that the hostname is set during the initrd, it should
> get the right name.
> Or maybe arrange for the ARRAY entry to appear in the mdadm.conf in the
> initrd.
>
> NeilBrown
>
