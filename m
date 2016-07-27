From: Alex Owen <alex@alexxx.co.uk>
Subject: SOLVED [was: Re: Lost RAID6 disks when moving to new PC]
Date: Thu, 28 Jul 2016 00:27:19 +0100
Message-ID: <CAFmAqNs8_ju5dLOSmNs7UyEZtfKCx6tcY8rYii6fiqHLX3UEEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to Andreas I now have a somewhat functioning RAID array and I'm
pulling data from it on to some new disks.

Here's the final process I had to go through:

- Create an overlay for all six disks. Following the tutorial at
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
only created the overlay for the disks it recognised as being part of
the array. To add the others I manually changed the $DEVICES variable
to include all size disks.

- Then I ran:
    mdadm --create /dev/md42 --assume-clean --level=6 --raid-devices=6
--chunk=512 --layout=ls /dev/mapper/sd{e,f,a,b,c,d}

    Note the changes from Andreas' suggestion: added the raid-devices
option and removed the data-offset option (not supported on the
version of mdadm I was using on Ubuntu 14.04).

- I was using LVM on top of the array, so to mount it I ran
lvmdiskscan and lvdisplay to find out where the partitions were stored
by lvm

- Then I mounted the LVM partitions and it worked!

Andreas, I really appreciate your help, thank you.


On 27 July 2016 at 12:57, Andreas Klauer <Andreas.Klauer@metamorpher.de> wrote:
> On Wed, Jul 27, 2016 at 11:35:34AM +0100, Alex Owen wrote:
>> The array should be RAID6 on /dev/sd{a-f}.
>
> Full disk raid sucks. Zero advantages, lots of additional risk.
> There are too many programs out there that expect every disk to have
> a partition table, and will use it unasked if it looks unpartitioned.
>
> You seem to have lost your md metadata to some partitioner/installer,
> you're also the third person with this problem in a row. Congrats. ;)
>
>> fdisk -l :
>
> Your fdisk doesn't support GPT, don't use it.
>
>> parted
>> Disk /dev/sd[bcd]: 3001GB
>> Sector size (logical/physical): 512B/4096B
>> Partition Table: gpt
>>
>> Number  Start   End     Size    File system  Name                          Flags
>>  1      17.4kB  134MB   134MB                Microsoft reserved
>> partition  msftres
>>  2      135MB   3001GB  3000GB               Basic data partition
>>     msftdata
>
> Well, something put GPT partition table on those. GPT overwrites start
> and end of the disk. You're using 1.2 metadata which is located 4K from
> the start, can you show some hexdump for those disks?
>
> hexdump -C -s 4096 -n 4096 /dev/sdb
>
>> And the output of mdadm --examine /dev/sd[a-f]
>>
>> ----------
>>
>> /dev/sda:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : b377d975:86beb86c:9da9f21d:f73b2451
>>            Name : NAS:0  (local to host NAS)
>>   Creation Time : Sat Jan 23 17:57:37 2016
>>      Raid Level : raid6
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
>>      Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
>>   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : 013740d6:5cc445e7:625f3257:8608daec
>>
>>     Update Time : Tue Jul 26 04:09:29 2016
>>        Checksum : 14ba6ebd - correct
>>          Events : 2949004
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 2
>>    Array State : AAAAAA ('A' == active, '.' == missing)
>
>> /dev/sdb:
>>    MBR Magic : aa55
>> Partition[0] :   4294967295 sectors at            1 (type ee)
>> /dev/sdc:
>>    MBR Magic : aa55
>> Partition[0] :   4294967295 sectors at            1 (type ee)
>> /dev/sdd:
>>    MBR Magic : aa55
>> Partition[0] :   4294967295 sectors at            1 (type ee)
>
> Basically what we know is... your disk order for three disks
>
> (/dev/sde = role 0, /dev/sdf = role 1, /dev/sda= role 2)
>
> and what we don't know is the disk order of /dev/sd[bcd].
>
> If the metadata is lost completely, only thing you can do is re-create
> the RAID with all possible orders efa{bcd,bdc,cbd,cdb,dbc,dcb}.
>
> Re-creating is dangerous so you should use an overlay: https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
>
> When re-creating you have to specify all variables (level, layout, chunksize,
> data offset, order, ...) since the defaults picked by mdadm might differ
> depending on your mdadm version.
>
> Example command: (untested)
>
> mdadm --create /dev/md42 --assume-clean \
>       --level=6 --chunk=512 --data-offset=128M --layout=ls \
>       /dev/overlay/sd{e,f,a,b,c,d}
>
> Then you check if it can be mounted, and once mounted if big files
> (larger than chunksize * number of disks) are intact or no. If you
> switch the wrong two disks it may mount but data is garbage anyway.
>
> Regards
> Andreas Klauer
