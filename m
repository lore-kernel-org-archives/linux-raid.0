From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Proposal: non-striping RAID4
Date: Fri, 23 May 2008 10:12:38 -0500
Message-ID: <4836DEE6.4030300@gmail.com>
References: <BAY130-W418FFF9E3F58536967DDEAE1C60@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY130-W418FFF9E3F58536967DDEAE1C60@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Tony Germano <tony_germano@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tony Germano wrote:
> I would like to bring this back to the attention of the group (from November 2007) since the conversation died off and it looks like a few key features important to me were left out of the discussion... *grin*
> 
> The original post was regarding "unRAID" developed by http://lime-technology.com/
> 
> I had an idea in my head, and "unRAID" has features almost identical to what I was thinking about with the exception of a couple deal breaking design decisions. These are due to the proprietary front end, not the modified driver.
> 
> Bad decision #1) Implementation is for a NAS Appliance. Files are only accessible through a Samba share. (Though this is great for the hoards of people that use it as network storage for their windows media center pcs.)
> 
> Bad decision #2) Imposed ReiserFS.
> 
> Oh yeah, and it's not free in either sense of the word.
> 
> The most relevant uses I can think of for this type of array are archive storage and low use media servers. Keeping that in mind...
> 
> Good Thing #1)
> "JBOD with parity." Each usable disk is seen separately and has its own filesystem. This allows mixed sized disks and replacing older smaller drives with newer larger ones one at a time while utilizing the extra capacity right away (after expanding the filesystem.) In the event that two or more disks are lost, surviving non-parity disks still have 100% of their data. (Adding a new disk larger than the parity disk is possible, but takes multiple steps of converting it to the new parity disk and then adding the old parity disk back to the array as a regular disk... acceptable to me)
> 
> Good Thing #2)
> You can spin down idle disks. Since there is no data striping and file systems don't [have to] span drives, reading a file only requires 1 disk to be spinning. Writing only requires 1 disk + parity disk. This is an important feature to the "GREEN" community. On my mythtv server, I only record a few shows each week. I would have disks in this setup possibly not accessed for weeks or even months at a time. They don't need to be spinning, and performance is of no importance to me as long as it can keep up with writing HD streams.
> 
> Hopefully this brings a new perspective to the idea.
> 

I would think (for mythtv and similar uses) that they way to handle this would 
be to setup the raid array similar to enterprise class offline storage systems, 
you have a local disk cache of say 10-20GB, and when something is accessed you 
spinup the array and copy the entire file in, on writing, every hour or so (or 
any time you have to spin up the array) you copy all or part of the file off of 
the cache onto the array.   This would require either proper hooks in the kernel 
to deal with the offline storage concept or software at the application level to 
do it.

I know most of the offline storage has all of the files showing on a filesytem 
with proper metadata, but the file data is actually elsewhere, and when an 
application access the files the offline system (behind the scenes) brings the 
file data back from the offline storage onto the cache.   With this on a myth 
system I would expect the array to at most be spun up < 1x per hour for under 10 
minutes (my array does 35MB/s write, 90MB/s read-1.5GB recording would take 45 
seconds to copy from cache to array, and a reading a recording would take <20 
seconds to copy from cache to array plus spinup time), so a most the array would 
be actually spun up for maybe 3-5 minutes per hour under heavy usage, and 
probably not spun up at all in when things were not used.    My array uses about 
40W for the 4 disks, so being spun down 23 hours a day would save about 1KWhr 
per day, At the low power rate I pay (0.07/kwh) that comes to about $25 per year 
in power, in some more expensive states it would be 2-3 times that, and probably 
higher in Europe.

The big question is would the disks survive being spun down that often?

                             Roger
