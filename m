From: Chris Webb <chris@arachsys.com>
Subject: Re: Trouble increasing md component size
Date: Wed, 18 Jun 2008 21:00:36 +0100
Message-ID: <20080618200036.GB30682@arachsys.com>
References: <20080618182622.GA29468@arachsys.com> <4859605D.90509@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4859605D.90509@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson <rabbit+list@rabbit.us> writes:

> I had exactly the same problem some months ago. The key is in the
> (obscure) assembly option --update=devicesize. Find it in the mdadm
> manpage and the whole picture will come together instantly. The wisdom is
> not very widespread as this affects only V1.1 and 1.2 superblocks.

Thanks, that's great. I've been using a man page slightly older (2.5.6) than
the mdadm binary I'm using (2.6.7), which doesn't mention update=devicesize,
although I'd probably have missed it anyway!

However, is there a way to do this without stopping the array first? I'm
using it as an LVM PV and slicing it up into logical volumes which clients
will be running off while I'm wanting to grow it.

Cheers,

Chris.
