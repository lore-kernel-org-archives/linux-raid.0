From: Brendan Hide <brendan@swiftspirit.co.za>
Subject: Re: disk failed during reshape, md3_reshape blocked
Date: Thu, 05 Jul 2012 01:37:15 +0200
Message-ID: <4FF4D3AB.2060001@swiftspirit.co.za>
References: <4FF4A511.3080208@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FF4A511.3080208@swiftspirit.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

I've come across some information with a similar situation with similar, 
albeit without raid: 
http://sourceforge.net/projects/clonezilla/forums/forum/663168/topic/4833772

Importantly, the errors given at the above URL are very similar to 
errors I noticed whenever the server crashed:
[76635.205262] ata1.00 exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0 
....(similar lines of text including one: failed command : READ FPDMA 
QUEUED [76635.210673] ata1.00 status {DRDY ERR} [76635.210698] ata1.00 
error: {UNC}

I'm attempting to use ddrescue as described here to clone the 
fail{ed,ing} disk another spare disk: 
http://www.forensicswiki.org/wiki/Ddrescue

Hopefully this part works out, but I'm still not 100% sure if I'm doing 
"the right thing" to get this sorted or if there's an alternative method.

On 2012/07/04 10:18 PM, Brendan Hide wrote:
> Hi, all
>
> In case its relevant I'm using ArchLinux' LTS kernel 3.0.36-1-lts and 
> mdadm v3.2.5 (2012, May 18th). At first I asked for help on the 
> ArchLinux forums but have had zero response: 
> https://bbs.archlinux.org/viewtopic.php?id=144448
>
> I have(had?) a raid5 array of 4x 1.5TB drives (that works out to 4.5 
> TB or 4.1TiB). I added another drive, went through the standard growth 
> procedure and everything seemed fine. At about 66% through the 
> reshape, one of the disks failed and, due to the resulting blocking 
> errors (some details below), it eventually caused a 
> crash/panic/reboot/something. I was away at the time however I did at 
> least get a failspare notification mail with the following md3 detail 
> before the crash:
>
> md3 : active raid5 sdb1[6](S) sdf1[4] sde1[3] sdc1[5](F) sdd1[1]
>       4395408384 blocks super 1.2 level 5, 512k chunk, algorithm 2 
> [5/3] [_UUU_]
>       [=============>.......]  reshape = 66.8% (980003500/1465136128) 
> finish=759.8min speed=10640K/sec
>
> In theory all my data should still be available on the remaining 
> disks, I just don't know how to get to it. Here's what I've been 
> trying so far:
>
>  *
>
>    Attempting to assemble the array with 4 out of 5 drives is
>    unsuccessful because the new drive appears to be seen as a "spare" -
>    perhaps that is standard until such time that it is fully integrated
>    into the array. The output here is:
>
>    |mdadm: /dev/md3 assembled from 3 drives and 1 spare - not enough 
> to start the array.|
>
>  *
>
>    Attempting to assemble the array with 5 out of 5 drives works
>    briefly but, no matter what I do, mdadm tries to finish reshaping.
>    Two minutes after the assemble attempt, because the disk is giving
>    an apparently permanent read error, the console starts printing
>    messages along the lines of:
>
>    |INFO: task md3_reshape:$PID blocked for more than 120 seconds.
>    [ 1080.320000] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message|
>
>    This is in spite that even /proc/mdstat shows that the disk is
>    failed and that the array is degraded. After a few minutes of the
>    above error I have to REISUB (or even hard-reset) due to the server
>    becoming grandually unresponsive. I really don't want to do that too
>    often. I've tried using the "--freeze-reshape" flag but I'm either
>    doing it wrong or I'm misunderstanding the purpose of that option.
>
> This is the status immediately after booting with the failed disk 
> unplugged. A reassemble requires a --stop, (optionally my plugging in 
> the failed drive, --stop again), and then the --assemble command:
>
> |$ cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md3 : inactive sdc1[1](S) sdb1[6](S) sde1[4](S) sdd1[3](S)
>       5860546144 blocks super 1.2
>
> md1 : active raid1 sdf3[2] sda3[0]
>       239746096 blocks super 1.2 [2/2] [UU]
>       bitmap: 1/2 pages [4KB], 65536KB chunk
>
> md4 : active raid1 sdf2[1] sda2[0]
>       4193268 blocks super 1.2 [2/2] [UU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>
> md0 : active raid1 sdf1[1] sda1[0]
>       255936 blocks [2/2] [UU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>
> unused devices:<none>|
>
> The server is a personal file server. It contains a lot of unimportant 
> data but it does contain some important documents and photos I'd like 
> to retrieve. Any help would be appreciated.
>


-- 
Brendan Hide

083 448 3867
http://swiftspirit.co.za/

