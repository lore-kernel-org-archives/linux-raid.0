From: Ingo Molnar <mingo@redhat.com>
Subject: Re: Fast (intelligent) raid1
Date: Fri, 24 Jan 2003 04:03:40 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301240354520.3568-100000@devserv.devel.redhat.com>
References: <200301231707.h0NH72U31504@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200301231707.h0NH72U31504@oboe.it.uc3m.es>
To: "Peter T. Breuer" <ptb@it.uc3m.es>
Cc: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Peter,

your patch looks really interesting.

> The driver keeps a bitmap of pending writes in memory, and writes them
> to the mirror component that's just been repaired when it comes back on
> line.  The bitmap is two-level and created pagewise on demand, so it's
> not too expensive. [...]

how do you ensure that the 'repaired' drive indeed only differs in the
dirty-bitmap portions of the data disk? It's perfectly valid to add a
completely new (and unsynced) disk to the system when one disk fails. Or
is this the responsibility of the administrator?

also, your resyncing method does not attempt to address the resync
necessary to be done after an unclear shutdown (eg. power failure),
correct?

	Ingo


