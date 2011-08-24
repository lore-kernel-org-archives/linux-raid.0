From: NeilBrown <neilb@suse.de>
Subject: Re: IMSM Raid 5 always read only and gone after reboot
Date: Thu, 25 Aug 2011 09:54:30 +1000
Message-ID: <20110825095430.3b88d71d@notabene.brown>
References: <CAOTVL7JLxjHgyaz0s3Ua9gsgUYHP_2b1DONzk3YNaCLfgxMBpA@mail.gmail.com>
	<4E4B4075.2060400@gmail.com>
	<4E553039.8010003@zarembo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E553039.8010003@zarembo.de>
Sender: linux-raid-owner@vger.kernel.org
To: Iwan Zarembo <iwan@zarembo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Aug 2011 19:09:13 +0200 Iwan Zarembo <iwan@zarembo.de> wrote:

> Hi Everyone,
> Nothing worked with the last mail, so I tried it again. A different 
> approach.
> What I tried again:
> 
> 1. I stopped and deleted the array using:
> mdadm --stop /dev/md126
> mdadm --stop /dev/md127
> mdadm --remove /dev/md127
> mdadm --zero-superblock /dev/sdb
> mdadm --zero-superblock /dev/sdc
> mdadm --zero-superblock /dev/sdd
> mdadm --zero-superblock /dev/sde
> 
> 2. I deleted all data (including partition table) on every HDD:
> dd if=/dev/zero of=/dev/sd[b-e] bs=512 count=1
> 
> 3. Checked if mdadm --assemble --scan can find any arrays, but I did not 
> find anything.
> 
> 4. I created the array again using 
> https://raid.wiki.kernel.org/index.php/RAID_setup#External_Metadata
> mdadm --create --verbose /dev/md/imsm /dev/sd[b-e] --raid-devices 4 
> --metadata=imsm
> mdadm --create --verbose /dev/md/raid /dev/md/imsm --raid-devices 4 
> --level 5
> 
> The new Array did not have any partitions, since I deleted everything. 
> So everything looks good.
> The details are:
> # mdadm -D /dev/md127
> /dev/md127:
>          Version : imsm
>       Raid Level : container
>    Total Devices : 4
> 
> Working Devices : 4
> 
> 
>             UUID : 790217ac:df4a8367:7892aaab:b822d6eb
>    Member Arrays :
> 
>      Number   Major   Minor   RaidDevice
> 
>         0       8       16        -        /dev/sdb
>         1       8       32        -        /dev/sdc
>         2       8       48        -        /dev/sdd
>         3       8       64        -        /dev/sde
> 
> # mdadm -D /dev/md126
> /dev/md126:
>        Container : /dev/md/imsm, member 0
>       Raid Level : raid5
>       Array Size : 2930280448 (2794.53 GiB 3000.61 GB)
>    Used Dev Size : 976760320 (931.51 GiB 1000.20 GB)
>     Raid Devices : 4
>    Total Devices : 4
> 
>            State : clean
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
> 
>           Layout : left-asymmetric
>       Chunk Size : 128K
> 
> 
>             UUID : 4ebb43fd:6327cb4e:2506b1d3:572e774e
>      Number   Major   Minor   RaidDevice State
>         0       8       48        0      active sync   /dev/sdd
>         1       8       32        1      active sync   /dev/sdc
>         2       8       16        2      active sync   /dev/sdb
>         3       8       64        3      active sync   /dev/sde
> 
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md126 : active (read-only) raid5 sde[3] sdb[2] sdc[1] sdd[0]
>        2930280448 blocks super external:/md127/0 level 5, 128k chunk, 
> algorithm 0 [4/4] [UUUU]
>            resync=PENDING
> 
> md127 : inactive sde[3](S) sdd[2](S) sdc[1](S) sdb[0](S)
>        836 blocks super external:imsm
> 
> unused devices: <none>
> 
> Then I stored the configuration of the array using the command
> mdadm --examine --scan >> /etc/mdadm.conf
> 
> 5. I used dpkg-reconfigure mdadm to make sure mdadm starts properly at 
> boot time.
> 
> 6. I rebooted and checked if the array was created in BIOS of the Intel 
> raid.
> Yes it is existing, and it looks good there.
> 
> 7. I still cannot see the created array. But in palimpsest I see that my 
> four hard drives are a part of a raid.
> 
> I also checked the logs for any strange entries, but no success :S
> 
> 9. I used mdadm --assemble --scan to see the array in palimpsest
> 
> 10. Started sync process using command from 
> http://linuxmonk.ch/trac/wiki/LinuxMonk/Sysadmin/SoftwareRAID#CheckRAIDstate
> 
> #echo active > /sys/block/md126/md/array_state
> 
> #cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md126 : active raid5 sdd[3] sdc[2] sdb[1] sde[0]
>        2930280448 blocks super external:/md127/0 level 5, 128k chunk, 
> algorithm 0 [4/4] [UUUU]
>        [>....................]  resync =  0.9% (9029760/976760320) 
> finish=151.7min speed=106260K/sec
> 
> The problem is that the raid was gone after a restart. So I did step 9 
> and 10 again.
> 
> 11. Then I started to create a gtp partition table with parted.
> Unfortunately mktable gpt on device /dev/md/raid (or the target of the 
> link /dev/md126) never came back. Even after a few hours.
> 
> I really do not know what else I need to do to get the raid working. Can 
> someone help me? I do not think I am the first person having trouble 
> with it :S

It sounds like mdmon is not being started.
mdmon monitors the array and performs any metadata updates required.

The reason mktable is taking more than a second is that it tries to write to
the array, the kernel marks the array as 'write-pending' and waits for mdmon
to notice, update the metadata, and switch the array to 'active'.  But mdmon
never does that.

mdmon should be started by mdadm but just to check you can start it by hand:

 /sbin/mdmon md126
or
 /sbin/mdmon --all

If this makes it work, you need to work out why mdmon isn't being started.

NeilBrown

