From: "David Lethe" <david@santools.com>
Subject: RE:  Re: Two Drive Failure on RAID-5
Date: Tue, 20 May 2008 12:18:44 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C71AC52@34093-C3-EVS3.exchange.rackspace.com>
References: <loom.20080519T224713-779@post.gmane.org> <48327FC2.1010901@dgreaves.com> A<loom.20080520T145950-804@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: A<loom.20080520T145950-804@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry <cry_regarder@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Cry
Sent: Tuesday, May 20, 2008 10:32 AM
To: linux-raid@vger.kernel.org
Subject: Re: Two Drive Failure on RAID-5

David Greaves <david <at> dgreaves.com> writes:

> 
> Yep. Don't panic and don't do anything else yet if you're not
confident about
> what you're doing.
> 
> I'll follow up with more info in a short while.
> 
> Info you can provide:
> kernel version
> mdadm version
> cat /proc/mdstat
> mdadm --examine /dev/sd[abcdef]1 (or whatever your array components
are)
> relevant smartctl info on the bad drive(s)
> dmesg info about the drive failures
> 
> Assuming genuine hardware failure:
> Do you have any spare drives that you can use to replace the
components?
> 
> David

Thanks for the info.  I was able to do a --force --assemble on the array
and I
copied off my most critical data.  At the moment, I don't have enough
drives to
take all the data on the array, so I'm going to be at a bit of a
standstill
until new hardware arrives.

Since the copy of that data (about 500Gig of about 2TB) went so well, I
decided
to try to sync up the spare again and it died at the same point and the
raid
system pulled down the array.  I'm trying to decide if I should follow
your
suggestion in sister post to copy the failed drive onto my spare or if I
should
just format the spare and try to recover another 500 gig of data of the
array.

Is there a mdadm or other command to tell the raid system to stay up in
the face
of errors?  Can the array be assembled in a way that doesn't change the
array in
any way (completely read-only)?

I've got the older failed drive also (about 15 hours older).  Can that
be
leveraged also?

The server isn't networked right now, but I'll try to get the above
requested
logs tonight.

By the way, I'm thinking about buying five of these:

Seagate Barracuda 7200.11 1TB ST31000340AS SATA-II 32MB Cache

and one of these:

Supermicro SUPERMICRO CSE-M35T-1 Hot-Swapable SATA HDD Enclosure

http://www.supermicro.com/products/accessories/mobilerack/CSE-M35T-1.cfm

and building a raid-6 array.  I'll convert the surviving drives into a
backup
for the primary array.  Any feedback on the above?  Is there a
suggestion on an
inexpensive controller to give more SATA ports that is very software
raid
compatible?

Any suggestions for optimal configuration (ext3) and tuning for the new
array? 
My load consists of serving a photo gallery via apache and gallery2 as
well as a
local media (audio/video) server so files sizes tend to be large.

Thanks,

Joel
===============
Joel:

Respectfully .. are you nuts??? 

Don't buy the 7200.11 disks.   You bought a bunch of desktop class
drives, and they crapped out on you, and you are about to make the same
mistake again.  Get the server class disk that is designed to run 24x7
duty cycle, which in your case would be the 'cuda ES.2

Sorry about the soapbox, but it never ceases to amaze me how people try
to save by buying disk drives architected with lowest possible cost in
mind, and don't investigate the higher-quality disks that are designed
for extended reliability and data integrity.

David






