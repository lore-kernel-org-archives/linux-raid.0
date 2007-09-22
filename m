From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid5 post mortem analisys
Date: Sat, 22 Sep 2007 09:52:11 -0400
Message-ID: <46F51E0B.4000402@tmr.com>
References: <46F3F06F.1060008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46F3F06F.1060008@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Santos <daniel.dlds@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Santos wrote:
> Hello,
>
> I had a raid 5 array with 3 drives. (on a USB 2.0 bus :)). After some 
> time, on drive failed. After some more time another drive failed and 
> the array stopped running.
> I know that the usage pattern from the first failure to the second was 
> read-only, i.e as a user only reads were performed.

Unless you were mounting the filesystem with the "noatime" parameter, 
each read resulted in a write to update the inode, and possibly a 
journal file depending on the filesystem type.
> I also know that the cause of the drive's failures was that they just 
> dissapeared from the USB bus (probably from a bug in the hard drive's 
> enclosure's USB to IDE bridge)
>
> I trashed the array anyway, but since I am new to linux md devices, I 
> was wishing that you could help me understand if there was any 
> possibility of getting it back up assuming that there was no data 
> corruption.

You might have been able to save the data, had you grabbed it quickly, 
but without reasonably stable hardware you can't have stable RAID (or 
anything else). If you had stopped the array and done a power cycles, 
assuming that your analysis of the failure is correct, the third drive 
might have come back to life and a resync could have been done. There 
might also be some hardware option which would have helped, in the mount 
or at kernel boot, although nothing comes to mind.
> I run kernel 2.6.17 on a debian system and use mdadm for controlling 
> the array from user space.

There have been some fixes in more recent kernels, but I don't know that 
they would help if the hardware just goes walkabout. Someone else may 
have thoughts on that, but having drives just go away is hard to recover.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

