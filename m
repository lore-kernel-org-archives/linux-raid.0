From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID0 behaviour/performance on ATA drives
Date: Fri, 25 Mar 2005 21:03:56 +1100
Message-ID: <16963.57868.98689.304581@cse.unsw.edu.au>
References: <4242EAFB.9060008@nospam.com>
	<16963.37953.872779.652517@cse.unsw.edu.au>
	<20050325090454.GA8352@acer1200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from asho@chuany.net on Friday March 25
Sender: linux-raid-owner@vger.kernel.org
To: asho@chuany.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 25, asho@chuany.net wrote:
> > 
> > The raid0 driver is 'clever' at all.

Hmm.. that should have been "The raid0 drivers isn't 'clever' at all.
                                               ^^^^^

> > It is given requests by the filesystem or mm subsystem, maps them to
> > the correct device/sector, and sends them straight on to the
> > appropriate driver.  It never waits for requests, just maps and
> > forwards.
> > 
> > So if the  filesystem sends 128 4k read-ahead requests to the raid0
> > driver it will forward each one to the relevant device and, depending
> > on chunk size etc, you might get, say, 32 4K requests sent to each of
> > 4 drives.  The drives would (depending on the internals of the driver)
> > processes all these requests in parallel.
> > 
> > In your example, if the filesystem or mm subsystem submitted writes
> > for 4 consecutive chunks on a two-drive raid0 array without waiting
> > for earlier ones to complete before submitting later ones, then they
> > would all get to the device driver in a timely fashion, and the device
> > driver(s) should be able to drive the two drives in parallel.
> > 
> > So if the writer handles the required parallelism, and the devices
> > handle the required parallelism, then the raid0 layer won't interfere
> > at all. 
> > NeilBrown
> Hi Neil
> 
> I am curious about that, too. In my memory, the IDE Channel can only
> allow one IDE device read/write at once. If one driver(e.g. master) 
> was writing, the second driver (e.g. slave) must wait until the master
> driver finished...
> 
> If you were right, can I plug the two disk into the same IDE channel in
> raid 1 without losing any performance?

Right about what?  I don't think that anything that I wrote can
reasonably be interpreted to say that you can just use one channel
without losing performance.

I said "If ... the devices handles the required parallelism".  I don't
know much in detail about IDE (I use SCSI mostly) but if it is true
that you cannot talk to a slave and a master at the same time, then
the drives DO NOT handle the required parallelism, so you don't get
any parallelism.  
It is basically completely out of md's hands.  It won't get in the way
of parallelism, but it won't make it magically happen if the
drives/controller/drivers cannot make it happen.

Is that any clearer?  Or did I misunderstand you.

NeilBrown
