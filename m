From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Questions answered by Neil Brown
Date: Thu, 27 Feb 2003 08:45:03 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15965.13663.863891.291188@notabene.cse.unsw.edu.au>
References: <3E5C7079.5C85F1F8@SteelEye.com>
	<200302260809.h1Q89Sa20683@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Wednesday February 26
To: ptb@it.uc3m.es
Cc: Paul Clements <Paul.Clements@SteelEye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 26, ptb@it.uc3m.es wrote:
> 
> What is also puzzling me is that despite the horrible potential for
> what might happen from doing the original users end_io early, I
> can't see any consequences in actual tests!
> 
> I am writing stuff to a file on a raid1 mirror mount, then dismantling
> the mount, the device, and rmmoding the driver. Then I put it all back
> again. On remount the data in the file is all perfect. Yet it was built
> with plenty of async writes! Surely the buffers in some of those writes
> should have been pointing nowhere and been full of rubbish?
> 

I suspect that mostly you are writing from a cache, and the data will
probably stay around.
To be able to demonstrate a problem you probably need very high memory
pressure so things don't stay in cache long, lots of metadata updates,
and probably some for of journalling filesystem like I mentioned
previously.  Have very long latencies for the delayed write would also
make the problem more likely.

Even if you cannot demonstrate a problem, I'm sure one would be
noticed sooner or later if you released this sort of code into the
wild and people used it.

NeilBrown


