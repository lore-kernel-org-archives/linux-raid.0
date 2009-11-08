From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID down, dont know why!
Date: Sun, 08 Nov 2009 09:21:20 -0500
Message-ID: <4AF6D3E0.40707@gmail.com>
References: <4AF6CEFD.60309@gmail.com> <4AF6D099.5040407@scalableinformatics.com> <4AF6D0F8.80704@gmail.com> <4AF6D265.7090104@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF6D265.7090104@scalableinformatics.com>
Sender: linux-raid-owner@vger.kernel.org
To: landman@scalableinformatics.com
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

storrgie@ALEXANDRIA:~$ sudo mdadm -D /dev/md0
/dev/md0:
        Version : 00.90
  Creation Time : Fri Nov  6 07:06:34 2009
     Raid Level : raid6
     Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Nov  8 09:17:55 2009
          State : clean, degraded, recovering
 Active Devices : 8
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 1

     Chunk Size : 1024K

 Rebuild Status : 0% complete

           UUID : 397e0b3f:34cbe4cc:613e2239:070da8c8 (local to host
ALEXANDRIA)
         Events : 0.56

    Number   Major   Minor   RaidDevice State
       0       8       65        0      active sync   /dev/sde1
       1       8       81        1      active sync   /dev/sdf1
       2       8       97        2      active sync   /dev/sdg1
       3       8      113        3      active sync   /dev/sdh1
       4       8      129        4      active sync   /dev/sdi1
       5       8      145        5      active sync   /dev/sdj1
       9       8      161        6      spare rebuilding   /dev/sdk1
       7       8      177        7      active sync   /dev/sdl1
       8       8      193        8      active sync   /dev/sdm1

Did a:
sudo mdadm --assemble --force /dev/md0 /dev/sd[efghijklm]1

Now its rebuilding? Why did it go down in the first place?

Power and connections are fine and smart reports:

storrgie@ALEXANDRIA:~$ sudo smartctl -a /dev/sde | grep "SMART
overall-health"
SMART overall-health self-assessment test result: PASSED
storrgie@ALEXANDRIA:~$ sudo smartctl -a /dev/sdf | grep "SMART
overall-health"
SMART overall-health self-assessment test result: PASSED
storrgie@ALEXANDRIA:~$ sudo smartctl -a /dev/sdg | grep "SMART
overall-health"
SMART overall-health self-assessment test result: PASSED
storrgie@ALEXANDRIA:~$ sudo smartctl -a /dev/sdh | grep "SMART
overall-health"
SMART overall-health self-assessment test result: PASSED
storrgie@ALEXANDRIA:~$ sudo smartctl -a /dev/sdi | grep "SMART
overall-health"
SMART overall-health self-assessment test result: PASSED
storrgie@ALEXANDRIA:~$ sudo smartctl -a /dev/sdj | grep "SMART
overall-health"
SMART overall-health self-assessment test result: PASSED
storrgie@ALEXANDRIA:~$ sudo smartctl -a /dev/sdk | grep "SMART
overall-health"
SMART overall-health self-assessment test result: PASSED
storrgie@ALEXANDRIA:~$ sudo smartctl -a /dev/sdl | grep "SMART
overall-health"
SMART overall-health self-assessment test result: PASSED
storrgie@ALEXANDRIA:~$ sudo smartctl -a /dev/sdm | grep "SMART
overall-health"
SMART overall-health self-assessment test result: PASSED


Joe Landman wrote:
> Andrew Dunn wrote:
>> storrgie@ALEXANDRIA:~$ lsscsi  | grep sd[ijkl]
>> [11:0:0:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdi
>> [11:0:1:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdj
>> [11:0:2:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdk
>> [11:0:3:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdl
>>
>
> Does smartctl report drive failure?
>
>     smartctl -a /dev/sdi | grep "SMART overall-health"
>     smartctl -a /dev/sdj | grep "SMART overall-health"
>     smartctl -a /dev/sdk | grep "SMART overall-health"
>     smartctl -a /dev/sdl | grep "SMART overall-health"
>
>>
>> Joe Landman wrote:
>>> Andrew Dunn wrote:
>>>> I just copied 4+ TiB of information to this array, restarted 5 times
>>>> and tried to access it.... What is going on?
>>> It looks like you have 4 failed drives. sdl,sdi,sdj,sdk
>>>
>>> Is it possible you lost power or connectivity to those drives?
>>>
>>> If you have lsscsi installed, what does lsscsi tell you about this?
>>>
>>> lsscsi  | grep sd[ijkl]
>>>
>>> Given the proximity of the drives in ordering, I'd suspect a power
>>> loss, or cable seating, or similar to those drives.
>>>
>>> Reseat power/signal cables on the drive bays, and see if this helps.
>>>
>>>
>>> Joe
>>>
>>
>
>

-- 
Andrew Dunn
http://agdunn.net

