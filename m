From: asho@chuany.net
Subject: Re: Software RAID0 behaviour/performance on ATA drives
Date: Fri, 25 Mar 2005 17:04:54 +0800
Message-ID: <20050325090454.GA8352@acer1200>
References: <4242EAFB.9060008@nospam.com> <16963.37953.872779.652517@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Disposition: inline
In-Reply-To: <16963.37953.872779.652517@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 
> The raid0 driver is 'clever' at all.
> It is given requests by the filesystem or mm subsystem, maps them to
> the correct device/sector, and sends them straight on to the
> appropriate driver.  It never waits for requests, just maps and
> forwards.
> 
> So if the  filesystem sends 128 4k read-ahead requests to the raid0
> driver it will forward each one to the relevant device and, depending
> on chunk size etc, you might get, say, 32 4K requests sent to each of
> 4 drives.  The drives would (depending on the internals of the driver)
> processes all these requests in parallel.
> 
> In your example, if the filesystem or mm subsystem submitted writes
> for 4 consecutive chunks on a two-drive raid0 array without waiting
> for earlier ones to complete before submitting later ones, then they
> would all get to the device driver in a timely fashion, and the device
> driver(s) should be able to drive the two drives in parallel.
> 
> So if the writer handles the required parallelism, and the devices
> handle the required parallelism, then the raid0 layer won't interfere
> at all. 
> NeilBrown
Hi Neil

I am curious about that, too. In my memory, the IDE Channel can only
allow one IDE device read/write at once. If one driver(e.g. master) 
was writing, the second driver (e.g. slave) must wait until the master
driver finished...

If you were right, can I plug the two disk into the same IDE channel in
raid 1 without losing any performance?

Asho Yeh
-- 
    ~    Asho Yeh <asho@debian.org.tw>
   'v'   GnuPG-Key ID: 1CC92D7F
  // \\  Fingerprint: 192B 76FD 5643 6EE7 3DEC  9EAF 3088 48D2 1CC9 2D7F
 /(   )\ 
  ^`~'^
