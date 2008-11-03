From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: md raid10 regression in 2.6.27.4 (possibly earlier)
Date: Mon, 3 Nov 2008 13:28:47 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811031327590.18246@p34.internal.lan>
References: <490D8EBF.8050400@rabbit.us> <490DE55F.6080600@mandriva.org> <490E3CF9.20208@mandriva.org> <490F3E5E.1040801@mandriva.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <490F3E5E.1040801@mandriva.org>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 3 Nov 2008, Thomas Backlund wrote:

> Thomas Backlund skrev:
>> Thomas Backlund skrev:
>>> Peter Rabbitson skrev:
>
> Ands some more info...
> After rebooting into 2.6.27.4 I got this again:
>
> md5 : active raid1 sdb7[1] sda7[0] sdd7[2]
>      530048 blocks [4/3] [UUU_]
>
> md3 : active raid10 sdc5[4](S) sda5[3] sdd5[0] sdb5[1]
>      20980608 blocks 64K chunks 2 near-copies [4/3] [UU_U]
>
> md2 : active raid10 sdc3[4](S) sda3[5](S) sdd3[3] sdb3[1]
>      41961600 blocks 64K chunks 2 near-copies [4/2] [_U_U]
>
> So it seems it's not only raid10 affected....
>
> and here how they are started:
> [root@tmb ~]# cat /etc/udev/rules.d/70-mdadm.rules
> SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="linux_raid*", \
> 	RUN+="/sbin/mdadm --incremental --run --scan $root/%k"
>

Maybe only raid10 + other raids?  Running r1+r5 here, no problems with 
2.6.27.4:

$ cat /proc/mdstat 
Personalities : [raid1] [raid6] [raid5] [raid4] 
md1 : active raid1 sdb2[1] sda2[0]
       136448 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
       276109056 blocks [2/2] [UU]

md3 : active raid5 sdl1[9] sdk1[6] sdj1[7] sdi1[5] sdh1[8] sdg1[4] sdf1[3] sde1[0] sdd1[1] sdc1[2]
       2637296640 blocks level 5, 1024k chunk, algorithm 2 [10/10] [UUUUUUUUUU]

md0 : active raid1 sdb1[1] sda1[0]
       16787776 blocks [2/2] [UU]

unused devices: <none>

