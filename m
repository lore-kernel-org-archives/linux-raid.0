From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Troubles making a raid5 system work.
Date: Mon, 30 May 2005 09:53:41 +0200
Message-ID: <62b0912f05053000534655bb7f@mail.gmail.com>
References: <4299e746.607b3ba2.6e4a.ffff9b64@mx.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4299e746.607b3ba2.6e4a.ffff9b64@mx.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Zafra <fzafra@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Francisco Zafra wrote:
>  I have 8 200GB new SATA HDs, mdadm v1.9.0 and kernel 2.6.11.8.

> When the create command finish proc/mdstats report the following:
>         md0 : active raid5 sda1[0] sdh1[8] sdg1[6] sdf1[5] sde1[4] sdd1[3]
> sdc1[9](F) sdb1[1]
>         1367507456 blocks level 5, 256k chunk, algorithm 2 [8/6] [UU_UUUU_]

Odd that there's two missing disks in [UU_UUUU_], but only one F
marker on the above line.

> mdadm --detail, an obtained this:
> /dev/md0:
>         Version : 00.90.01
>   Creation Time : Tue May 24 20:02:28 2005
>      Raid Level : raid5
>      Array Size : 1367507456 (1304.16 GiB 1400.33 GB)
>     Device Size : 195358208 (186.31 GiB 200.05 GB)
>    Raid Devices : 8
>   Total Devices : 8
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun May 29 17:29:45 2005
>           State : clean, degraded
>  Active Devices : 6
> Working Devices : 7
>  Failed Devices : 1
>   Spare Devices : 1

Oh, so that's why there's a missing F.

MD has assigned one of the disks to be a Spare device, even though you
did not specify any spares on the mdadm command line or in the .conf
file.

No clue why, but seems wrong!!

>        8       8      113        7      spare rebuilding   /dev/sdh1

MD's trying to rebuild with the spare.

>        9       8       33        -      faulty   /dev/sdc1

Doesn't look good.

> in the system logs I have thousands of messages like this, that not were
> generating during the create command:

[snip repeated sync start/done messages]

I had the same problem.
There was once a bug in MD that caused this when syncing + multiple
devices fail.
See this thread for details:

http://thread.gmane.org/gmane.linux.raid/7714

(Ignore everything from Patrik Jonsson / "toy array" and onwards, it's
just someone that doesn't know how their mailer works - shouldn't have
been part of the thread)

> # mdadm -R /dev/md0
> mdadm: failed to run array /dev/md0: Invalid argument

Hm, could be a bug, or maybe it's just a misleading error message.

I wouldn't expect anyone to be able to figure out what's going on from
the two words "Invalid argument", so if it can be fixed, this should
definitely say something a little more informational.

> I have tried this several times, I have even earsed and checked each drive
> with:
> 
>         mdadm --zero-superblock /dev/sdd
>         dd if=/dev/sdd of=/dev/null bs=1024k
>         badblocks -svw /dev/sdd

Perhaps there is a more subtle hardware problem, for example cable
problems are  common with SATA drives.

If you're using Maxtor disks, you could try testing each disk with
their PowerMax utility, available for download on their web site.

It might be that your problem only occurs when multiple disks are
accessed at the same time.  You could:
 - Try the above dd, but run it in the background with "dd <...> &"
for multiple disks at the same time.
 - Nuke the superblocks and create the array again, but this time do a
'tail -f /var/log/messages | grep -v md:' before you start, to check
for any IDE messages you might have missed.
 - Apply the patch that Neil Brown mentions in the aforelinkedto
thread and see if things start to become more clear.
