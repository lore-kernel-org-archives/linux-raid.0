From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: AW: Raid 1 vs 5 ?
Date: Wed, 9 Jun 2004 19:39:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406092339.i59Ndg319693@watkins-home.com>
References: <16583.38256.230645.571852@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16583.38256.230645.571852@cse.unsw.edu.au>
To: 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry I was somewhat wrong.  Thanks for setting me straight!
md is "smarter" than I thought.  Cool.

But now I have a question.
If md does 4k I/Os is there a reason to create the array with larger blocks?

I have tried block sizes from 1k to maybe 256K and did not notice any real
difference.  My testing was very crude!  And I did not try every block size.
Not even sure I tried 4K.  64K seemed best on my system.

Thanks,
Guy

-----Original Message-----
From: Neil Brown [mailto:neilb@cse.unsw.edu.au] 
Sent: Wednesday, June 09, 2004 6:56 PM
To: Guy
Cc: 'Robin Bowes'; 'Mauricio'; 'LinuxRaid'
Subject: RE: AW: Raid 1 vs 5 ?

On Wednesday June 9, bugzilla@watkins-home.com wrote:
> You said:
> "Now consider RAID5. Here, with a hardware controller all of the data is
> written to the RAID card which in turn calculates parity and stripes the
> data over the disks. With software RAID, the software calculates parity
and
> writes the data across all the mirrored drives. The only additional bus
> traffic for software RAID is the parity data."
> 
> I believe this is wrong:
> "The only additional bus traffic for software RAID is the parity data."
> 
> It is true if 100% of a stripe is being changed/written.  
> If you update less than 100% of a stripe the software RAID must read the
> full blocks being changed and the parity block.  Factor out the old data
> from the parity then compute a new parity.  Then write the new blocks.
> 
> Example:
> 	Your array will have 6 disks.  You don't state your block size, so
> let's assume 64K.  Your stripe size will be 5*64K or 320K.  Now if you
were
> to write 1 byte to your array this is what will happen:
> Read the 64K block that contains the 1 byte.
> Read the 64K parity block.
> Factor out the 64K data block from the parity block.
> Merge your 1 byte into the 64K data block.
> Compute a new 64K parity block.
> Write the new 64K block that contains your 1 byte.
> Write the 64K parity block.

This is mostly correct, except that it won't be a 64k block.  It will
normally be a 4k block.  Your chunksize is irrelevant. 
In 2.6, md will do a PAGE_SIZE read/write, which is 4k on x86.
In 2.4, md will do read/writes that match the filesystem blocksize,
which is most often 4k these days.

> 
> As you can see, your 1 byte require reading 128K from 2 different disks,
and
> then writing 128K to the same 2 disks.

So that's 8k, twice.

> 
> I don't know how md really does this.  I have not looked at the code.
> Another choice would be to read 100% of the strip, apply your updates (1
> byte in my example), then compute the parity, then write the changed
> blocks.

md sometimes does a "read-modify-write" cycle like your first example,
and sometimes does a "reconstruct-write" cycle like your second
example.  It chooses the option that generates the fewest IO requests.

NeilBrown


