From: "frank jenkins" <fjenkins873@hotmail.com>
Subject: RE: raid5 recover after a 2 disk failure
Date: Sun, 17 Jun 2007 07:14:20 +0000
Message-ID: <BAY123-F328D6B9928888CCA33986AEB1C0@phx.gbl>
References: <BAY123-F18A64D0231FBB48D99F87FEB1C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY123-F18A64D0231FBB48D99F87FEB1C0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To clarify, all I want to do is temporarily mount the array so I can copy as 
much data off as possible, then blow the entire array away and find out if 
sdc really is bad, or its just a bad block or bad cable or whatever. I get 
the feeling that sdc is mostly fine, in which case I should be able to 
recover most of the data on the array.

Also, is it possible to set this disks read only so that mdadm won't write 
to them no matter what I do? That would make me feel a lot better when 
trying various options to force mdadm into mounting them.

Thanks, Frank


>From: "frank jenkins" <fjenkins873@hotmail.com>
>To: linux-raid@vger.kernel.org
>Subject: raid5 recover after a 2 disk failure
>Date: Sun, 17 Jun 2007 06:57:55 +0000
>
>I have a 5 disk raid5 array that had a disk failure. I removed the disk, 
>added a new one (and a spare), and recovery began. Halfway through 
>recovery, a second disk failed.
>
>However, while the first disk really was dead, the second seems to have 
>been a transient error, as the smart data and disk testing seem to show the 
>disk is fine.
>
>The question is, how can I tell mdadm to unfail this second disk. From what 
>I've found in the archives, I think I need to use the --force option, but 
>I'm concern about getting device names in the wrong order (and totally 
>destroying my array in the process), so thought I'd ask here first. Here is 
>my /proc/mdstat when recovery initially began:
>
>Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
>[raid4] [raid10]
>md1 : active raid5 sdc1[0](S) sdf1[5] sdb1[4] sda1[3] sde1[2] sdd1[1]
>      976783616 blocks level 5, 32k chunk, algorithm 2 [5/4] [_UUUU]
>      [>....................]  recovery =  0.0% (237952/244195904) 
>finish=427.0min speed=9518K/sec
>
>and here is my current mdstat:
>Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
>[raid4] [raid10]
>md1 : active raid5 sdc1[5](S) sdf1[6](S) sdb1[4] sda1[3] sde1[7](F) sdd1[1]
>      976783616 blocks level 5, 32k chunk, algorithm 2 [5/3] [_U_UU]
>
>sde is the disk that is now marked as failed, and which I would like to put 
>back into service.
>
>
>Also, what does the number in []'s mean after each device, and why did that 
>number change on sdc, sde, and sdf?
>
>Thanks, Frank
>
>_________________________________________________________________
>Get a preview of Live Earth, the hottest event this summer - only on MSN 
>http://liveearth.msn.com?source=msntaglineliveearthhm
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Get a preview of Live Earth, the hottest event this summer - only on MSN 
http://liveearth.msn.com?source=msntaglineliveearthhm

