From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 10 Oct 2006 09:06:31 +1000
Message-ID: <17706.54775.830279.53938@cse.unsw.edu.au>
References: <17532.59212.364233.765155@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>
	<17532.62343.933852.982391@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>
	<17534.22056.981033.686846@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606020009560.10016@twinlark.arctic.org>
	<17535.59496.431182.785563@cse.unsw.edu.au>
	<448F0994.6050704@tmr.com>
	<17551.18061.160356.35034@cse.unsw.!edu.au>
	<4528377A.2010001@cjx.com>
	<20061009110344.GA7104@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Allen on Monday October 9
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 9, chris@cjx.com wrote:
> Ok, after more testing, this lockup happens consistently when
> bitmaps are switched on and never when they are switched off.
> 
> Ideas anybody?
> 

No. I'm completely stumped.
Which means it is probably something very obvious, but I keep looking
in the wrong place :-)

The interaction with bitmaps is interesting and might prove helpful.
I'll have another look at the code and see if it opens up some
possibilities. 

I've been working with Dean Gaudet who can reproduce it.  He has been
trying out patches that print out lots of debugging information when
the problem occurs.  This has narrowed it down a bit, but I'm still in
the dark.

It seems that blk_plug_device is setting a timer to go off in about
3msecs, but it gets deactivated without firing. This should only
happen when the device gets unplugged, but the device remains plugged.

Are you happy to try a kernel.org kernel with a few patches and a
little shell script running?
The net result is that it detects when there is a problem, prints out
some trace information, and then gets array going again.

Thanks,
NeilBrown
