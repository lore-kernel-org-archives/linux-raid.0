From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 degraded after mdadm -S, mdadm --assemble (everytime)
Date: Mon, 26 Jun 2006 10:20:45 -0400
Message-ID: <449FED3D.8060709@tmr.com>
References: <20060624104745.GA6352@defiant.crash>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060624104745.GA6352@defiant.crash>
Sender: linux-raid-owner@vger.kernel.org
To: Ronald Lembcke <es186@fen-net.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ronald Lembcke wrote:

>Hi!
>
>I set up a RAID5 array of 4 disks. I initially created a degraded array
>and added the fourth disk (sda1) later.
>
>The array is "clean", but when I do  
>  mdadm -S /dev/md0 
>  mdadm --assemble /dev/md0 /dev/sd[abcd]1
>it won't start. It always says sda1 is "failed".
>
>When I remove sda1 and add it again everything seems to be fine until I
>stop the array. 
>
>Below is the output of /proc/mdstat, mdadm -D -Q, mdadm -E and a piece of the
>kernel log.
>The output of mdadm -E looks strange for /dev/sd[bcd]1, saying "1 failed".
>
>What can I do about this?
>How could this happen? I mixed up the syntax when adding the fourth disk and
>tried these two commands (at least one didn't yield an error message):
>mdadm --manage -a /dev/md0 /dev/sda1
>mdadm --manage -a /dev/sda1 /dev/md0
>
>
>Thanks in advance ...
>                      Roni
>
>
>
>ganges:~# cat /proc/mdstat 
>Personalities : [raid5] [raid4] 
>md0 : active raid5 sda1[4] sdc1[0] sdb1[2] sdd1[1]
>      691404864 blocks super 1.0 level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
>      
>unused devices: <none>
>
I will just comment that the 0 1 2   4 numbering on the devices is 
unusual. When you created this did you do something which made md think 
there was another device, failed or missing, which was device[3]? I just 
looked at a bunch of my arrays and found no similar examples.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

