From: Neil Brown <neilb@suse.de>
Subject: Re: Suggestion needed for fixing RAID6
Date: Mon, 3 May 2010 12:29:42 +1000
Message-ID: <20100503122942.7d4db27c@notabene.brown>
References: <626601cae203$dae35030$0400a8c0@dcccs>
	<20100423065143.GA17743@maude.comedia.it>
	<695a01cae2c1$a72907d0$0400a8c0@dcccs>
	<4BD193D0.5080003@shiftmail.org>
	<717901cae3e5$6a5fa730$0400a8c0@dcccs>
	<4BD3751A.5000403@shiftmail.org>
	<756601cae45e$213d6190$0400a8c0@dcccs>
	<4BD569E2.7010409@shiftmail.org>
	<7a3e01cae53f$684122c0$0400a8c0@dcccs>
	<4BD5C51E.9040207@shiftmail.org>
	<80a201cae621$684daa30$0400a8c0@dcccs>
	<4BD76CF6.5020804@shiftmail.org>
	<20100428113732.03486490@notabene.brown>
	<alpine.DEB.1.10.1004280400330.6768@uplift.swm.pp.se>
	<20100428121246.2ceabfd5@notabene.brown>
	<alpine.DEB.1.10.1004280421450.6768@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1004280421450.6768@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: MRK <mrk@shiftmail.org>, Janos Haar <janos.haar@netcenter.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Apr 2010 04:30:05 +0200 (CEST)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Wed, 28 Apr 2010, Neil Brown wrote:
> 
> > There are lots of places that say "raid5" where it could apply to raid4 
> > or raid6 as well.  Maybe I should change them all to 'raid456'...
> 
> That sounds like a good idea, or just call it "raid:" or "raid4/5/6".
> 
> Don't know where we are in the stable kernel release cycle, but it would 
> be super if this could make it in by next cycle, this code is handling the 
> fault scenario that made me go from raid5 to raid6 :)
> 

We are very close to release of 2.6.34.  I won't submit this before 2.6.34 is
released as it is not a regression and not technically a data-corruption
bug.  However it will go into 2.6.35-rc1 and but submitted to -stable for
2.6.34.1 and probably other -stable kernels.

NeilBrown
