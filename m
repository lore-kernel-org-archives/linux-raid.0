From: Adam Thompson <athompso@athompso.net>
Subject: Re: dead RAID6 array on CentOS6.6 / kernel 3.19
Date: Tue, 10 Feb 2015 20:53:35 -0600
Message-ID: <54DAC42F.3090600@athompso.net>
References: <54DAB614.70302@athompso.net> <54DAC0E2.2070303@turmel.org>
Reply-To: athompso@athompso.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DAC0E2.2070303@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Cc: "Board, MUUG" <board@muug.mb.ca>, elrepo@lists.elrepo.org
List-Id: linux-raid.ids

On 2015-02-10 08:39 PM, Phil Turmel wrote:
> Hi Adam,
>
> On 02/10/2015 08:53 PM, Adam Thompson wrote:
>> So, I was doing some work on the new server tonight, stopping/starting
>> NFS caused a kernel panic, and I thought rebooting would be a good
>> idea... Apparently not!
>> Sure enough, no array.
>>> [root@muug ~]# cat /proc/mdstat
>>> Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
>>> md0 : active raid1 sdm1[0] sdn1[1]
>>>        1048512 blocks super 1.0 [2/2] [UU]
>>>        bitmap: 0/1 pages [0KB], 65536KB chunk
>>>
>>> md127 : inactive sdk[10] sdj[9] sdi[8] sdl[12]
>>>        15627550048 blocks super 1.2
>>>
>>> unused devices: <none>
> Not really no array -- this remnant is inactive.  On older kernel /
> mdadm combinations, you have to --stop the inactive array before you try
> again.  Please add --verbose to your --assemble --force
>
> If that doesn't work, use a bootable thumb drive with current kernel and
> mdadm and --assemble --force again.
>
> Phil

I do note that the array was stopped before I tried re-assembling it the 
first time (second invocation overall).  It stopped itself, as can be 
seen from the output.

Only with the addition of --no-degraded does the array assemble and 
remain assembled but un-started:
> [root@muug ~]# mdadm --verbose --assemble --force --no-degraded 
> /dev/md127 /dev/sd[a-l]
> mdadm: looking for devices for /dev/md127
> mdadm: /dev/sda is identified as a member of /dev/md127, slot 11.
> mdadm: /dev/sdb is identified as a member of /dev/md127, slot 2.
> mdadm: /dev/sdc is identified as a member of /dev/md127, slot 1.
> mdadm: /dev/sdd is identified as a member of /dev/md127, slot 3.
> mdadm: /dev/sde is identified as a member of /dev/md127, slot 5.
> mdadm: /dev/sdf is identified as a member of /dev/md127, slot 6.
> mdadm: /dev/sdg is identified as a member of /dev/md127, slot 7.
> mdadm: /dev/sdh is identified as a member of /dev/md127, slot 4.
> mdadm: /dev/sdi is identified as a member of /dev/md127, slot 8.
> mdadm: /dev/sdj is identified as a member of /dev/md127, slot 9.
> mdadm: /dev/sdk is identified as a member of /dev/md127, slot 10.
> mdadm: /dev/sdl is identified as a member of /dev/md127, slot 0.
> mdadm: added /dev/sdc to /dev/md127 as 1
> mdadm: added /dev/sdb to /dev/md127 as 2
> mdadm: added /dev/sdd to /dev/md127 as 3
> mdadm: added /dev/sdh to /dev/md127 as 4
> mdadm: added /dev/sde to /dev/md127 as 5
> mdadm: added /dev/sdf to /dev/md127 as 6 (possibly out of date)
> mdadm: added /dev/sdg to /dev/md127 as 7 (possibly out of date)
> mdadm: added /dev/sdi to /dev/md127 as 8
> mdadm: added /dev/sdj to /dev/md127 as 9
> mdadm: added /dev/sdk to /dev/md127 as 10
> mdadm: added /dev/sda to /dev/md127 as 11 (possibly out of date)
> mdadm: added /dev/sdl to /dev/md127 as 0
> mdadm: /dev/md127 assembled from 9 drives (out of 12), but not started.

Which then gives:
> [root@muug ~]# mdadm --detail /dev/md127
> /dev/md127:
>         Version : 1.2
>      Raid Level : raid0
>   Total Devices : 12
>     Persistence : Superblock is persistent
>
>           State : inactive
>
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>            UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>          Events : 26263
>
>     Number   Major   Minor   RaidDevice
>
>        -       8        0        -        /dev/sda
>        -       8       16        -        /dev/sdb
>        -       8       32        -        /dev/sdc
>        -       8       48        -        /dev/sdd
>        -       8       64        -        /dev/sde
>        -       8       80        -        /dev/sdf
>        -       8       96        -        /dev/sdg
>        -       8      112        -        /dev/sdh
>        -       8      128        -        /dev/sdi
>        -       8      144        -        /dev/sdj
>        -       8      160        -        /dev/sdk
>        -       8      176        -        /dev/sdl

and

> [root@muug ~]# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
> md127 : inactive sdl[12](S) sda[13](S) sdk[10](S) sdj[9](S) sdi[8](S) 
> sdg[7](S) sdf[6](S) sde[5](S) sdh[4](S) sdd[3](S) sdb[2](S) sdc[1](S)
>       46882650144 blocks super 1.2
>
> md0 : active raid1 sdm1[0] sdn1[1]
>       1048512 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>
> unused devices: <none>

and...

> [root@muug ~]# mdadm --verbose --misc --run --readonly /dev/md127
> mdadm: /dev/md127 does not appear to be active.


Also, kernel 3.19, which I mentioned we're running, pretty much *is* my 
definition of an up-to-date kernel... how much newer do you want me to 
try, and where would you recommend I find such a thing in a bootable image?

Thanks,
-Adam

-- 
-Adam Thompson
  athompso@athompso.net
  +1 (204) 291-7950 - cell
  +1 (204) 489-6515 - fax

