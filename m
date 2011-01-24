From: David Brown <david.brown@hesbynett.no>
Subject: Re: Raid 5, 2 disk failed
Date: Tue, 25 Jan 2011 00:12:49 +0100
Message-ID: <ihl11h$psb$1@dough.gmane.org>
References: <AANLkTi=17u_e24gJMQFQJiCYCUok7-fETW=__HGhJFXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=17u_e24gJMQFQJiCYCUok7-fETW=__HGhJFXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/01/11 22:31, Daniel Landstedt wrote:
> Hi, for starters, great work with the linux raid guys.
>
> Now for the unpleasantness's
>
> Please..
> ...help
>
>
> I have a raid 5 with 4 disks and 1 spare.
> 2 disks failed at the same time.
>

I don't know if this will be any help - it certainly won't make you feel 
better...

Raid 5 protects against a single disk failure - if a second disk fails, 
you've lost your data.  If the disk(s) haven't really failed, but have 
only had temporary problems, then you might be able to put them together 
again, with a lot of work.  Standard disk recovery techniques should be 
used - boot from a live CD like system recovery cd, use dd_rescue to 
make the best possible raw copies of your original 4 disks (including 
the bad ones).  Then make copies of /those/ copies, so that if you mess 
up you can make new copies without having to re-read the dodgy disks. 
If the "failed" disks were actually mostly okay, you should be able to 
put the raid5 array together again and get most of the data out.


For future use, consider raid6 rather than raid5, or perhaps raid10 
(which is less efficient at disk space, but faster for some use and a 
lot faster at recovery).  There isn't any good reason for using raid5 
with a spare rather than raid6, unless you have an ancient processor.



