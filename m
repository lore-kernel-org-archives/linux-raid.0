From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering failed array
Date: Thu, 22 Sep 2011 17:52:30 -0400
Message-ID: <4E7BAE1E.9020704@turmel.org>
References: <CAB1R3sirkfauftgvNN5Sz9_ZGFaHC7_jZUD5cyRrhfARue08TQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sirkfauftgvNN5Sz9_ZGFaHC7_jZUD5cyRrhfARue08TQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Alex,

More information please....

On 09/22/2011 02:07 PM, Alex wrote:
> Hi,
> 
> I have a RAID5 array that has died and I need help recovering it.
> Somehow two of the four partitions in the array have failed. The
> server was completely dead, and had very little recognizable
> information on the console before it was rebooted. I believe they were
> kernel messages, but it wasn't a panic.
> 
> I'm able to read data from all four disks (using dd) but can't figure
> out how to try and reassmble it. Here is some information I've
> obtained by booting from a rescue CDROM and the mdadm.conf from
> backup.
> 
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] [linear]
> md1 : inactive sda2[0] sdd2[4](S) sdb2[1]
>       205820928 blocks super 1.1
> 
> md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
>       255988 blocks super 1.0 [4/4] [UUUU]
> 
> 
> # mdadm --add /dev/md1 /dev/sdd2
> mdadm: Cannot open /dev/sdd2: Device or resource busy
> 
> # mdadm --run /dev/md1
> mdadm: failed to run array /dev/md1: Input/output error
> 
> I've tried "--assemble --scan" and it also provides an IO error.
> 
> mdadm.conf:
> # mdadm.conf written out by anaconda
> MAILADDR root
> AUTO +imsm +1.x -all
> ARRAY /dev/md0 level=raid1 num-devices=4
> UUID=9406b71d:8024a882:f17932f6:98d4df18
> ARRAY /dev/md1 level=raid5 num-devices=4
> UUID=f5bb8db9:85f66b43:32a8282a:fb664152

Please show the output of "lsdrv" [1] and then "mdadm -D /dev/md[01]", and also "mdadm -E /dev/sd[abcd][12]"

(From within your rescue environment.)  Some errors are likely, but get what you can.

Phil

[1] http://github.com/pturmel/lsdrv
