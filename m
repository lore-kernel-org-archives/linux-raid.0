From: Bernd Schubert <bs@q-leap.de>
Subject: Re: RAID 6 recovery (it's not looking good)
Date: Wed, 17 Dec 2008 00:59:57 +0100
Message-ID: <20081216235957.GA458@lanczos.q-leap.de>
References: <20081216191843.GA25097@lanczos.q-leap.de> <C56DC08C.B981%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C56DC08C.B981%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 16, 2008 at 08:31:08PM +0000, Iain Rauch wrote:
> > Hello Iain,
> > 
> > can you please describe what is the *present* status?
> > 
> >> /dev/md0 has been started with 22 drives (out of 24) and 1 spare
> > 
> > So in short, you had failure of 3 drives, reassembled it with 22 drives and
> > while you rebuild it again a drive failed?
> > 
> > If so, take this last failed drive, clone it to a new drive (e.g. dd_rescue)
> > and continue.
> > 
> > (Sorry, but this is by far too much output below for my tired eyes.
> > Sometimes a short description is more helpful).
> > 
> 
> I'll see if I can do that.
> 
> If I can't get anything useful off sdu (the latest to fail) can I change sdw
> from spare to active sync? sds is the spare drive it's trying to recover to
> and was the one that became out of sync as it ran in degraded mode.
> 
> I think sdw maybe sdw was only set to faulty because it was the last one to
> be recognised and the array got assembled without it. (The system won't boot
> with all the drives on together).
> 
> Here is what mdadm -E has to say about each disk:
> 
> http://iain.rauch.co.uk/stuff/skinner-2008-12-16/
> 

I'm still tired (now even more ;-) ). Just check again if /dev/sdu really 
was the latest to fail and if so, clone this one. 
I also suggest to reassemble it without an immediate raid-rebuild. 
First check your data and only then add a new drives to the raid.  
Once you start a raid-rebuild.
there is no way to go back. We recently also had the problem of three
failed disks  but we only could get back the data by not assembling the 
array with the latest failed disk, but with the 2nd latest (don't ask why).

So in short

1) clone disk

2) mdadm --assemble --force /dev/mdX /dev/sda1 /dev/sdb1 ... /dev/sdx1

===> Use only **22** devices here.

3) Mount and check data, maybe even a read-only fsck

4) Add two new disks.


Hope it helps,
Bernd


