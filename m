From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: Reproducable OOPS with MD RAID-5 on 2.6.0-test11
Date: Wed, 3 Dec 2003 17:23:02 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0312031721210.2055@home.osdl.org>
References: <3FCB4AFB.3090700@backtobasicsmgmt.com> <20031201141144.GD12211@suse.de>
 <3FCB4CFA.4020302@backtobasicsmgmt.com> <20031201155143.GF12211@suse.de>
 <3FCC0EE0.9010207@backtobasicsmgmt.com> <20031202082713.GN12211@suse.de>
 <Pine.LNX.4.58.0312021009070.1519@home.osdl.org> <20031204011236.GA5622@simulated.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031204011236.GA5622@simulated.ca>
To: Simon Kirby <sim@netnation.com>
Cc: Linux-raid maillist <linux-raid@vger.kernel.org>, Jens Axboe <axboe@suse.de>, Neil Brown <neilb@cse.unsw.edu.au>, "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>, LKML <linux-kernel@vger.kernel.org>, linux-lvm@sistina.com
List-Id: linux-raid.ids



On Wed, 3 Dec 2003, Simon Kirby wrote:
>
> In any event, this patch against 2.6.0-test11 compiles without warnings,
> boots, and (bonus) actually works:

Really? This actually makes a difference for you? I don't see why it
should matter: even if the sector offsets would overflow, why would that
cause _oopses_?

[ Insert theme to "The Twilight Zone" ]

Neil, Jens, any ideas?

		Linus
