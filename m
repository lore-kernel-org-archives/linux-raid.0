From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: The chunk size paradox
Date: Mon, 30 Dec 2013 23:38:12 +0000
Message-ID: <21186.996.238486.690328@tree.ty.sabi.co.uk>
References: <52C1C01A.7010407@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C1C01A.7010407@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> I believe that using a single "chunk size" causes a lose-lose
> tradeoff when creating raid 5/6/10 arrays. Too small of a
> chunk size and you waste too much time seeking to skip over
> the redundant data ( I think this is why the default was
> changed from 64k to 512k ), but too large of a chunk size, and
> you lose parallelism since your requests won't be large enough
> to span a whole stripe,

That seems to me a very peculiar way of looking at it. I used to
think that the biggest tradeoff as to chunk size is due to the
devices in a RAID set being as a rule not synchronized, so it
may happen that if they are disk drives their angular positions
might be up to nearly a full rotation apart across the the RAID
set members.

This can result in some significant wait to collect data that
spans multiple chunks from all the devices involved, and the
more drives there are the greater the chances that at least one
disk will have an angular position nearly a full rotation apart
from another disk drive...

  http://www.sabi.co.uk/blog/12-thr.html#120310
  http://www.sabi.co.uk/blog/12-two.html#120221

Therefore a larger chunk size increases the amount of data that
can be fetched on each device without waiting for the other
device to get to the desires angular position. It has of course
the advnatage that you mention, but also the advantage that
random IO might be improved.

> and in the case of raid5 you run into problems with the stripe
> cache.

IIRC the stripe cache can be up to 32MB for RAID device, and
that's a lot of stripes for any sensible-sized RAID set. But it
never stopped people who "know better" to do very wide RAID5 or
RAID6 sets :-).

[ ... ]
