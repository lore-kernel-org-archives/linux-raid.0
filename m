From: David Brown <david.brown@hesbynett.no>
Subject: Re: Use RAID-6!
Date: Tue, 16 Apr 2013 22:01:18 +0200
Message-ID: <516DAE0E.5080209@hesbynett.no>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <alpine.DEB.2.00.1304161905150.23668@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1304161905150.23668@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/04/13 19:09, Mikael Abrahamsson wrote:
> On Tue, 16 Apr 2013, Roy Sigurd Karlsbakk wrote:
>
>> Also, maybe this should be on an FAQ/RAID tutorial somewhere?
>
> Question is, where should it be put so that people read it and actually
> understand it.
>
> This article is from 2007:
>
> <http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162>
>
> I've had people argue with me that the above article is wrong, but I
> never udnerstood their logic. To me it makes perfect sense and I always
> go RAID6.
>
> I also think the work having more than 2 parity drives was very
> promising. I'd rather have a 20 drive volume with 4 parity drives than
> to LVM together two 10 drive RAID6:es (apart from obvious performance
> penalties).
>

Raid calculations for a third parity are noticeably more time-consuming 
than for the second parity of Raid6.  And with a bigger array with lots 
of drives, you are going to have terrible RMW performance for small 
writes.  However, as the multi-threaded scaling of Raid5 and Raid6 
improves and makes its way into distro's standard kernels, it's going to 
be more realistic - especially for machines with plenty of cores and 
lots of RAM for stripe caches.

I hope triple parity raid will make it into the kernel at some point. 
I've done the main part of the maths involved, but not had the time to 
work it into anything resembling real code.  I don't know if I 
personally will ever make it into working code - but if anyone else is 
at all interested in doing so, then I will certainly help with the maths.

I am not sure there is much real-world need of triple parity raid for 
normal arrays - even with better cpu scaling, it would still be a lot 
slower than two raid6 arrays LVM'ed together.  I foresee it's main use 
as a temporary measure during array maintenance.  For example, if you 
have a raid6 and you want to swap out the drives for bigger ones, then 
you could temporarily add an extra drive for a third parity using a 
non-symmetrical layout.  Once this extra drive is synced, then you can 
step through the other drives doing a replace-and-resync, knowing that 
you still have the double parity safety.  Then at the end of the process 
you drop the third parity again.

Quad parity has some limitations, especially if you want to keep the 
first 3 parities compatible with triple parity.  In particular, you are 
limited to 21 data disks.  There are, of course, ways to handle even 
greater parity counts - but the cost in complexity and speed is 
considerable.


