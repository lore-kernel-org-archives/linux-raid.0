From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Fri, 22 Feb 2013 23:36:50 -0500
Message-ID: <51284762.2080202@turmel.org>
References: <5123A1CC.2000003@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.or
 g> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org> <5127F45F.5020608@heisl.org> <512827FC.7010403@turmel.org> <5128336E.5060809@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5128336E.5060809@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/22/2013 10:11 PM, Stone wrote:

> no i have no idea why die partion table is wrong on /dev/sdc.
> i can copy with dd the partion table from sdb to sdc...
> example:
> dd if=/dev/sdb of=sdb.part bs=512 count=1
> dd if=sdb.part of=/dev/sdc bs=512 count=1

That won't work for gpt.
http://en.wikipedia.org/wiki/GUID_Partition_Table

> infos:
> root@ubuntu:~/raid# parted /dev/sdb print
> Model: ATA WDC WD20EARS-00M (scsi)
> Disk /dev/sdb: 2000GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start   End     Size    File system  Name  Flags
>  1      17,4kB  2000GB  2000GB                     raid

Uh oh.  Sector 34.  That start point is very bad for performance.

> root@ubuntu:~/raid# parted /dev/sdc print
> Model: ATA WDC WD20EARS-00M (scsi)
> Disk /dev/sdc: 2000GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start   End     Size    File system  Name  Flags
>  1      1049kB  2000GB  2000GB

This one is aligned for proper performance, but it appears to be the
wrong alignment for getting your data back.  Yuck.

Once you fix this partition table to get your data, take a backup of the
array.  Then make a new array with partitions starting at sector 2048.
Or no partitions at all.

Phil
