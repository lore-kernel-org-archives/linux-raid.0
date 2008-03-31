From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Mon, 31 Mar 2008 20:54:24 +0100
Message-ID: <18417.16752.269484.583258@tree.ty.sabi.co.uk>
References: <47F020C6.1060809@tigertech.com>
	<47F0281F.1070404@harddata.com>
	<47F11F12.7010309@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47F11F12.7010309@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Mon, 31 Mar 2008 10:27:46 -0700, Robert L Mathews
>>> <lists@tigertech.com> said:

[ ... ]

> I do see that both disks are under "ide:1". Is that what you
> mean?

Indeed the symptoms reported are likely to be from drives on the
same channel.

>> This is not something from mdadm, anyway.  Once the disk "dies"
>> you are losing the disk bus, and that is "all she wrote".

That happens when the disk dies badly, but it is common enough.

> So mdadm can't protect against disk failures on these machines?

You can expect the Linux IO and RAID subsystems to only handle
reported, clean errors, after which the state of the whole machine
is well defined and known.

If you have high availability requirements perhaps you should buy
from an established storage vendor a storage system designed by
integration engineers and guaranteed by the vendor for some high
availability level.

> Whenever a disk returns a write error, the machine will lock
> up?

Perhaps without realizing it you have engaged in storage system
design and integration and there are many, many, many, many subtle
pitfalls in that (as the archives of this list show abundantly).

You cannot just slap things together and it all works. Have you
done even sketchy common mode failure analysis?

Also putting two drives belonging to a RAID set on the same
IDE/ATA channel is usually a bad idea for performance too.

