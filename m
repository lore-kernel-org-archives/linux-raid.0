From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: stoppind md from kicking out "bad' drives
Date: Mon, 11 Nov 2013 08:56:54 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1311110853530.26054@uplift.swm.pp.se>
References: <5280870E.6080703@msgid.tls.msk.ru> <alpine.DEB.2.02.1311110838190.26054@uplift.swm.pp.se> <52808C72.3000405@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52808C72.3000405@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 11 Nov 2013, Michael Tokarev wrote:

> No, really, that's not the solutions I was asking for.

Well, it is.

> Yes raid6 is better in this context.  But it has exactly the same properties
> when drives start "semi-failing" - it is enough to have one bad sector in
> different places of 3 drives for a catastrophic failure, while the array
> can even continue to work normally because the bad sectors are in different
> places.

If you have timeouts set properly then md will be able to re-calculate the 
bad sector from parity and re-write it, even with one drive failed.

> It is the drive kick-off - the decision made by md driver - which makes 
> the failure catastrophic.

That's what the timeout problem is. If you're running consumer drives and 
default linux kernel timeouts then the drive will be kicked before it can 
return a read error.

> We may reduce probability of such event by using different configuration 
> tweaks, but the underlying problem remains.

The underlying problem is that you have drives that take longer to return 
errors compared to the settings you have to wait for results from the 
drive.

> Nope, because the array were (re)syncing a hot spare, not the first failed
> drive.

I don't understand why you would be running a RAID5+spare instead of 
RAID6 without spare.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
