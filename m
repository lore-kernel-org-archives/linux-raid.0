From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: Migrating from SINGLE DISK to RAID1
Date: Tue, 1 Feb 2005 15:52:33 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050201154531.3365A-100000@Maggie.Linux-Consulting.com>
References: <41FFD9C7.2090208@h3c.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <41FFD9C7.2090208@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 1 Feb 2005, Mike Hardy wrote:
 
> Robert Heinzmann wrote:
> > Hello,
> > 
> > can someone verify if the following statements are true ?
> > 
> > - It's not possible to simply  convert a existing partition with a 
> > filesystem on it to a raid1 mirror set.

i say you cannot have it 100% working as raid1 because:

fdisk partitions on the orig drive and new disk is NOT "FD" type,
which means you cannot boot from the mirror if the current one dies
and you'd have to go to standalone rescue mode and it might boot

and more importantly ( in my view ), it was not mke2fs'd so its not
treated as one /dev/md0 device ... (ie. it will probably show as
misleading grub/lilo problems that it wont boot )

but if it works (boots) .. good .. :-)

> I believe you're right, but I'm not totally sure on this one. I'd take 
> the second disk, create a new RAID1 with the first drive "missing" on 
> the mdadm --create commandline, copy everything over to it, put grub on 
> it, then test that it boots correctly by pulling the first drive out.

a good test :-) my favorite non-techie 1 minute test for those that
say they have raid config'd, test'd and working .. ( usually it doesn't
boot in degraded, simulated failed disk mode )
  
> Only once the RAID1 is working (in degraded mode) add the original first 
> drive back in, but booting off the RAID1, then add it to the RAID set to 
> complete the pair. With that process, the question is somewhat moot, 
> although I'm interested in the real answer too

ditto

i think it matters, to what level people expect raid1 to be working,
	- just copying data or being able to boot off either disk
	with the other one unplugged  and that data resync itself
	onto the new disk

c ya
alvin

