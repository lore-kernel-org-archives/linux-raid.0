From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Sat, 23 Feb 2013 18:49:45 -0500
Message-ID: <51295599.5040907@turmel.org>
References: <5123A1CC.2000003@heisl.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org> <5127F45F.5020608@heisl.org>
  <512827FC.7010403@turmel.org> <5128336E.5060809@heisl.org> <51284762.2080202@turmel.org> <51289798.7050500@heisl.org> <5128E9F4.5040700@turmel.org> <5129421C.7070105@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5129421C.7070105@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/23/2013 05:26 PM, Stone wrote:

> i have a secound storage system with enough space to copy all there.
> this is my plan. to mount the device and copy as fast as i can all my
> data to my secound system and after this i take the cheap drives and
> drive with my car over it ;-)

Good plan for the first part.  But I wouldn't get rid of the cheap
drives.  They may lack features needed for best use in a raid array, but
they are fine for solo duties.  I have some similarly annoying Seagate
drives.  I use them one-by-one for off-site rotating backups.

> for x in /dev/sd[bce] ; do parted $x unit s print ; done
> Model: ATA WDC WD20EARS-00M (scsi)
> Disk /dev/sdb: 3907029168s
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start  End          Size         File system  Name  Flags
>  1      34s    3907029118s  3907029085s                     raid
> 
> Model: ATA WDC WD20EARS-00M (scsi)
> Disk /dev/sdc: 3907029168s
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start  End          Size         File system  Name  Flags
>  1      2048s  3907028991s  3907026944s
> 
> Model: ATA WDC WD20EARS-00M (scsi)
> Disk /dev/sde: 3907029168s
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start  End          Size         File system  Name  Flags
>  1      34s    3907029118s  3907029085s                     raid
>>
>> The partition structure on /dev/sdc is causing the array to be too short
>> for the filesystem.  There are two possibilities:
>>
>> 1) The partition doesn't go far enough to the end of the disk,

For this, repartition /dev/sdc to start at sector 2048 and end at
3907029118.  Then re-create the array, open luks, and do "fsck -n" and
show the results.

>>
>> 2) The partition starts too far into the disk (move start sector to 34
>> like sdb and sde).

For this, repartition /dev/sdc to start at 34 and end at 3907029118.
This makes it match sdb and sde.  Then re-create the array, open luks,
and do "fsck -n" and show the results.

>> ps.  I hope this odyssey has emphasized to all lurkers how terrible it
>> can be to use "mdadm --create" without careful, thorough preparation.

> @ ps: sorry that i do this and thx for your help!

You're welcome.

Phil

