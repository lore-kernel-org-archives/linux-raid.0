From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: System halt when re-inserting a HotSwap SCSI in Soft RAID1
Date: Fri, 20 Sep 2002 15:03:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D8B1CA5.6090306@hum.auc.dk>
References: <Pine.LNX.4.44.0209162301200.24650-100000@ddx.a2000.nu>	<001d01c25ef9$6bc25240$900d0d93@M02WS17219>	<15752.23100.95651.59572@notabene.cse.unsw.edu.au>	<00f001c2600c$3dd29480$6a01a8c0@bmoon> <15754.29612.582936.661082@notabene.cse.unsw.edu.au> <3D8B1589.70502@ab-innovation.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jens Arnfelt <jens.arnfelt@ab-innovation.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jens Arnfelt wrote:

> Hi There!
>
> I have two scsi disk with idendical partitiontables (see below) 
> installed on a SCA HotSwap enable Fujitsu-Siemens server.
>
> As a test I've removed one of the disks and the /dev/md0 went in 
> degraded mode as expected. (se snip from /var/log/messages below)

[snip]

> The real problems start when I re-insert the /dev/sda.
> The systems stops all activity on HD after some errore in the 
> /var/log/messages and a hard reset is only option.


This isn't a soft raid problem, it's a SCSI layer issue:
(from the HOWTO)
"Hot-swapping with SCA

With SCA, it should be possible to hot-plug devices. However, I don't 
have the hardware to try this out, and I haven't heard from anyone who's 
tried, so I can't really give any recipe on how to do this.

If you want to play with this, you should know about SCSI and RAID 
internals anyway. So I'm not going to write something here that I can't 
verify works, instead I can give a few clues:

    * Grep for remove-single-device in linux/drivers/scsi/scsi.c
    * Take a look at raidhotremove and raidhotadd
"

Regards,
Mads Bach

