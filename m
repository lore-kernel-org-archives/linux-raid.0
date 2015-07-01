From: NeilBrown <neilb@suse.com>
Subject: Re: I/O error reading from raid 1 device but not slave devices
Date: Wed, 1 Jul 2015 10:53:42 +1000
Message-ID: <20150701105342.4761c795@noble>
References: <CAG2YfWMfwtNkLGoswsZVSxpTm+BxdQD8e1ZB+Mc2+PxWrWSAYw@mail.gmail.com>
	<CAG2YfWOn5_9KAK+qFY3XBBrh2L2HuxDCoc_6kzEEV8diyeG3Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG2YfWOn5_9KAK+qFY3XBBrh2L2HuxDCoc_6kzEEV8diyeG3Wg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Clark <nate@neworld.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 Jun 2015 10:46:38 -0400 Nate Clark <nate@neworld.us> wrote:

> On Mon, Jun 29, 2015 at 5:35 PM, Nate Clark <nate@neworld.us> wrote:
> > Hello,
> >
> > I have encountered a strange error while reading from a raid 1 device.
> > If I read from the md device I encounter an I/O error, however if I
> > read from the underlying devices there is no issue.
> 
> It appears both drives in the array have identical bad blocks list. I
> am not sure why any blocks were marked bad since I don't see any drive
> I/O errors in the logs and the smart output from each drive shows they
> are healthy.

That was my guess, but you confirmed before I got around to posting :-)

One way you could get bad blocks on perfectly healthy drives is if you
previously had an unhealthy drive.
Imagine a degraded RAID1 with a drive that has a couple of bad blocks.
You add a spare, it recovers but as it cannot read the bad blocks, it
adds them to the badblock list on the new device.
Then you remove the sick device, add a brand new one, and rebuild it -
from the first spare you added.
It will get the bad blocks "copied" onto it as well.

The blocks will stay 'bad' until something is written to them.  Then
they will become good.

NeilBrown
