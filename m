From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Software RAID-0 striping over Hardware RAID-5
Date: Mon, 20 Sep 2004 13:13:54 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409201713.i8KHDxj01473@www.watkins-home.com>
References: <1cd.2b876cdc.2e803a4d@aol.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1cd.2b876cdc.2e803a4d@aol.com>
To: AndyLiebman@aol.com, jlb17@duke.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Even in degraded mode or re-building, my array is faster much faster than my
network.  I have 100BaseTX Full duplex, so I can read and write a total of
20Meg per second.  My array is faster than that!

If your RAID5 arrays were software, the md driver will slow the re-build
when other disk access is needed.  These 2 files help control the speed:
/proc/sys/dev/raid/speed_limit_max
/proc/sys/dev/raid/speed_limit_min

Since your RAID5 arrays are hardware, you may have a re-build priority that
can be adjusted.  In your case you would want low priority.  I prefer to be
safe, I always give the array re-build the highest priority.

I would go with the hot spare.  Once the first disk fails, you are at risk
of losing everything if a second disk fails.  Even during the re-build, if a
second disk fails, game over man, game over!  But once the re-build is
finished, you are safe again.  Safe for another single disk failure that is.
But, if you have a daily backup, and you are willing to risk losing 1 days
work, that is your choice!

From what I have read, RAID0 will just go as fast as your slowest disk.
Your RAID5 re-building will not hurt the RAID0 array.  It will just slow it
down.

Guy

Sure you saved money, but at what cost? - "Guy Watkins"

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of AndyLiebman@aol.com
Sent: Monday, September 20, 2004 9:51 AM
To: jlb17@duke.edu
Cc: linux-raid@vger.kernel.org
Subject: Re: Software RAID-0 striping over Hardware RAID-5

jlb17@duke.edu writes:

> I have a couple of dual 3ware boxes I do this with, and have never had a 
> problem.  I would make sure that you have a hot spare on your RAID5 
> arrays, though.  Because if one of them dies, you'll obviously lose 
> everything on both arrays.

Thanks for the reply, Joshua. 

Have you ever tested your systems while one of your RAID5 arrays is 
rebuilding or verifying? (I'm about to do that right now). I'm wondering if
Linux 
Software RAID-0 might falter if one of the two arrays is significantly
slower than 
the other (while rebuilding)?

To test the integrity of the system, I'm going to remove a drive from one of

the RAID5 arrays, add it back and rebuild the array, and while the
rebuilding 
is taking place I'm going to run Bonnie++ several times (100GB of 
writing/reading per test). 

My inclination is to not use a hot spare. Instead, I rely on 3ware's email 
notification feature to alert me that a drive needs to be replaced. I always

keep a spare handy that can be popped into place immediately. Also, I want
to 
have control over when rebuilding takes place. It would be a bad thing to
rebuild 
during certain critical high I/O moments of the day -- whereas rebuilding at

night would be much less stressful on the system. Do you see anything wrong 
with this approach? 

Thanks again, 
Andy
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

