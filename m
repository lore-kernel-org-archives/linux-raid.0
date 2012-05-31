From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Thu, 31 May 2012 12:26:50 +0200
Message-ID: <4FC7476A.2020505@profitbricks.com>
References: <4FBA0047.5050208@profitbricks.com>	<20120522092817.1b5946b8@notabene.brown>	<4FBF7CAD.7000307@profitbricks.com>	<20120528140505.6eb49b26@notabene.brown>	<4FC49733.9050905@profitbricks.com>	<20120529202559.6aa7fd49@notabene.brown>	<4FC61A94.3050605@profitbricks.com> <20120531154256.6eb567c7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120531154256.6eb567c7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/05/12 07:42, NeilBrown wrote:
> Hmmm... that's bad.  Looks like I have a bug .... yes I do.  Patch below
> fixes it.  If you could test and confirm I would appreciated it.

I've tested the patch and I can confirm that it works as expected, now.
Thanks for fixing it that fast!
I've tested at least raid 01.
How could one test the raid10.c changes? Create raid 010 where raid0.c
is below rai10.c in the stack?

> As for the cached writes being always 4K - are you writing through a
> filesystem or directly to /dev/md300??

I've got a file copy test which creates a file with fio, random data and
direct IO on ext4. Afterwards I copy the file which isn't in the cache
and measure the time. So this reads first and then writes back. During
the copy I run blktrace in order to have a closer look at the request
sizes. The throughput is at a stable number after multiple cycles.

Cheers,
Sebastian
