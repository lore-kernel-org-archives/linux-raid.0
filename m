From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Help: very slow software RAID 5.
Date: Fri, 21 Sep 2007 01:08:41 +0400
Message-ID: <46F2E159.9030806@msgid.tls.msk.ru>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan> <20070919014919.DF19D10215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709190437050.4411@p34.internal.lan> <20070919174956.9497310209D@medulla.enet.sharplabs.com> <46F292E2.1090700@tmr.com> <20070920184738.441FD10208C@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070920184738.441FD10208C@medulla.enet.sharplabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dean S. Messing wrote:
[]
> []  That's what
> attracted me to RAID 0 --- which seems to have no downside EXCEPT
> safety :-).
> 
> So I'm not sure I'll ever figure out "the right" tuning.  I'm at the
> point of abandoning RAID entirely and just putting the three disks
> together as a big LV and being done with it.  (I don't have quite the
> moxy to define a RAID 0 array underneath it. :-)

"Putting three disks together as a big LV" - that's exactly what
"linear" md module.  It's almost as unsafe as raid0, but with
linear read/write speed equal to speed of single drive...
Note also that the more drives you add to raid0-like config,
the more chances of failure you'll have - because raid0 fails
when ANY drive fails.  Ditto - for certain extent - for linear
md module and for "one big LV" which is basically the same thing.

By the way, before abandoming "R" in "RAID", I'd check whenever
the resulting speed with raid5 (after at least read-ahead tuning)
is acceptable, and use that if yes.  If no, maybe raid10 over
the same 3 drives will give better results.

/mjt
