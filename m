From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: raid0/jbod/lvm, sorta?
Date: Tue, 29 Dec 2009 18:43:39 -0600
Message-ID: <4B3AA23B.8060502@gmail.com>
References: <20091230000357.GA23485@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091230000357.GA23485@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matt Garman wrote:
> Is there a way, with Linux md (or maybe lvm) to create a single mass
> storage device from many physical drives, but with the property that
> if one drive fails, all data isn't lost, AND no redundancy?
> 
> I.e., similar to RAID-0, but if one drive dies, all data (but that
> on the failed drive) is still readily available?
> 
> Motivation:
> 
> I currently have a four-disc RAID5 device for media storage.  The
> typical usage pattern is few writes, many reads, lots of idle time.
> I got to thinking, with proper backups, RAID really only buys me
> availability or performance, neither of which are a priority.
> Modern single-disc speed is more than enough, and high-availability
> isn't a requirement for a home media server.
> 
> So I have four discs constantly running, using a fair amount of
> power.  And I need more space, so the power consumption only goes
> up.
> 
> I experimented a while with letting the drives spindown (hdparm -S),
> but (1) it was obnoxious waiting for all four discs to spinup when I
> wanted the data (they spunup in series---good for the power supply,
> bad for latency); and (2) I felt that having all four discs spinup
> was too much wear and tear on the drives, when, in principle, only
> one drive needed to spin up.
> 
> I got to thinking, I could just have a bunch of individual drives,
> let them all spindown, and when data is needed, only spinup the one
> drive that has the data I want.  Less wear and tear overall, lower
> overall power consumption, and lower access latency (compared to the
> whole RAID spinup).
> 
> I know I could do this manually with symlinks.  E.g., have a
> directory like /bigstore that contains symlinks into /mnt/drive1,
> /mnt/drive2, /mnt/drive3, etc.  And then if one drive dies, the
> whole store isn't trashed.  This seems fairly simple, so I wonder if
> there's not some automatic way to do it.  Hence, this email.  :)
> 
> Thanks for any thoughts or suggestions!
> Matt
>

I was thinking the best way would be to use the raid5 like you are, 
but have a "cache" drive/device, the cache device has all filesystem 
entries but only points over to the other data (HSM system), and then 
when you try to read one of the files it spins things up and copies 
that file onto cache (when done with the copy the raid array spins 
down).    Same thing would be done on recording ... it writes to the 
cache device and when either the cache is getting close to full moves 
off/syncs the new files onto the raid array, and/or moves all of the 
"new" files off every so often via a cron job.

Now, exactly how to write a kernel module or some other service to 
manage this I am not sure about, but it would in my case allow me to 
spin down a number of spindles for a large portion of the day...and 
those things run 5-10w/spindle, so alot of power.

If someone has ideas of where to start or some program/kernel modules 
to start with or knows of something that would already do this, it 
would seem useful.
