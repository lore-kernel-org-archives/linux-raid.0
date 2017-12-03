From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm reshaping stuck problem
Date: Sun, 3 Dec 2017 09:17:32 -0500
Message-ID: <fed720e2-fd55-6458-2d68-9b87c96254fc@turmel.org>
References: <73f07f38fb71986fe71be67f00c77698@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73f07f38fb71986fe71be67f00c77698@posteo.de>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: rene.feistle@posteo.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Rene,

On 12/03/2017 07:47 AM, rene.feistle@posteo.de wrote:
> Hello,
> 
> after hours and hours of googling and trying out things, I gave up on
> this. This email is my last hope of getting my data back.

I'm worried for you -- "trying out things" can be dangerous.

> I have 4*4TB drives installed and want to create a raid 5 with them.
> 
> So what I did is create an array of 3 disks (raid 5), copy the data from
> the 4th drive (I don't have more space available) to the raid and then I
> wanted to add the last drive to the raid.

Ok.

> I made a mistake here. I accidentally grew the raid to 4 disks with
> 
> sudo mdadm --grow --raid-devices=4 /dev/md0 --backup-file=/tmp/md0.bak
> 
> BEFORE adding the last drive as a hot spare. Mdadm immediately started a
> reshape and says that it failed - because it consists of 4 drives but
> only 3 drives are available.

Adding the fourth drive at this point should have enabled the reshape to
resume.

> I thought okay, let him complete the reshape and everything will be
> okay. But no - the reshape is stuck at 34.3%.
> 
> What I have tried:
> 
> - Reboot ( about a 100 times)
> - increase stripe cache size up to 32768
> 
> mdadm --assemble --invalid-backup --backup-file=/root/mdadm0.bak
> /dev/md0 /dev/sdc1 /dev/sde1 /dev/sdf1
> 
> And some other things.

We will probably need you to detail "some other things".

> The raid is not mountable. When I try to mount it, the mount command
> just hungs and nothing happens. That means that I had to edit my fstab
> with a rescue cd because it would never boot again.
> That also means that I have no access to my data.
> 
> When I shutdown or reboot the computer, it also hungs at shutdown, I can
> only hard reset it.
> 
> cat /proc/mdstat:
> 
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [r$
> md0 : active raid5 sdc1[0] sdf1[3] sde1[1]
>       7813771264 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UU__]
>       [======>..............]  reshape = 34.3% (1340465664/3906885632) finish=3$
>       bitmap: 3/30 pages [12KB], 65536KB chunk
> 
> unused devices: <none>

Note the "UU__".  That means as some point your three-drive array lost a
drive, and the reshape is showing another missing drive.  A
doubly-degraded array cannot run.

> mdadm --detail /dev/md0
> 
> 
> /dev/md0:
>         Version : 1.2
>   Creation Time : Fri Dec  1 02:10:06 2017
>      Raid Level : raid5
>      Array Size : 7813771264 (7451.79 GiB 8001.30 GB)
>   Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
>    Raid Devices : 4
>   Total Devices : 3
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal
> 
>     Update Time : Sun Dec  3 13:34:43 2017
>           State : active, FAILED, reshaping
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 1
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>  Reshape Status : 34% complete
>   Delta Devices : 1, (3->4)
> 
>            Name : nas-server:0  (local to host nas-server)
>            UUID : e410e68d:76460b65:69c056c0:d2645d55
>          Events : 28155
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync   /dev/sdc1
>        1       8       65        1      active sync   /dev/sde1
>        3       8       81        2      spare rebuilding   /dev/sdf1
>        6       0        0        6      removed

Note the "spare rebuilding" on sdf1.  That means at some point sdf1 was
ejected from your array and you --added it back.  A supposition
buttressed by its slot number displayed in mdstat.  sdf1 was already a
critical device, so --add destroyed important data on it.

> Any help is appreciated, I'm lost.

With the current status of the array, doubly-degraded with a reshape
quite far along, I am not optimistic for you.  However, you have not
provided all the information that might be helpful here.  Please supply
the output (cat'd to a file, not copied from a narrow terminal, please)
of these commands:

for x in /dev/sd[cef]1 ; do echo $x ; mdadm -E $x ; done

for x in /dev/sd[cef] ; do echo $x ; smartctl -iA -l scterc $x ; done

Please make sure your mailer is in plain text mode with line wrap
disabled to ensure the content isn't corrupted when you paste it into
your reply.

Regards,

Phil
