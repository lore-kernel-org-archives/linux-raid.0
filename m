From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Re: AW: Raid 1 vs 5 ?
Date: Wed, 9 Jun 2004 15:57:32 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <27453.194.60.85.4.1086793052.squirrel@194.60.85.4>
References: <FA095C015271B64E99B197937712FD0227A85D@freedom.grz.icomedias.com>
    <a06002007bcecbfe09c54@[10.0.0.10]>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a06002007bcecbfe09c54@[10.0.0.10]>
To: Mauricio <raub@afn.org>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

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

You've got to look at what data is actually being read/written/transferred to get some
idea of performance. Bear in mind too that this can be different with hardware vs.
software raid.

Take RAID1 as an example. With hardware RAID, the data is written to the RAID card which
is responsible for writing a copy to each of the mirrored drives. With Software RAID,
the software must write each copy of the data to each mirrored disk. Assuming a
two-drive mirror then Software RAID will use twice as much bus bandwidth.

Now consider RAID5. Here, with a hardware controller all of the data is written to the
RAID card which in turn calculates parity and stripes the data over the disks. With
software RAID, the software calculates parity and writes the data across all the
mirrored drives. The only additional bus traffic for software RAID is the parity data.

Anyway, my point is that it is not always obvious which combination of RAID levels /
hardware / software is fastest. As Martin said, it also depends on how the system is
being used.

>>allover the partition). If write speed isn't too important, the space
>>savings may well make raid5 more attractive.
>
> 	What about raid0+1 vs raid5? What is the difference?  In my
> setup, I plan on using the raid just to store user data; the machine
> would boot (/, /usr, swap, /var) from an unraid disk.

I'm in the process of setting up something similar. In my case, I have 6 x 250GB SATA
drives which I will spread across two Promise controllers (3 per controller). I want to
use (software) RAID5 to maximise disk capacity but it is not possible to boot from
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

I plan to do an initial install onto Array 1, then use EVMS or LVM to create logical
volumes on Array 3 onto which I will migrate stuff like /usr, /home, etc.

Partition 1 is sized at 3GB as I have 1.5GB of physical RAM and have therefore sized
swap at 2x this figure.

There are a few possible variations on this...

One esoteric variation I may play around with (just because I can!) is to create Array 1
from just two disks and create Array 2 as Raid0+1 from four parititions to give better
performance for swap. I'm not sure if this is even possible.

I could also keep Partition 1 to 1GB and let linux strip the swap over three disks
giving 3GB swap and a 1GB root partition. I'm not keen on this as the system will hang
if one of the swap disks fails (or so I'm led to believe).

Anyway, hope that gives you some food for thought.

R.
-- 
http://robinbowes.com

