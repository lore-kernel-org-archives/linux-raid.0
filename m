From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Fri, 28 Feb 2003 17:23:00 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302281623.h1SGN0u05056@oboe.it.uc3m.es>
References: <3E5F8AED.82D3B484@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E5F8AED.82D3B484@SteelEye.com> from Paul Clements at "Feb 28,
 2003 11:14:37 am"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Paul Clements wrote:"
> That sounds good. I'll have to merge up to 2.6...ugh...now I really need
> to put this all in CVS...I'm making some progress with the mmap stuff
> and I've got the code done for duplicating the buffers for the async
> writes to the backup devices.
> I'll need a pool of memory for that too, since I can't just fail in the
> middle of I/O...

Well, you can. Failing to complete will leave the map marked and
we could fault the device offline too. That will stop any more memory
being wasted because nothing will go to it! We could then make periodic
attempts to bring it online again using the "hotrepair" trick and it'll 
resync itself in the background.

Just an idea. Maybe not a good one, but an idea.

Peter
