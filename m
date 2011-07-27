From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Wed, 27 Jul 2011 14:30:30 +0200
Message-ID: <j0p0d6$aj6$1@dough.gmane.org>
References: <20110727141652.7511fc51@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110727141652.7511fc51@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/27/2011 06:16 AM, NeilBrown wrote:
> Then as errors occur they will cause the faulty block to be added to the log rather
> than the device to be remove from the array.

Can you describe the criteria for MD considering a block as faulty?

In your blog, I read
  "... known to be bad. i.e. either a read or a write has recently failed..."
but that definition may be problematic: I've experienced drives
with intermittent read / write failures (due to controller or power stability
problems), and I wonder whether such a situation could quickly fill up the
"bad block list", doing more harm than good in the "intermittent error"-
szenario.

Another szenario: The write succeeded, but a later reads of the same
block return read errors. This would result in a "pending sector", and the
harddisk may very well re-map the sector on the next write. Do you mark
the block faulty on the MD level after the first read failed (even though
subsequent reads/writes to the block would succeed), or do you first try
to re-write the block, and call it faulty only if that fails?

One more general thing: I guess that "marking bad blocks" is probably
unsuitable for SSDs, which usually do not assign fixed physical
storage location with a certain block number. Maybe mdadm could warn about better
not enabling the feature if the device is known to be a SSD.


Regards,

Lutz Vieweg


