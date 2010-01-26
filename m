From: Julian Cowley <julian@lava.net>
Subject: Re: Thrashing a drive to flush out problems..
Date: Tue, 26 Jan 2010 01:47:58 -1000
Message-ID: <797507EC-6521-41B5-B8DB-67A0F3E2E307@lava.net>
References: <77733.15823.qm@web51302.mail.re2.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <77733.15823.qm@web51302.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010 Jan 25, at 04:26, Jon Hardcastle wrote:
> Hi guys can anyone recommend a tool for thrashing the b*ll*cks of a  
> drive in  way that isn't destructive to the data?
>
> I was thinking badblocks with -w but it is destructive and i dont  
> want to do anything that will potentially lower the integrity of my  
> array? (Even tho it is raid6 :) )
>
> There must be some bonnie esk tool that will read/write every  
> combination to every block but keep the data safe after to flush out  
> any sector issues etc.

Here are a couple of utilities I've used in the past:

- seeker: How fast is your disk?

   <http://www.linuxinsight.com/how_fast_is_your_disk.html>

   "With a little bit of torturing, and some fun on the way, find out  
how fast your hard disk drive really is."

- thrash - hard disk stress tester with random seek speed statistics

   <http://www.csc.liv.ac.uk/~greg/thrash/>

   "thrash is intended to exercise a hard disk seek mechanism and  
perform a random seek speed benchmark. It is largely targeted at new  
harddisks that should be exercised to encourage early failure (i.e.  
assuming a bathtub curve for failures)."

Also, as mentioned in the first article, you can use hdparm to test  
sequential access.

I believe all of these utilities can be used read-only, but I can't  
remember for sure.

