From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: MD devices renaming or re-ordering question
Date: Thu, 20 Sep 2007 11:12:14 -0400
Message-ID: <46F28DCE.4040102@tmr.com>
References: <46E984E7.1080903@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46E984E7.1080903@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maurice Hilarius wrote:
> Hi to all.
>
> I wonder if somebody would care to help me to solve a problem?
>
> I have some servers.
> They are running CentOS5
> This OS has a limitation where the maximum filesystem size is 8TB.
>
> Each server curr3ently has a  AMCC/3WARE 16 port SATA controllers. Total
> of 16 ports / drives
> I am using 750GB drives.
>
> I am exporting the drives as single, NOT as hardware RAID
> That is due to the filesystem and controller limitations, among other
> reasons.
>
> Each server currently has 16 disks attached to the one controller
>
> I want to add a 2nd controller, and, for now, 4 more disks on it.
>
> I want to have the boot disk as a plain disk, as presently configured as
> sda1,2,3
>   

I'm not clear on what you mean by a "plain disk" followed by a list of 
partitions. If that means putting all your initial data on a single disk 
without RAID protection, that's a far worse idea in my experience than 
splitting arrays across controllers.
> The remaining 15 disks are configured as :
> sdb1 through sde1 as md0 ( 4 devices/partitions)
> sdf1 through sdp1 as md1 (10 devices/partitions)
> I want to add a 2nd controller, and 4 more drives, to the md0 device.
>
> But, I do not want md0 to be "split" across the 2 controllers this way.
> I prefer to do the split on md1
>   

Move the md0 drives to the 2nd controller, add more.
> Other than starting from scratch, the best solution would be to add the
> disks to md0, then to "magically" turn md0 into md1, and md1 into md0
>   

Unless you want to practice doing critical config changes, why? Moving 
the drives won't effect their name, at least not unless you have done 
something like configure by physical partition name instead of UUID. 
Doing that for more than a few drives is a learning experience waiting 
to happen. If that's the case, backup your mdadm.conf file and 
reconfigure using UUID, then start moving things around.
> So, the question:
> How does one make md1 into md0, and vice versa?
> Without losing the data on these md's ?
>
> Thanks in advance for any suggestions.

I would start by being sure the computer is doing the work, not the 
administrator, use UUID for assembly. Then move the drives for md0 and 
grow it.

Then consider the performance vs. reliability issues of having all 
drives on a single controller. Multiple controllers give you more points 
of failure unless you are mirroring across them, but better peak 
performance. Note, I'm suggesting evaluating what you are doing only, it 
may be fine, just avoids "didn't think about that" events.

Well, you asked for suggestions...  ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

