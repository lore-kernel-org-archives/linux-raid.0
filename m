From: Neil Brown <neilb@suse.de>
Subject: Re: Trouble increasing md component size
Date: Thu, 19 Jun 2008 13:42:01 +1000
Message-ID: <18521.54665.166875.489547@notabene.brown>
References: <20080618182622.GA29468@arachsys.com>
	<4859605D.90509@rabbit.us>
	<20080618200036.GB30682@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Webb on Wednesday June 18
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 18, chris@arachsys.com wrote:
> Peter Rabbitson <rabbit+list@rabbit.us> writes:
> 
> > I had exactly the same problem some months ago. The key is in the
> > (obscure) assembly option --update=devicesize. Find it in the mdadm
> > manpage and the whole picture will come together instantly. The wisdom is
> > not very widespread as this affects only V1.1 and 1.2 superblocks.
> 
> Thanks, that's great. I've been using a man page slightly older (2.5.6) than
> the mdadm binary I'm using (2.6.7), which doesn't mention update=devicesize,
> although I'd probably have missed it anyway!
> 
> However, is there a way to do this without stopping the array first? I'm
> using it as an LVM PV and slicing it up into logical volumes which clients
> will be running off while I'm wanting to grow it.

Not currently, no.

It would require changing the 'size' as known by md of each device
first.  i.e. /sys/block/mdX/md/dev-*/size.
However this currently cannot be changed while the array is active.

I cannot immediately see a good reason why not.  It may be as simple
as removing

	if (my_mddev->pers)
		return -EBUSY;

from the start of rdev_size_store, but I wouldn't recommend
experimenting with that on a production system....

Then you would need some code to update the device sizes to match
their real size (but only if the metadata is at the start of the
device .. or maybe relocating the metadata first ...)

Then you could "--grow --size=max" happily.

I'd put this on my todo list if it wasn't so long already :-)
(Well, I've put it there anyway, but no promises).

NeilBrown

