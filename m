From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid sync observations
Date: Sun, 08 Jan 2006 13:18:47 -0500
Message-ID: <43C15787.1080304@tmr.com>
References: <E1Eol86-0008Ju-3J@highlab.com> <43A8B623.5060704@nighthawkrad.net> <20051221114912.GY10278@strugglers.net> <E1Ep7MF-0000uF-Fj@highlab.com> <Pine.LNX.4.56.0512211707360.14743@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0512211707360.14743@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Sebastian Kuzminsky <seb@highlab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:

>On Wed, 21 Dec 2005, Sebastian Kuzminsky wrote:
>
>  
>
>>>But how does the performance for read and write compare?
>>>      
>>>
>>Good question!  I'll post some performance numbers of the RAID-6
>>configuration when I have it up and running.
>>    
>>
>
>Post your hardware config too if you don't mind. I have one server with 8
>drives and for swap (Which it never does!) I created 2 x 4 disk RAID 6
>arrays (same partition on all disks) and gave them to the kernel with
>equal priority
>
>Filename                                Type            Size    Used    Priority
>/dev/md10                               partition       1991800 0       1
>/dev/md11                               partition       1991800 0       1
>
>md10 : active raid6 sdd2[3] sdc2[2] sdb2[1] sda2[0]
>      1991808 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
>
>md11 : active raid6 sdh2[3] sdg2[2] sdf2[1] sde2[0]
>      1991808 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
>
>/dev/md10:
> Timing buffered disk reads:  64 MB in  0.66 seconds = 97.28 MB/sec
>
>/dev/md11:
> Timing buffered disk reads:  64 MB in  0.95 seconds = 67.59 MB/sec
>
>md10 is an on-board 4-port SII SATA controller, md11 is 2 x 2-port SII
>PCI cards. (Server is currently moderately loaded, so results are a bit
>lower than usual
>
>Cue the must/must not swap on RAID arguments ;-)
>

I wouldn't swap on RAID-6... performance is importand, swap is tiny 
compared to disk size. I would go to 2GB partitions and four-way RAID-1, 
since fast swap in seems to make for better "feel" and write is cached 
somewhat.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

