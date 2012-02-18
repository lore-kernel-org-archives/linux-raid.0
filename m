From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Sat, 18 Feb 2012 17:39:31 +0000
Message-ID: <20287.57939.614122.5906@tree.ty.sabi.co.UK>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
	<4F35E925.6000003@hardwarefreak.com>
	<CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
	<4F38FD5D.1010201@hardwarefreak.com>
	<CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
	<20120213230228.GA5822@www5.open-std.org>
	<4F39D9B2.3050305@hardwarefreak.com>
	<20120214113832.GA6157@www5.open-std.org>
	<4F3AEDEF.2000608@hardwarefreak.com>
	<20286.40974.897300.844651@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20286.40974.897300.844651@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Fri, 17 Feb 2012 18:44:30 +0000, pg@lxra2.sabi.co.UK
>>> (Peter Grandi) said:

[ ... ]

> I have a few corrections and extensions for this message:
>   * With 'f2' the main price to pay is that *peak* writing speed

And the average. The peak writing speed is impaired by writing
two chunks to each drive, the average by the seeking.

Another way of looking at 'far' layouts is that given the same
number of disks as 'near', they have twice the width of the
stripe on reads, but the same width stripe on write plus seeking.

[ ... ]
>     - With 'f2' the first chunk gets written to the top of drive
>       1, and bottom of drive 2. Then the next chunk is written
>       to the top of drive 2, and the bottom of drive 3. Drive 2
>       writes must be serialized and arm must move half a disk.

Also note what happens on a whole-strip write, which for
RAID10,n2 on 6 disks would have been 3 chunks, the width of the
RAID0 layer.

With RAID10,f2 the _apparent_ width of the RAID0 layer is 6
chunks, but since we need to write each chunk twice, we end up
writing two chunks per drive, and with a half-disk seek between
them, which gives the same parallelism as RAID10,n2 plus the
cost of the seeks. So lower performance than RAID10,n2 writes,
and how much lower depending on the frequency of the seeks.

[ ... ]

>   mdadm -C /dev/r10f2 -n raid10 -n 4 \
>     /dev/sda1 /dev/sdb2 \
>     /dev/sdb1 /dev/sda2

Should be '-l raid10 -p n2'.

[ ... ]

>   mdadm -C /dev/r10f2 -l raid0 -n 3 /dev/mirr1 /dev/mirr2 /dev/mirr3

Should be '/dev/raid10f3'. The mostly equivalent RAID10,n3
layout:

   mdadm -C /dev/r10f3 -l raid10 -p n3 -n 6  \
     /dev/sda1 /dev/sdb2 /dev/sdc3 \
     /dev/sdb1 /dev/sda2 /dev/sda3 \
     /dev/sdc1 /dev/sda2 /dev/sdb3

(BTW I haven't tried any of these commands)
