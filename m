From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Mon, 2 Sep 2002 13:50:29 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209021347270.1385-100000@home.transmeta.com>
References: <20020902203525.GB9328@win.tue.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020902203525.GB9328@win.tue.nl>
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Andries.Brouwer@cwi.nl, neilb@cse.unsw.edu.au, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mon, 2 Sep 2002, Andries Brouwer wrote:
> 
> Now it seems Al is doing all the work, so I can just sit back and watch.
> But I hope he makes precisely this: a kernel that does not do any
> partition reading of its own.

I disagree, if only because of backwards competibility issues.

On a conceptual level I think you're right. However, it will break too 
many standard installations as is.

If/when we have a reasonable initrd setup that is usable, we could do some 
automatic partitioning of devices that are available at bootup to minimize 
the impact, but I don't think it is realistic otherwise.

		Linus

