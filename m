From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID5 Performance
Date: Thu, 28 Jul 2016 14:28:23 +0100
Message-ID: <22426.2167.369879.756599@tree.ty.sabi.co.uk>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
	<22424.50313.900162.715200@tree.ty.sabi.co.uk>
	<CAFx4rwSRYDACX631eLpX7Jr9jB2u4jbC7dr-0rdi9U1nV9og3Q@mail.gmail.com>
	<22425.63565.439521.592849@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22425.63565.439521.592849@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
> That largely explains why in the tests I have mentioned small
> sync write IOPS for many "consumerish" flash SSDs top at around
> 100, instead of the usual > 10,000 for small non-sync writes.
[ ... ]

To summarize the preceding long discussion:

* The stats reported show a low level of IOPS being carried out.

* The critical part of the workload seems to be synchronous
  small writes.

* Probably then the primary issue is the use of flash SSDs that
  have a limited number of IOPS for small synchronous writes.

* A secondary issue is that RAID5 results in RMW for small
  writes.

There are two possible options:

* Replace the flash SSDs with those that are known to deliver
  high (at least > 10,000 single threaded) small synchronous
  write IOPS.

* Relax the requirement for synchronous writes on *both* the
  primary and secondary DRBD servers, if feeling lucky.

The third option, which is to change the workload so that it
does not emit small synchronous writes to the storage layer,
seems not practical in the context.

Ideally the system would also be switched from RAID5 to RAID10
to avoid the large penalty on small writes at the RAID level
too.

That may be considered expensive, but as I wrote:

> [ ... ] it requires a storage layer that has to cover all
> possible IO workloads optimally, [ ... ]
