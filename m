From: Michal Soltys <soltys@ziu.info>
Subject: Re: Raid 5 Problem
Date: Sun, 14 Dec 2008 23:02:46 +0100
Message-ID: <49458286.7060802@ziu.info>
References: <49450D04.8060703@nigelterry.net> <4945276E.1010405@ziu.info> <49456F94.8020100@nigelterry.net> <49457719.4000009@ziu.info> <49457BE3.4090200@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49457BE3.4090200@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: nterry <nigel@nigelterry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

nterry wrote:
> [root@homepc ~]# mdadm -Esvv /dev/sdb
> /dev/sdb:
>          Magic : a92b4efc
>        Version : 0.90.02
>           UUID : c57d50aa:1b3bcabd:ab04d342:6049b3f1
>  Creation Time : Thu Dec 15 15:29:36 2005
>     Raid Level : raid5

Yup - that's leftover block from one of your earlier arrays/attempts. It 
just happens to sit in unused area of /dev/sdb1, but is picked as valid 
/dev/sdb superblock

> 
> I added the DEVICE /dev/sd[bcde]1 to mdadm.conf and that apepars to have 
> fixed the problem.  2 reboots and it worked both times.
> 
> I also note now that:
> [root@homepc ~]# mdadm --examine --scan
> ARRAY /dev/md0 level=raid5 num-devices=4 
> UUID=50e3173e:b5d2bdb6:7db3576b:644409bb
>   spares=1
> [root@homepc ~]#

That DEVICE line limits mdadm to only look at sd[bcde]1 as potential 
array members, so examine shows only current array. If you plan to add 
more raid arrays later, be sure to change it. Also read below.

> Frankly I don't know enough about the workings of udev and the boot 
> process to be able to get into that.  However these two files might mean 
> something to you:
> 
> [...]
> 
> AND...
> 
> [root@homepc ~]# cat /etc/udev/rules.d/70-mdadm.rules
> # This file causes block devices with Linux RAID (mdadm) signatures to
> # automatically cause mdadm to be run.
> # See udev(8) for syntax
> 
> SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="linux_raid*", \
>    RUN+="/sbin/mdadm -I --auto=yes $root/%k"
> [root@homepc ~]#
> 

That's the part of the problem. In human language it means, that during 
udev event related to device add or change, any device detected as being 
part of linux raid, will be incrementally assembled. ID_FS_TYPE is 
exported in one of the earlier rules by vol_id helper tool. So during 
initial udev run, /dev/sdb is picked up, and forces mdadm later to drop 
/dev/sdb1 from array during every boot.

You can comment it out safely (or just remove whole 70-mdadm.rules 
file). Then you can remove DEVICE line from mdadm.conf

> Thanks for getting me working
> 

np :)
