From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID0 behaviour/performance on ATA drives
Date: Fri, 25 Mar 2005 15:32:01 +1100
Message-ID: <16963.37953.872779.652517@cse.unsw.edu.au>
References: <4242EAFB.9060008@nospam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Andy Sy on Friday March 25
Sender: linux-raid-owner@vger.kernel.org
To: andy@neotitans.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 25, andy@nospam.com wrote:
> The recommended setup for doing RAID0 with ATA drives is
> that each hard drive should be on its own IDE channel.  The
> reasoning is so they can operate concurrently... i.e.  if you
> put them in a master-slave configuration on the same channel,
> you lose the benefits of striping since both drives cannot
> use the channel at the same time and have to wait for the
> others' read/write to finish first.
> 
> QUESTION:  Is this really accurate?  Is the md driver smart/multi-threaded
> enough to read/write ahead non-consecutive sectors simultaneously?
> When writing, for example, the 1st to 4th chunks of a file across
> a striped two-drive array, would it write the 2nd and 4th
> chunks on one drive without waiting for the 1st and 3rd chunks
> to finish writing on the other?
> 
> If it can't, and the writes have to proceed in sequence/lockstep,
> how can putting the striped drives on separate channels help?

The raid0 driver is 'clever' at all.
It is given requests by the filesystem or mm subsystem, maps them to
the correct device/sector, and sends them straight on to the
appropriate driver.  It never waits for requests, just maps and
forwards.

So if the  filesystem sends 128 4k read-ahead requests to the raid0
driver it will forward each one to the relevant device and, depending
on chunk size etc, you might get, say, 32 4K requests sent to each of
4 drives.  The drives would (depending on the internals of the driver)
processes all these requests in parallel.

In your example, if the filesystem or mm subsystem submitted writes
for 4 consecutive chunks on a two-drive raid0 array without waiting
for earlier ones to complete before submitting later ones, then they
would all get to the device driver in a timely fashion, and the device
driver(s) should be able to drive the two drives in parallel.

So if the writer handles the required parallelism, and the devices
handle the required parallelism, then the raid0 layer won't interfere
at all. 

Hope that makes it clear.

NeilBrown
