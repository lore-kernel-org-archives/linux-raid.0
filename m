From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Sun, 02 Oct 2005 14:36:11 +1000
Message-ID: <433F63BB.3020008@nighthawkrad.net>
References: <dhje16$tmq$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dhje16$tmq$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:
> Hi,
> 
> I have a business opportunity which would involve a large amount of 
> storage, possibly growing to 10TB in the first year, possibly more. This 
> would be to store media files - probably mainly .flac or .mp3 files.

Here's what I do (bear in mind this is for a home setup, so the data 
volumes aren't as large and I'd expand in smaller amounts to you - but 
the principle is the same).

I use a combination of Linux's software RAID + LVM for a flexible, 
expandable data store.  I buy disks in sets of four, with a four-port 
disk controller and a 4-drive, cooled chassis of some sort (lately, the 
Coolermaster 4-in-3 part).

I RAID5 the drives together and glue multiple sets of 4 drives together 
into a single usable chunk using LVM.

Over the last ~5 years, this has allowed me to move from/to the 
following disk configurations:

4x40GB -> 4x40GB + 4x120GB -> 4x40GB + 4x120GB + 4x250GB -> 4x120GB + 
4x250GB -> 4x250GB + 4x250GB.

In the next couple of months I plan to add another 4x300GB "drive set" 
to expand further.  I add drives about once a year.  I remove drives 
either because I run out of physical room in the machine, or to re-use 
them in other machines (eg: the 4x120GB drives are now scratch space on 
my workstation, the 4x40GB drives went into machines I built for 
relatives).  The case I have now is capable of holding about 20 drives, 
so I probably won't be removing any for a while (previous cases were 
stretched to hold 8 drives).

Apart from the actual hardware installations and removals, the various 
reconfigurations have been quite smoothe and painless, with LVM allowing 
easy migration of data to/from RAID devices, division of space, etc. 
I've had 3 disk failures, none of which have resulted in any data loss. 
  The "data store" has been moved across 3 very different physical 
machines and 3 different Linux installations (Redhat 9 -> RHEL3 -> FC4).

I would suggest not trying to resize existing arrays at all, and simply 
accept the "space wastage" as a cost of flexibility.  Storage is cheap, 
and a few dozens or hundreds of GB lost to long-term cost savings is 
well worth it IMHO.  The space I "lose" but not reconfiguring my RAID 
arrays whenever I add more disks is more than made up for by the money 
I've saving not buying everything at once, or the additional space 
available at the same price point.

I would, however, suggest getting a case with a large amount of physical 
space in it so you don't have to remove drives to add bigger ones.

But, basically, just buy as much space as you need now and then buy more 
as required - it's trivially easy to do, and you'll save money in the 
long run.

CS
