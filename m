From: "me at tmr.com" <tmrbill@tmr.com>
Subject: (unknown)
Date: Mon, 12 May 2008 07:29:30 -0400
Message-ID: <200805121129.m4CBTU5h031396@firewall2.tmr.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

David Lethe wrote:
> there are still other factors to consider.  HW raid can usually be configured to monitor and repair bad blocks and data consistency in background with no cpu impact (but allow for bus overhead, depending on architecture.  When things go bad and RAID is in stress, then there is a world of difference between the methodologies. People rarely consider that ... Until they have corruption.  HW RAID (with  battery backup) will rarely corrupt on power failure or os crash, but is not immune.  SW RAID, however, exposes you much more.  Read the threads relating to bugs and data losses on md rebuilds after failures. The md code just can't address certain failure scenarios that HW RAID protects against .. But it still does a good job.  HW RAID is not immune by any means, some controllers have higher 
 risk of loss then others.  Yes the OP asked for performance diffs, but performance under stress is fair game, as is data integrity.
>
> Think about it ... 100 percent of disks fail, eventually, so data integrity and recovery must be considered.
>
> Neither SW or HW RAID is best or covers all failure scenarios, but please don't make a deployment decision based on performance when everything is working fine.  Testing RAID is one of the things I do, so I speak from authority here. Too many people have blind faith that any kind of parity-protected RAID protects against hardware faults.  This is not the real-world behavior.  
>   

One other thought, there is *no such thing* as "hardware raid," it's 
*all* software raid, your choice is to have it in the kernel, or in an 
eprom on the controller, or in a big box near your computer, so all you 
really have is a chance to play "who do you trust?"

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


