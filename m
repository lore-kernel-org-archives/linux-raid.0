From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: AW: Raid 1 vs 5 ?
Date: Thu, 10 Jun 2004 08:55:44 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16583.38256.230645.571852@cse.unsw.edu.au>
References: <27453.194.60.85.4.1086793052.squirrel@194.60.85.4>
	<200406091559.i59FxC317954@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Wednesday June 9
To: Guy <bugzilla@watkins-home.com>
Cc: 'Robin Bowes' <robin-lists@robinbowes.com>, 'Mauricio' <raub@afn.org>, 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday June 9, bugzilla@watkins-home.com wrote:
> You said:
> "Now consider RAID5. Here, with a hardware controller all of the data is
> written to the RAID card which in turn calculates parity and stripes the
> data over the disks. With software RAID, the software calculates parity and
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
> let's assume 64K.  Your stripe size will be 5*64K or 320K.  Now if you were
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
> As you can see, your 1 byte require reading 128K from 2 different disks, and
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
