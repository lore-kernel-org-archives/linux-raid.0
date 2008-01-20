From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: One Large md or Many Smaller md for Better Peformance?
Date: Sun, 20 Jan 2008 17:18:40 -0500
Message-ID: <4793C8C0.3010301@tmr.com>
References: <4793AE0E.609@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4793AE0E.609@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Question: with the same number of physical drives,  do I get better 
> performance with one large md-based drive, or do I get better 
> performance if I have several smaller md-based drives?
>
> Situation: dual CPU, 4 drives (which I will set up as RAID-1 after 
> being terrorized by the anti-RAID-5 polemics included in the Debian 
> distro of mdadm).
>
> I've two choices:
>
> 1. Allocate all the drive space into a single large partition, place 
> into a single RAID array (either 10 or 1 + LVM, a separate question).
>
One partitionable RAID-10, perhaps, then partition as needed. Read the 
discussion here about performance of LVM and RAID. I personally don't do 
LVM unless I know I will have to have great flexibility of configuration 
and can give up performance to get it. Other report different results, 
so make up your own mind.
> 2. Allocate each drive into several smaller partitions. Make each set 
> of smaller partitions into a separate RAID 1 array and use separate 
> RAID md drives for the various file systems.
>
> Example use case:
>
> While working other problems, I download a large torrent in the 
> background. The torrent writes to its own, separate file system called 
> /foo. If /foo is mounted on its own RAID 10 or 1-LVM array, will that 
> help or hinder overall system responsiveness?
>
> It would seem a "no brainer" that giving each major filesystem its own 
> array would allow for better threading and responsiveness, but I'm 
> picking up hints in various piece of documentation that the 
> performance can be counter-intuitive. I've even considered the 
> possibility of giving /var and /usr separate RAID arrays (data vs. 
> executables).
>
> If an expert could chime in, I'd appreciate it a great deal.
>
>


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


