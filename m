From: "John Stoffel" <john@stoffel.org>
Subject: Re: Upgrading storage server
Date: Mon, 9 Feb 2015 22:16:25 -0500
Message-ID: <21721.30729.509462.974269@quad.stoffel.home>
References: <54D8A9AD.3060700@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D8A9AD.3060700@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Adam> After making a whole string of mistakes in building a iSCSI
Adam> server about 2 years ago, I'm now looking to replace it without
Adam> all the wrong turns/mistakes. I was hoping you could all offer
Adam> some advice on hardware selection/choices.

I remember those discussions, they were quite informative and it was
interesting seeing Stan help you out.  Now that you've got this system
working well, or at least well enough, what is the biggest remaining
problem you have?

I've become a big fan of supermicro FatTwin systems, and they might be
what you want here for your setup.  But I'd also think about maybe you
want to go to fewer larger PCIe SSD cards in mirrored pairs instead
for better performance.  Or is performance a problem still?  

There's also *alot* to be said for simply replicating what you have,
but with larger SSDs, say 1Tb each, and keeping the rest of the system
and config exactly the same.  Limit the changes, esp since you went
through so much pain before.  

Now I might also think about upgrading all the clients to 10Gb as
well, and just moving to a completely 10G network if possible.  I seem
to remember that you didn't have any way to throttle or setup Quality
of Service limits on your iSCSI vs. other network traffic, which is
why you ended up splitting up the traffic like this, so that a single
VM couldn't bring the rest to their knees when a user did something
silly.  

So again, if it's working well now, don't chage your architecture at
all, just change some of the components for higher capacity or
performance.  This will also let you stress test the new cluster pair
next to your production setup before you migrate the VMs over to the
new setup and then move the old offsite.  

One warning is that you will need to make sure that the link between
the two sites has enough bandwidth and low enough RTT so that you can
properly replicate between them, esp if the end users will be
generating a bunch of data that changes alot.  


Adam> The target usage as above is an iSCSI server as the backend to a bunch 
Adam> of VM's. Currently I have two identical storage servers, using 7 x SSD 
Adam> with Linux MD Raid, then using LVM to divide it up for each VM, and then 
Adam> DRBD on top to sync the two servers together, on the top is ietd to 
Adam> share the multiple DRBD devices out. The two servers have a single 
Adam> 10Gbps connection between them for DRBD to sync the data. They also have 
Adam> a second 10Gbps ethernet for iscsi to use, with a pair of 1Gbps for 
Adam> management (on board). I have 8 x PC's running Xen with 2 x 1Gbps 
Adam> ethernet for iSCSI and one 1Gbps ethernet for the "user"/management LAN.

Adam> Current hardware of the storage servers are:
Adam> 7 x Intel 480GB SSD Model SSDSC2CW480A3
Adam> 1 x Intel 180GB SSD Model SSDSC2CT180A4  (for the OS)
Adam> 1 x LSI Logic SAS2308 PCI-Express (8 x SATA connections)
Adam> 1 x Intel Dual port 10Gbps 82599EB SFI/SFP+ Ethernet
Adam> 1 x Intel Xeon CPU E3-1230 V2 @ 3.30GHz
Adam> Motherboard Intel S1200 
Adam> http://ark.intel.com/products/67494/Intel-Server-Board-S1200BTLR

Adam> What I'm hoping to achieve is to purchase two new (identical) servers, 
Adam> using current recommended (and well supported for the new few years) 
Adam> parts, and then move the two existing servers to a remote site, 
Adam> combining with DRBD proxy to give a full, "live" off-site backup 
Adam> solution. (Note, by backup I mean Disaster Recovery, not backup).

Adam> I would also like to be able to grow the total size of the data further 
Adam> if needed, currently I have 7 x 480G in RAID5, which is likely somewhat 
Adam> sub-optimal. Options include moving to larger size SSD, or at perhaps 
Adam> splitting into 2 x RAID5 arrays. The advantage of larger SSD's would be 
Adam> a smaller "system", with lower complexity, while using more smaller 
Adam> drives would provide (potentially) better performance, since each drive 
Adam> (regardless of size) has the same overall performance (both throughput 
Adam> and IOPS).

Adam> I would appreciate any advise or suggestions you can make to help me 
Adam> avoid the many mistakes I made last time.

Adam> Regards,
Adam> Adam

Adam> -- 
Adam> Adam Goryachev
Adam> Website Managers
Adam> www.websitemanagers.com.au

Adam> --
Adam> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
Adam> the body of a message to majordomo@vger.kernel.org
Adam> More majordomo info at  http://vger.kernel.org/majordomo-info.html
