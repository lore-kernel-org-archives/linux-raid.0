From: "David Lethe" <david@santools.com>
Subject: RE: Sleeping hard drives in an array?
Date: Sat, 3 May 2008 10:29:40 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C3359B7@34093-C3-EVS3.exchange.rackspace.com>
References: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com> <481B836E.6040208@tmr.com> <481B918E.4@panix.com> <A20315AE59B5C34585629E258D76A97C335968@34093-C3-EVS3.exchange.rackspace.com> <481C200E.60907@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <481C200E.60907@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: berk walker <berk@panix.com>, Bill Davidsen <davidsen@tmr.com>, Greg Cormier <gcormier@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good point, but the OP wanted to be able to put his md array to sleep,
and the next poster just said to use USB for everything .. then what you
suggest won't work for him.

Once you put /var, /dev, (/tmp perhaps?), back onto his md array, then
there is no way he will be able to accomplish his goal of spinning down
those disk drives.

This is what the OP should do.  Buy one of those industrial solid-state
flash modules designed to plug into the IDE connector on the
motherboard.  They appear as a standard ATA disk drive, and are designed
for exactly this job. They are solid-state, so you don't need to worry
about bad blocks, meaning no need for md.  (But like anything, chips can
fail, so there is still that single point of failure). 

All of the SAN/NAS appliance vendors who took my advice and incorporated
this strategy are quite happy and this added a great deal of
flexibility, as it means that they didn't have to carve out a slice of
remaining disks for an O/S image.   

Then just tweak a few things to take advantage of soft links & the
ramdisk filesystem for temporary files & scratch space, and such, and
you get some real performance boosts.  It really is an elegant solution
that many people should consider as general practice.  For less than the
price of a disk drive, put the O/S on SSD, then use md exclusively for
applications. 
- David @ SANtools ^ com


-----Original Message-----
From: Michael Tokarev [mailto:mjt@tls.msk.ru] 
Sent: Saturday, May 03, 2008 3:19 AM
To: David Lethe
Cc: berk walker; Bill Davidsen; Greg Cormier; linux-raid@vger.kernel.org
Subject: Re: Sleeping hard drives in an array?

David Lethe wrote:
[]
> USB for root??
> Bad bad bad bad idea .. unless you get the industrial flash memory.
The
> typical max number of writes for consumer-grade USB flashdrives is
> around 25,000 ... but the low end of the range is 10,000 writes.  

Why do you think root filesystem will be written that often?
Here, / is mounted read-only..  And it changes only when you
change some configs...

So, root (and /usr) are ok for flash.  Just don't put /dev on it
(udev/whatever works), and don't put volatile filesystems like
/var there too.

/mjt


