From: AndyLiebman@aol.com
Subject: Re: Software RAID-0 striping over Hardware RAID-5
Date: Mon, 20 Sep 2004 09:51:09 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1cd.2b876cdc.2e803a4d@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: jlb17@duke.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

jlb17@duke.edu writes:

> I have a couple of dual 3ware boxes I do this with, and have never had a 
> problem.  I would make sure that you have a hot spare on your RAID5 
> arrays, though.  Because if one of them dies, you'll obviously lose 
> everything on both arrays.

Thanks for the reply, Joshua. 

Have you ever tested your systems while one of your RAID5 arrays is 
rebuilding or verifying? (I'm about to do that right now). I'm wondering if Linux 
Software RAID-0 might falter if one of the two arrays is significantly slower than 
the other (while rebuilding)?

To test the integrity of the system, I'm going to remove a drive from one of 
the RAID5 arrays, add it back and rebuild the array, and while the rebuilding 
is taking place I'm going to run Bonnie++ several times (100GB of 
writing/reading per test). 

My inclination is to not use a hot spare. Instead, I rely on 3ware's email 
notification feature to alert me that a drive needs to be replaced. I always 
keep a spare handy that can be popped into place immediately. Also, I want to 
have control over when rebuilding takes place. It would be a bad thing to rebuild 
during certain critical high I/O moments of the day -- whereas rebuilding at 
night would be much less stressful on the system. Do you see anything wrong 
with this approach? 

Thanks again, 
Andy
