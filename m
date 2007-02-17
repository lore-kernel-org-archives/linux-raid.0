From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm --grow failed
Date: Sat, 17 Feb 2007 14:16:13 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702171415500.29573@p34.internal.lan>
References: <20070217030514.M74974@liquid-nexus.net> <45D7490E.6080309@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45D7490E.6080309@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Marc Marais <marcm@liquid-nexus.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 17 Feb 2007, Bill Davidsen wrote:

> Marc Marais wrote:
>> I'm trying to grow my raid 5 array as I've just added a new disk. The array 
>> was originally 3 drives, I've added a fourth using:
>> 
>> mdadm -a /dev/md6 /dev/sda1
>> 
>> Which added the new drive as a spare. I then did:
>> 
>> mdadm --grow /dev/md6 -n 4
>> 
>> Which started the reshape operation. 
>> Feb 16 23:51:40 xerces kernel: RAID5 conf printout:
>> Feb 16 23:51:40 xerces kernel:  --- rd:4 wd:4
>> Feb 16 23:51:40 xerces kernel:  disk 0, o:1, dev:sdb1
>> Feb 16 23:51:40 xerces kernel:  disk 1, o:1, dev:sdc1
>> Feb 16 23:51:40 xerces kernel:  disk 2, o:1, dev:sdd1
>> Feb 16 23:51:40 xerces kernel:  disk 3, o:1, dev:sda1
>> Feb 16 23:51:40 xerces kernel: md: reshape of RAID array md6
>> Feb 16 23:51:40 xerces kernel: md: minimum _guaranteed_  speed: 1000 
>> KB/sec/disk.
>> Feb 16 23:51:40 xerces kernel: md: using maximum available idle IO 
>> bandwidth (but not more than 200000 KB/sec) for reshape.
>> Feb 16 23:51:40 xerces kernel: md: using 128k window, over a total of 
>> 156288256 blocks.
>> 
>> Unfortunately one of the drives timed out during the operation (not a read 
>> error - just a timeout - which I would've thought would be retried but 
>> anyway...):
>> 
>> Feb 17 00:19:16 xerces kernel: ata3: command timeout
>> Feb 17 00:19:16 xerces kernel: ata3: no sense translation for status: 0x40
>> Feb 17 00:19:16 xerces kernel: ata3: translated ATA stat/err 0x40/00 to 
>> SCSI SK/ASC/ASCQ 0xb/00/00
>> Feb 17 00:19:16 xerces kernel: ata3: status=0x40 { DriveReady }
>> Feb 17 00:19:16 xerces kernel: sd 3:0:0:0: SCSI error: return code = 
>> 0x08000002
>> Feb 17 00:19:16 xerces kernel: sdc: Current [descriptor]: sense key: 
>> Aborted Command
>> Feb 17 00:19:16 xerces kernel:     Additional sense: No additional sense 
>> information
>> Feb 17 00:19:16 xerces kernel: Descriptor sense data with sense descriptors 
>> (in hex):
>> Feb 17 00:19:16 xerces kernel:         72 0b 00 00 00 00 00 0c 00 0a 80 00 
>> 00 00 00 00 Feb 17 00:19:16 xerces kernel:         00 00 00 01 Feb 17 
>> 00:19:16 xerces kernel: end_request: I/O error, dev sdc, sector 24065423
>> Feb 17 00:19:16 xerces kernel: raid5: Disk failure on sdc1, disabling 
>> device. Operation continuing on 3 devices
>> 
>> Which then unfortunately aborted the reshape operation:
>> 
>> Feb 17 00:19:16 xerces kernel: md: md6: reshape done.
>> Feb 17 00:19:17 xerces kernel: RAID5 conf printout:
>> Feb 17 00:19:17 xerces kernel:  --- rd:4 wd:3
>> Feb 17 00:19:17 xerces kernel:  disk 0, o:1, dev:sdb1
>> Feb 17 00:19:17 xerces kernel:  disk 1, o:0, dev:sdc1
>> Feb 17 00:19:17 xerces kernel:  disk 2, o:1, dev:sdd1
>> Feb 17 00:19:17 xerces kernel:  disk 3, o:1, dev:sda1
>> Feb 17 00:19:17 xerces kernel: RAID5 conf printout:
>> Feb 17 00:19:17 xerces kernel:  --- rd:4 wd:3
>> Feb 17 00:19:17 xerces kernel:  disk 0, o:1, dev:sdb1
>> Feb 17 00:19:17 xerces kernel:  disk 2, o:1, dev:sdd1
>> Feb 17 00:19:17 xerces kernel:  disk 3, o:1, dev:sda1
>> 
>> I re-added the failed disk (sdc) (which btw is a brand new disk - seems 
>> this is a controller issue - high IO load?) which then resynced the array.
>> 
>> At this point I'm confused as to the state of the array.
>> 
>> mdadm -D /dev/md6 gives:
>> 
>> /dev/md6:
>>         Version : 00.91.03
>>   Creation Time : Tue Aug  1 23:31:54 2006
>>      Raid Level : raid5
>>      Array Size : 312576512 (298.10 GiB 320.08 GB)
>>   Used Dev Size : 156288256 (149.05 GiB 160.04 GB)
>>    Raid Devices : 4
>>   Total Devices : 4
>> Preferred Minor : 6
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Sat Feb 17 12:14:22 2007
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 128K
>>
>>   Delta Devices : 1, (3->4)
>>
>>            UUID : 603e7ac0:de4df2d1:d44c6b9b:3d20ad32
>>          Events : 0.7215890
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       17        0      active sync   /dev/sdb1
>>        1       8       33        1      active sync   /dev/sdc1
>>        2       8       49        2      active sync   /dev/sdd1
>>        3       8        1        3      active sync   /dev/sda1
>> 
>> Although it previously (before issuing the command below) mentioned 
>> something about reshape 1% or something to that effect.
>> 
>> I've attempted to continue the reshape by issuing:
>> 
>> mdadm --grow /dev/md6 -n 4 
>> Which gives the error that the array can't be reshaped without increasing 
>> its size!
>> 
>> Is my array destroyed? Seeing as the sda disk wasn't completely synced I'm 
>> wonder how it was using to resync the array when sdc went offline. I've got 
>> a bad feeling about this :|
>> 
>> Help appreciated. (I do have a full backup of course but that's a last 
>> resort with my luck I'd get a read error from the tape drive)
> I have to think maybe a 'check' would have been good before the grow, but 
> since Neil didn't suggest it, please don't now, unless he agrees that it's a 
> valid attempt.
>
> However, you certainly can run 'df' and see if the filesystem is resized.
>
> -- 
> bill davidsen <davidsen@tmr.com>
> CTO TMR Associates, Inc
> Doing interesting things with small computers since 1979
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Is growing an array with > 1 disk at a time permissible?  I've grown a 
raid 5 from 1.8tb to 3.3tb but always 1 disk at a time.

Justin.
