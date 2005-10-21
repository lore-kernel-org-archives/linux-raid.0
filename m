From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Fri, 21 Oct 2005 14:42:12 +1000
Message-ID: <435871A4.8040304@nighthawkrad.net>
References: <dhje16$tmq$1@sea.gmane.org> <433F63BB.3020008@nighthawkrad.net> <7f55de720510030933k26608cfsda63326a8438e35d@mail.gmail.com> <43420091.9060601@nighthawkrad.net> <43577022.5010306@robinbowes.com> <20051020111943.GA9757@anthropohedron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051020111943.GA9757@anthropohedron.net>
Sender: linux-raid-owner@vger.kernel.org
To: gsslist+linuxraid@anthropohedron.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gregory Seidman wrote:
> You should at least read the following before using RAID5. You can agree or
> disagree, but you should take the arguments into account:
> 
> http://www.miracleas.com/BAARF/RAID5_versus_RAID10.txt

This bloke makes some good points about the various downsides of RAID5 
(which everyone involved in actually implementing production RAID 
systems should already know), but IMHO he also makes some poor 
assumptions and specious claims.

For example, his article suggests that "partial media failure" is a 
problem that would only affect RAID5, when really it would negatively 
impact any RAID system (your newly-synced mirror isn't much good if half 
the data that just got mirrored to it was corrupted, nor is the speed 
boost from RAID0 very helpful if half the data is corrupted).  I'm also 
not sure about his claims of RAID3 & 4 "always" checking parity - that 
sounds like a vendor-specific implementation (and while I'm not a 
developer, I fail to see why a RAID5 implementation couldn't be made to 
do the same).

As another example, I'm 99% sure that SCSI drives *do* inform the OS 
when they remap a bad sector and that any remotely modern IDE drive also 
does sector remapping.

He also focuses solely on the worst-case scenario as a reason for 
avoiding RAID5 completely.  Certainly you have to take that into 
account, but it's rather unfair to draw a general conclusion based only 
on how a particular scenario might happen.

Added to that, he completely discounts a few things:
1.  Where it's "handy" to keep lots of data easily available, but its 
entire loss is not catastrophic - ie: data volume is more important than 
redundancy (my workplace has such a requirement, although we use RAID6 - 
but RAID6 suffers most of the same "problems" he's talking about)
2.  Where cost is a significant factor.  Certainly for a business, the 
cost of going RAID10 over RAID5, when taking into account possible 
losses, is probably not large.  However, in a "home user" scenario, 
where cost is almost always the deciding factor and performance is not 
particularly important, going RAID10 over RAID5 is difficult to justify. 
  Similarly, if large amounts of data (10s of terabytes) is being 
stored, the additional cost of RAID10 can become substantial.
3.  You could potentially need a _lot_ more physical space to get the 
same amount of logical storage in a RAID10 vs a RAID5, with associated 
powering, cooling and logistical issues.

In short, RAID5 has its place.  It's certainly not the 
only-an-idiot-would-use-it train wreck that page makes it out to be.

CS
