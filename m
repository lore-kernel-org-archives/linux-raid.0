From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Sun, 1 Sep 2002 21:13:18 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209012110490.1516-100000@home.transmeta.com>
References: <15730.42533.481161.627180@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15730.42533.481161.627180@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mon, 2 Sep 2002, Neil Brown wrote:
> 
> I'm actually a little disappointed by this change.  I was hoping that
> the ->queue might get changed to be passed a 'struct block_device *'
> instead of a 'kdev_t' so that the device driver would only have to
> interpret the device number in one place: the open.  But now that
> ->queue is called before ->open, that wouldn't help.

We may still do this. 

Right now the _only_ reason to call ->queue before open() is that open() 
is also doing things like disk change checking, which reasonably needs the 
queue because it can need to do IO in order to check the disk change 
status. The floppy in fact did exactly this.

HOWEVER, that disk change checking really should be done by the generic
layers, and it should be done after the open() anyway (and not by the
open), and I think Al is actually working on this. That will allow us to 
be a bit more flexible about the ordering.

		Linus

