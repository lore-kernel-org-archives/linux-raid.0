From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Missing capacity in a RAID 5 array?
Date: Thu, 6 May 2004 08:47:28 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0405060846050.6890-100000@uplift.swm.pp.se>
References: <4099D554.808@jmorrow.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4099D554.808@jmorrow.org>
To: Jeff Morrow <jmorrow@jmorrow.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 5 May 2004, Jeff Morrow wrote:

> I've created a software RAID 5 array consisting of 8 160 GB drives.  One 
> of the drives had prior data I wanted to keep, so I first created a 
> 7-drive array, copied the data from the original drive to the array, 
> then added the 8th drive using raidreconf.  Worked like a charm (took 
> about 27 hours, though!)
> 
> The OS now reports that the total capacity on /dev/md0 is about 920 GB:
> 
> /dev/md0             923029884 172872252 750157632  19% /mnt/store

Did you grow the filesystem after you grew the raid device? If you used 
ext2s you should look at resize2fs.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

