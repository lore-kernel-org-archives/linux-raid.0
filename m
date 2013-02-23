From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Sat, 23 Feb 2013 04:11:42 +0100
Message-ID: <5128336E.5060809@heisl.org>
References: <5123A1CC.2000003@heisl.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org
 > <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org> <5127F45F.5020608@heisl.org> <512827FC.7010403@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512827FC.7010403@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 23.02.2013 03:22, schrieb Phil Turmel:
> On 02/22/2013 05:42 PM, Stone wrote:
>> Am 22.02.2013 23:35, schrieb Phil Turmel:
>>> Please recreate the array with this combination, then show:
>>>
>>> mdadm -D /dev/md2
>>> mdadm -E /dev/sd[bce]1
>>> cat /proc/partitions
>>> for x in /dev/sd[bce] ; do fdisk -l $x ; done
>> i dont know what chunk do you what but i think you mean 512k
> Yes.
>
>> mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5
>> --raid-devices=4 /dev/sdb1 /dev/sdc1 missing /dev/sde1
>> mdadm -E /dev/sd[bce]1
>> /dev/sdb1:
>>   Avail Dev Size : 3907027037 (1863.02 GiB 2000.40 GB)
>>       Array Size : 11721071616 (5589.04 GiB 6001.19 GB)
>>    Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>> /dev/sdc1:
>>   Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>>       Array Size : 11721071616 (5589.04 GiB 6001.19 GB)
>>    Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
> See the difference?
yes ;-(
>> /dev/sde1:
>>   Avail Dev Size : 3907027037 (1863.02 GiB 2000.40 GB)
>>       Array Size : 11721071616 (5589.04 GiB 6001.19 GB)
>>    Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>> /proc/partitions
>> major minor  #blocks  name
>>
>>     8        0  244198584 sda
>>     8        1     248832 sda1
>>     8        2          1 sda2
>>     8        5  243947520 sda5
>>   252        0  235589632 dm-0
>>   252        1    8351744 dm-1
>>     8       16 1953514584 sdb
>>     8       17 1953514542 sdb1
>>     8       32 1953514584 sdc
>>     8       33 1953513472 sdc1
> And here?
>
>>     8       48 1953514584 sdd
>>     8       49 1953514542 sdd1
>>     8       64 1953514584 sde
>>     8       65 1953514542 sde1
>>     9        2 5860535808 md2
>> for x in /dev/sd[bce] ; do fdisk -l $x ; done
>>
>> WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util
>> fdisk doesn't support GPT. Use GNU Parted.
> Oops.  But you get the point, I hope.  /dev/sdc has a different
> partition table from /dev/sdb and /dev/sde.  That short partition is
> causing mdadm to make the array too small for the filesystem in it.
>
> You need to fix the partitions on /dev/sdc to exactly match /dev/sdb and
> /dev/sde.  Can you explain how it might have become different?
>
> And use "parted /dev/sdb print" to show the partitions instead of fdisk.
>
> Phil
>
no i have no idea why die partion table is wrong on /dev/sdc.
i can copy with dd the partion table from sdb to sdc...
example:
dd if=/dev/sdb of=sdb.part bs=512 count=1
dd if=sdb.part of=/dev/sdc bs=512 count=1

infos:
root@ubuntu:~/raid# parted /dev/sdb print
Model: ATA WDC WD20EARS-00M (scsi)
Disk /dev/sdb: 2000GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  1      17,4kB  2000GB  2000GB                     raid

root@ubuntu:~/raid# parted /dev/sdc print
Model: ATA WDC WD20EARS-00M (scsi)
Disk /dev/sdc: 2000GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  1      1049kB  2000GB  2000GB
