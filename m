From: Andreas Boman <aboman@midgaard.us>
Subject: Re: Failed during rebuild (raid5)
Date: Mon, 06 May 2013 21:14:18 -0400
Message-ID: <5188556A.7050605@midgaard.us>
References: <51839E4F.7050102@midgaard.us> <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com> <51866602.8000704@midgaard.us> <518693EF.6090802@midgaard.us> <518721CD.2040108@turmel.org> <51878BD0.9010809@midgaard.us> <5187A3D2.6060109@turmel.org> <5188189D.1060806@midgaard.us> <51884D49.3090602@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51884D49.3090602@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/06/2013 08:39 PM, Phil Turmel wrote:
> On 05/06/2013 04:54 PM, Andreas Boman wrote:
>> On 05/06/2013 08:36 AM, Phil Turmel wrote:
>
> [trim /]
<snip>
>
>
> Hmmm.  v0.90 is at the end of the member device.  Does your partition go
> all the way to the end?  Please show your partition tables:
>
> fdisk -lu /dev/sd[bcdefg]

fdisk -lu /dev/sd[bcdefg]

Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders, total 2930277168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x3d1e17f0

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              63  2930272064  1465136001   fd  Linux raid 
autodetect

Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders, total 2930277168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdc1              63  2930272064  1465136001   fd  Linux raid 
autodetect

Disk /dev/sdd: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders, total 2930277168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdd1              63  2930272064  1465136001   fd  Linux raid 
autodetect

Disk /dev/sde: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders, total 2930277168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x36cc19da

    Device Boot      Start         End      Blocks   Id  System
/dev/sde1              63  2930272064  1465136001   fd  Linux raid 
autodetect

Disk /dev/sdf: 3000.6 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders, total 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x3d1e17f0

    Device Boot      Start         End      Blocks   Id  System
/dev/sdf1              63  2930272064  1465136001   fd  Linux raid 
autodetect
Partition 1 does not start on physical sector boundary.

Disk /dev/sdg: 3000.6 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders, total 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdg1              63  2930272064  1465136001   fd  Linux raid 
autodetect
Partition 1 does not start on physical sector boundary.

>> Warning: device does not support SCT Error Recovery Control command
>
> Since these cannot be set to a short error timeout, the linux driver's
> timeout must be changed to tolerate 2+ minutes of error recovery.  I
> recommend 180 seconds.  This must be put in /etc/local.d/ or
> /etc/rc.local like so:
>
> # echo 180>/sys/block/sdf/device/timeout
>
> If you don't do this, "check" scrubbing will fail.  And by fail, I mean
> any ordinary URE will kick drives out instead of fixing them.  Search
> the archives for "scterc" and you'll find more detailed explanations
> (attached to horror stories).

Thank you! I had no idea about that or I obviously would not have bought 
those disks...

<snip>
>
> I would encourage you to take your backups of critical files as soon as
> the array is running, before you add a fifth disk.  Then you can add two
> disks and recover/reshape simultaneously.

Hmm.. any hints as to how to do that at the same time? That does sound 
better.

Thanks you for all your help/advice Phil.
Andreas

