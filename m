From: "Jansen, Frank" <fjansen@egenera.com>
Subject: RE: Two-disk RAID5?
Date: Wed, 26 Apr 2006 14:58:32 -0400
Message-ID: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Tuomas Leikola <tuomas.leikola@gmail.com>, Jon Lewis <jlewis@lewis.org>
Cc: John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tuomas,

It doesn't quite work that way.  IN RAID5 implementations the parity is
distributed across disks in a pattern such as this (3 disk case shown):

  Disk 1   Disk 2   Disk 3
  ------   ------   ------
   Data     Data    Parity
   Data    Parity    Data
  Parity    Data     Data

If you lose a disk (or start in degraded mode) you will get the
following pattern (disk 3 shown missing):

  Disk 1   Disk 2
  ------   ------
   Data     Data
   Data    Parity
  Parity    Data

If data needs to be read that was on disk 3, then the data and parity
from disk 1 and 2 are read and the data is reconstructed from that
information.  A similar strategy is used for writing.  As a result there
is a performance hit for reading/writing data that resides on disk 3.

Note that the loss of 1 more disk renders the RAID 5 set inoperable, as
it will no longer be possible to reconstruct data that was on either of
the missing disks.  Most raid controllers will give up and assume that
you rather treat this as a dead device than take into account the
possibility that you might want some of the data from the remaining
disks.  Thus the real risk of running in degraded mode is that all data
can be lost.

It is not possible to flip a bit to change a set of disks from RAID 1 to
RAID 5, as the physical layout is different.

Cheers,

Frank

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tuomas Leikola
Sent: Wednesday, April 26, 2006 2:46 PM
To: Jon Lewis
Cc: John Rowe; linux-raid@vger.kernel.org
Subject: Re: Two-disk RAID5?

> No.  When one of the 2 drives in your RAID5 dies, and all you have for
> some blocks is parity info, how will the missing data be
reconstructed?
>
> You could [I suspect] create a 2 disk RAID5 in degraded mode (3rd
member
> missing), but it'll obviously lack redundancy until you add a 3rd
disk,
> which won't add anything to your RAID5 storage capacity.

IMO if you have a 2-disk raid5, the parity for each block is the same
as the data. There is performance drop as I suspect md isn't smart
enough to read data from both disks, but that's all.

When one disk fails, the (lone) parity block is quite enough to
reconstruct. With XOR parity, you can always assume any amount of
additional disks full of zero, it doesn't really change the algorithm.

(maybe mdadm could/can change a raid-1 into raid5 by just changing the
superblocks, for the purpose of expanding into more disks..)

- tuomas
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
