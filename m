From: "Daniel Korstad" <dan@korstad.net>
Subject: RE:   RAID 6 grow problem
Date: Wed, 6 Jun 2007 10:06:56 -0500
Message-ID: <1501701006.1181142416422.JavaMail.root@gateway.korstad.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: jnelson-linux-raid@jamponi.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sometimes people confuse Bus speed with actually drive speeds.  Manufactures do it as a marketing ploy.  There is the physical limitation for the internal drive with a sustained read/write speed. Higher RPMs help.  Perpendicular technologies will too as more information passes the head in each revolution. 
 
Than you have the interface to internal drive IDE, EIDE, SATA, SATAII, SCSI, ... 
 
A drive with a sustained read speed at 70MB/s with a SATAII interface will perform the same with SATAI and IDE.  You will get a performance gain with SATAII on burst/buffer cached data access (for a short delta of time) but not sustain speed.  There is no bus bottleneck and the faster bus does not increase your sustained speed.  I had a PCI bus bottleneck because I have too many drive on that bus and too cheap to upgrade the system to PCI-express :)  Plus using it across the WiFi or LAN, I would not see much gain.  Only when doing task on the local box, I hit the bottle neck. 
 
Now RAID 5 and 6 sets with more drives will perform faster than ones with less drives (RAID 5 beats RAID 6 in writes, less parity to deal with).  But with all bus bottlenecks removed, I have not experienced a linear gain with the speed of one drive times the number of drives in the set equaling the total speed of the array.  The number is much less, there is some overhead.  And it has been my experience that as you add drives the gain is not linear but a curved graph with diminishing gains as you get to large number of drives in the set.
 
You say you have a RAID with three drive (I assume RAID5) with a read performance of 133MB/s.  There are lots of variables, file system type, cache tuning, but that sounds very reasonable to me.
 
Here is a site with some test for RAID5 and 8 drives in the set using high end hardware raid.
http://www.rhic.bnl.gov/hepix/talks/041019pm/schoen.pdf
8 drives RAID 5 7200 rpm SATA drives = ~180MB/s
8 drives RAID 5 10000 rpm SATA drives = ~310M/s
 
With the processors speeds and multiple cores, I don't think there is much difference in mdadm software raid and hardware raid.  In fact some would say software RAID is superior depending on how the hardware XOR engine in the card performs.  But that too is another topic/thread (I have to stop doing that...) 
 
Dan.




----- Inline Message Follows -----
To: Jon Nelson 
Cc: linux-raid@vger.kernel.org
From: Neil Brown
Subject: RE: RAID 6 grow problem


On Tuesday June 5, jnelson-linux-raid@jamponi.net wrote:
> 
> I have an EPoX 570SLI motherboard with 3 SATAII drives, all 320GiB: one 
> Hitachi, one Samsung, one Seagate. I built a RAID5 out of a partition 
> carved from each. I can issue a 'check' command and the rebuild speed 
> hovers around 70MB/s, sometimes up to 73MB/s, and dstat/iostat/whatever 
> confirms that each drive is sustaining approximately 70MB/s reads. 
> Therefore, 3x70MB/s = 210MB/s which is a bunch more than 133MB/s. lspci 
> -v reveals, for one of the interfaces (the others are pretty much the 
> same):

..
> 
> I'm trying to determine what the limiting factor of my raid is: Is it 
> the drives, ....

If look at the data sheets for the drives (I just had a look at a
Seagate one, fairly easy to find on their web site) you should fine
the Maximum Sustained Transfer Rate, which will be about 70MB/s for
current 7200rpm drives.

So I think the drive is the limiting factor.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
