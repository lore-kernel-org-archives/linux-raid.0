From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: RAID-6
Date: Wed, 13 Nov 2002 10:07:45 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0211130942490.3877-100000@multivac.sdsc.edu>
References: <3DD28CE7.6090704@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3DD28CE7.6090704@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter,

> No, you're confusing RAID-3 and RAID-4/5.  In RAID-3, sequential blocks
> are organized as:
>
> 	DISKS ------------------------------------>
> 	 0	 1	 2	 3	PARITY
> 	 4	 5	 6	 7	PARITY
> 	 8	 9	10	11	PARITY
> 	12	13	14	15	PARITY
>
> ... whereas in RAID-4 with a chunk size of four blocks it's:
>
> 	DISKS ------------------------------------>
> 	 0	 4	 8	12	PARITY
> 	 1	 5	 9	13	PARITY
> 	 2	 6	10	14	PARITY
> 	 3	 7	11	15	PARITY

The description you have for RAID-3 is wrong.  What you give as RAID-3 is
actually RAID-4 with a 1 block segment size.

RAID-3 uses BITWISE (or BYTEWISE) striping with parity, as opposed to the
BLOCKWISE striping with parity in RAID-4/5.  In RAID-3, every I/O
transaction (regardless of size) accesses all drives in the array (a read
doesn't have to access the parity).  This gives high transfer rates, even
on single-block transactions.

 	DISKS ------------------------------------>
 	0.0	0.1	0.2	0.3	PARITY
 	1.0	1.1	1.2	1.3	PARITY
 	2.0	2.1	2.2	2.3	PARITY
 	3.0	3.1	3.2	3.3	PARITY

It is NOT possible to read just 0.0 from the array.  If you were to read
the raw physical device, the results would be meaningless.

The structure of the array limits the number of spindles to one more than
a power of two (3, 5, 9, 17, etc.).  I have seen this implemented with 5
and 9 drives (actually, the 9 was done with parallel heads).

				Peter Ashford

