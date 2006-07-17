From: Neil Brown <neilb@suse.de>
Subject: Re: zeroing old superblocks & upgrading...
Date: Tue, 18 Jul 2006 09:57:18 +1000
Message-ID: <17596.9182.836056.396966@cse.unsw.edu.au>
References: <17581.36135.379062.709693@stoffel.org>
	<17581.38932.532010.388731@cse.unsw.edu.au>
	<17582.23882.797049.201350@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Stoffel on Friday July 7
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 7, john@stoffel.org wrote:
> 
> Neil> But if you wanted to (and were running a fairly recent kernel) you
> Neil> could
> Neil>   mdadm --grow --bitmap=internal /dev/md0
> 
> Did this.  And now I can do mdadm -X /dev/hde1 to examine the bitmap,
> but I think this totally blows.  To create a bitmap, I add it to an
> md# device, but to examine it, I have to know which sub-devices to
> query?  That's really not what I would expect.

Hmm... I can see that.
-X is a counterpart to -E
They are both letters from EXamine.  They both look at a component and
tell you want is there.
-D (--detail) reports on the array.  Maybe it should be give more
details about any bitmap....
> 
> Neil>   mdadm --grow --bitmap=none /dev/md0
> 
> Neil> and it should work with minimal resync...
> 
> So why would I want to remove the bitmap?

To return you to the state you started in.  You didn't have a bitmap
to start with, so I gave you a recipe that left you with no bitmap.  I
didn't want to assume anything about whether you want a bitmap or not.

Ofcouse, if you want to leave the bitmap there, that is fine.
Possibly even a good idea.

NeilBrown
