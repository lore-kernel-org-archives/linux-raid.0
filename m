From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 1 of 2] Fix multipath assembly bug
Date: Mon, 14 Feb 2005 13:52:55 +1100
Message-ID: <16912.4743.676766.127391@cse.unsw.edu.au>
References: <20050210091909.1612.patches@notabene>
	<E1Cz0ER-0000QW-TP@notabene.cse.unsw.edu.au>
	<420B3BA8.2050907@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Michael Tokarev on Thursday February 10
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 10, mjt@tls.msk.ru wrote:
> NeilBrown wrote:
> > In md, there are "level" number and "personality" numbers.
> > LEVEL_MULTIPATH is the level number for multipath.
> > MULTIPATH is the personality number for multipath.
> 
> BTW, why the two in the first place?  Isn't it nice to
> eliminate one of them?

Historical reasons....

The "Level" number corresponds to the common names of the raid levels:
 0, 1, 4, 5, 6 ...
There is also "-1" for "linear", which is a bit of a hack.

The personality numbers are dense small integers: 0 1 2 3 4 ...
and are used for indexing.

You are right: the personality number isn't needed and could be
eliminated, however it isn't a priority for me yet.  Patches welcome
....

NeilBrown


