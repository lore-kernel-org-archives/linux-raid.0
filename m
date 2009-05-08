From: Tobias Gunkel <tobias.gunkel@qumido.de>
Subject: Re: Problem with auto-assembling raid1 on system start
Date: Fri, 08 May 2009 22:09:14 +0200
Message-ID: <4A04916A.1020001@qumido.de>
References: <4A043D78.8020104@qumido.de> <f19d625d0905081136p6af2249bk16efeaf9a71faadb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f19d625d0905081136p6af2249bk16efeaf9a71faadb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: CoolCold <coolthecold@gmail.com>
List-Id: linux-raid.ids

Great! That was exactly the problem. The uuid differed from the one out of
    mdadm --detail --scan
After rebuilding the initrd image, including the fixed mdadm.conf, 
everything is working fine again.

Thank you very much!
Best regards, Tobias

CoolCold schrieb:
> Does mdadm.conf in initrd image contains valid uuids/array names? (you
> can ungzip && extract cpio archive to check this)
>
> On Fri, May 8, 2009 at 6:11 PM, Tobias Gunkel <tobias.gunkel@qumido.de> wrote:
>   
>> Hello everyone!
>>
>> After rebooting one of our Debian servers yesterday (under normal
>> conditions), mdadm was not able to assemble /dev/md0 automaticly any more.
>> System: Debian Lenny, mdmadm v2.5.6, Kernel 2.6.26-preemptive-cpuset (from
>> Debian testing sources)
>>
>> This is what I get during boot:
>>
>>  [...]
>>  Begin: Mounting root file system... ...
>>  Begin: Running /scripts/local-top ...
>>  Begin: Loading MD modules ...
>>  md: raid1 personality registered for level 1
>>  Success: loaded module raid1.
>>  Done.
>>  Begin: Assembling all MD arrays ...
>>  [...]
>>  md: md0 stopped.
>>  mdadm: no devices found for /dev/md0
>>  Failure: failed to assemble all arrays.
>>  [...]
>>
>> Then the system falls back to BusyBox shell from initramfs, because the root
>> fs  - which is located on /dev/md0 - could not be mounted.
>> But from the initramfs shell, it is possible to cleanly assemble and mount
>> the md0 array:
>>
>>  (initramfs) mdadm -A /dev/md0 /dev/sda2 /dev/sdb2
>>  md: md0 stopped.
>>  md: bind<sdb2>
>>  md: bind<sda2>
>>  raid1: raid set md0 active with 2 out of 2 mirrors
>>  mdadm: /dev/md0 has been started with 2 drives.
>>
>>  (initramfs) mount /dev/md0 root
>>  kjournald starting. Commit interval 5 seconds
>>  EXT3 FS on md0, internal journal
>>  EXT3-fs: mounted filesystem with ordered data mode.
>>
>> After leaving the initramfs shell with 'exit', the system continues to boot
>> normally.
>>
>> Strange: /dev/md1 (swap) which is the first array in assembling order, gets
>> assembled and started correctly.
>> I also played around with ROOTDELAY=60, but this did not changed anything.
>>
>> I'm grateful for any help.
>> Best regards, Tobias
>>
>>
>> PS: Maybe some helpful output (after starting the system the way described
>> above):
>>
>> $ cat /proc/mdstat
>> Personalities : [raid1]
>> md0 : active raid1 sda2[0] sdb2[1]
>>     487331648 blocks [2/2] [UU]
>>
>> md1 : active raid1 sda1[0] sdb1[1]
>>     1052160 blocks [2/2] [UU]
>>
>> unused devices: <none>
>>
>>
>> $ mdadm --detail --scan
>> ARRAY /dev/md1 level=raid1 num-devices=2
>> UUID=c3838888:50dbed72:15a9bffb:d0e83d23
>> ARRAY /dev/md0 level=raid1 num-devices=2
>> UUID=0d0a0c79:70adae03:f802952b:2b58c14d
>>
>>
>> $ grep -v ^# /etc/mdadm/mdadm.conf
>>
>> DEVICE /dev/sd*[0-9] /dev/sd*[0-9]
>>
>> CREATE owner=root group=disk mode=0660 auto=yes
>>
>> HOMEHOST <system>
>>
>> MAILADDR root
>>
>> ARRAY /dev/md1 level=raid1 num-devices=2
>> UUID=c3838888:50dbed72:15a9bffb:d0e83d23
>> ARRAY /dev/md0 level=raid1 num-devices=2
>> UUID=0d0a0c79:70adae03:f802952b:2b58c14d
>>
>>
>> $ mdadm --detail /dev/md0
>> /dev/md0:
>>       Version : 00.90.03
>>  Creation Time : Thu Dec 11 14:18:44 2008
>>    Raid Level : raid1
>>    Array Size : 487331648 (464.76 GiB 499.03 GB)
>>   Device Size : 487331648 (464.76 GiB 499.03 GB)
>>  Raid Devices : 2
>>  Total Devices : 2
>> Preferred Minor : 0
>>   Persistence : Superblock is persistent
>>
>>   Update Time : Fri May  8 15:45:32 2009
>>         State : clean
>> Active Devices : 2
>> Working Devices : 2
>> Failed Devices : 0
>>  Spare Devices : 0
>>
>>          UUID : 0d0a0c79:70adae03:f802952b:2b58c14d
>>        Events : 0.900
>>
>>   Number   Major   Minor   RaidDevice State
>>      0       8        2        0      active sync   /dev/sda2
>>      1       8       18        1      active sync   /dev/sdb2
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
>
>
>   

