From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: AW: Raid 1 vs 5 ?
Date: Wed, 9 Jun 2004 11:59:08 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406091559.i59FxC317954@watkins-home.com>
References: <27453.194.60.85.4.1086793052.squirrel@194.60.85.4>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27453.194.60.85.4.1086793052.squirrel@194.60.85.4>
To: 'Robin Bowes' <robin-lists@robinbowes.com>, 'Mauricio' <raub@afn.org>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You said:
"Now consider RAID5. Here, with a hardware controller all of the data is
written to the RAID card which in turn calculates parity and stripes the
data over the disks. With software RAID, the software calculates parity and
writes the data across all the mirrored drives. The only additional bus
traffic for software RAID is the parity data."

I believe this is wrong:
"The only additional bus traffic for software RAID is the parity data."

It is true if 100% of a stripe is being changed/written.  
If you update less than 100% of a stripe the software RAID must read the
full blocks being changed and the parity block.  Factor out the old data
from the parity then compute a new parity.  Then write the new blocks.

Example:
	Your array will have 6 disks.  You don't state your block size, so
let's assume 64K.  Your stripe size will be 5*64K or 320K.  Now if you were
to write 1 byte to your array this is what will happen:
Read the 64K block that contains the 1 byte.
Read the 64K parity block.
Factor out the 64K data block from the parity block.
Merge your 1 byte into the 64K data block.
Compute a new 64K parity block.
Write the new 64K block that contains your 1 byte.
Write the 64K parity block.

As you can see, your 1 byte require reading 128K from 2 different disks, and
then writing 128K to the same 2 disks.

Now if you were to write 2 bytes and were unlucky, both bytes would be on 2
different data blocks, this is what would happen:
Read the 64K block that contains your first byte.
Read the other 64K block that contains your second byte.
Read the 64K parity block.
Factor out the 2 64K data blocks from the parity block.
Merge your first byte into the first 64K data block.
Merge your second byte into the second 64K data block.
Compute a new 64K parity block.
Write the new 64K block that contains your first byte.
Write the new 64K block that contains your second byte.
Write the 64K parity block.

As you can see, your 2 bytes require reading 192K from 3 different disks,
and then writing 192K to the same 3 disks.

I don't know how md really does this.  I have not looked at the code.
Another choice would be to read 100% of the strip, apply your updates (1
byte in my example), then compute the parity, then write the changed blocks.
This would be simpler (I think) but on larger arrays (lots of disks) it
would cause much more disk IO.  In may first example it would read 320K and
write 128K.

About your swap plans...
If you were going to use 4 disks, create 2 RAID1 arrays, give both to swap.
Swap will strip to both arrays.  I believe this would give better
performance over creating a single RAID1/0 array.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robin Bowes
Sent: Wednesday, June 09, 2004 10:58 AM
To: Mauricio
Cc: LinuxRaid
Subject: Re: AW: Raid 1 vs 5 ?

On Wed, June 9, 2004 14:27, Mauricio said:
> At 07:10 +0200 5/7/04, Martin Bene wrote:
>>  > Which one is the better choice and what are the trade offs? Or is
>>>  another configuration more sensible? I'm under the impression that you
>>>  shouldn't (can't?) boot from RAID 5.
>>
>>Depends very much on what you're going to do with the system - I've
>>found a high performnce impact of raid5 for database applicaions with
>>frequent updates (where you end up with lots of small writes scattered
>
> 	I've always thought raid1 would be slower than, say, raid0+1
> or raid5.  I guess I am wrong then. =)

Mauricio,

I'm not expert but...

You've got to look at what data is actually being read/written/transferred
to get some
idea of performance. Bear in mind too that this can be different with
hardware vs.
software raid.

Take RAID1 as an example. With hardware RAID, the data is written to the
RAID card which
is responsible for writing a copy to each of the mirrored drives. With
Software RAID,
the software must write each copy of the data to each mirrored disk.
Assuming a
two-drive mirror then Software RAID will use twice as much bus bandwidth.

Now consider RAID5. Here, with a hardware controller all of the data is
written to the
RAID card which in turn calculates parity and stripes the data over the
disks. With
software RAID, the software calculates parity and writes the data across all
the
mirrored drives. The only additional bus traffic for software RAID is the
parity data.

Anyway, my point is that it is not always obvious which combination of RAID
levels /
hardware / software is fastest. As Martin said, it also depends on how the
system is
being used.

>>allover the partition). If write speed isn't too important, the space
>>savings may well make raid5 more attractive.
>
> 	What about raid0+1 vs raid5? What is the difference?  In my
> setup, I plan on using the raid just to store user data; the machine
> would boot (/, /usr, swap, /var) from an unraid disk.

I'm in the process of setting up something similar. In my case, I have 6 x
250GB SATA
drives which I will spread across two Promise controllers (3 per
controller). I want to
use (software) RAID5 to maximise disk capacity but it is not possible to
boot from
RAID5. My solution will be something like this:

(All disks partitioned the same)

Partition 1:   3GB
Partition 2:   247GB

I will create the following arrays:

Array 1:
/ (root file system)
3GB RAID1 array built from from D1, D4, with D2 as spare.

Array 2:
swap
3GB RAID1 array built from D3, D6 with D5 as spare

Array 3:
everything else
1235GB RAID5 array build from all six disks.

I plan to do an initial install onto Array 1, then use EVMS or LVM to create
logical
volumes on Array 3 onto which I will migrate stuff like /usr, /home, etc.

Partition 1 is sized at 3GB as I have 1.5GB of physical RAM and have
therefore sized
swap at 2x this figure.

There are a few possible variations on this...

One esoteric variation I may play around with (just because I can!) is to
create Array 1
from just two disks and create Array 2 as Raid0+1 from four parititions to
give better
performance for swap. I'm not sure if this is even possible.

I could also keep Partition 1 to 1GB and let linux strip the swap over three
disks
giving 3GB swap and a 1GB root partition. I'm not keen on this as the system
will hang
if one of the swap disks fails (or so I'm led to believe).

Anyway, hope that gives you some food for thought.

R.
-- 
http://robinbowes.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


