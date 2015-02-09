From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Upgrading storage server
Date: Mon, 09 Feb 2015 09:47:37 -0500
Message-ID: <54D8C889.4060006@gmail.com>
References: <54D8A9AD.3060700@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D8A9AD.3060700@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/09/2015 07:35 AM, Adam Goryachev wrote:
> Hi all,
>
> After making a whole string of mistakes in building a iSCSI server 
> about 2 years ago, I'm now looking to replace it without all the wrong 
> turns/mistakes. I was hoping you could all offer some advice on 
> hardware selection/choices.
>
> The target usage as above is an iSCSI server as the backend to a bunch 
> of VM's. Currently I have two identical storage servers, using 7 x SSD 
> with Linux MD Raid, then using LVM to divide it up for each VM, and 
> then DRBD on top to sync the two servers together, on the top is ietd 
> to share the multiple DRBD devices out. The two servers have a single 
> 10Gbps connection between them for DRBD to sync the data. They also 
> have a second 10Gbps ethernet for iscsi to use, with a pair of 1Gbps 
> for management (on board). I have 8 x PC's running Xen with 2 x 1Gbps 
> ethernet for iSCSI and one 1Gbps ethernet for the "user"/management LAN.
>
> Current hardware of the storage servers are:
> 7 x Intel 480GB SSD Model SSDSC2CW480A3
> 1 x Intel 180GB SSD Model SSDSC2CT180A4  (for the OS)

We always use 2 drives in an MD RAID1 for OS.

> 1 x LSI Logic SAS2308 PCI-Express (8 x SATA connections)

Ok.  This is a lower end card on the performance side.

> 1 x Intel Dual port 10Gbps 82599EB SFI/SFP+ Ethernet
> 1 x Intel Xeon CPU E3-1230 V2 @ 3.30GHz
> Motherboard Intel S1200 
> http://ark.intel.com/products/67494/Intel-Server-Board-S1200BTLR
>
> What I'm hoping to achieve is to purchase two new (identical) servers, 
> using current recommended (and well supported for the new few years) 
> parts, and then move the two existing servers to a remote site, 
> combining with DRBD proxy to give a full, "live" off-site backup 
> solution. (Note, by backup I mean Disaster Recovery, not backup).
>
> I would also like to be able to grow the total size of the data 
> further if needed, currently I have 7 x 480G in RAID5, which is likely 
> somewhat sub-optimal. Options include moving to larger size SSD, or at 
> perhaps splitting into 2 x RAID5 arrays. 

Yes, RAIDx for x=5,6 are generally suboptimal for SSDs due to write 
amplification from the RMW cycle.  RAID10's are generally much gentler 
on SSDs from a longevity scenario.

> The advantage of larger SSD's would be a smaller "system", with lower 
> complexity, while using more smaller drives would provide 
> (potentially) better performance, since each drive (regardless of 
> size) has the same overall performance (both throughput and IOPS).

Are you performance limited now, or will you be shortly?  If so the 
performance arguments make sense.

>
> I would appreciate any advise or suggestions you can make to help me 
> avoid the many mistakes I made last time.

I'm biased given what we do.  If you are going to build it yourself, I'd 
recommend sticking to known working elements that aren't a pain to setup 
and manage.  Focus on RAID10 for the primary storage, move the OS to a 
completely different controller.  Build the OS drives as MD RAID1.

You might want to investigate dm multipath as well as DRBD/md, and Ceph 
RBD.  I'm a huge fan and user of MD RAID, but you are asking much higher 
level architectural questions, and MD RAID would be one of several 
technologies you would use for this.

>
> Regards,
> Adam
>

--
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
e: landman@scalableinformatics.com
w: http://scalableinformatics.com
t: @scalableinfo
p: +1 734 786 8423 x121
c: +1 734 612 4615

