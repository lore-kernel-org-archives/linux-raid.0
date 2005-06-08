From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: active/active vs active/passive?
Date: Wed, 8 Jun 2005 10:16:26 +1000
Message-ID: <17062.14554.533625.74567@cse.unsw.edu.au>
References: <1118189397.15459.108.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Stromberg on Tuesday June 7
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 7, strombrg@dcs.nac.uci.edu wrote:
> 
> The lecturer at the recent NG storage talk at Usenix in Anaheim,
> indicated that it was best to avoid "active/active" and get
> "active/passive" instead.
> 
> Does anyone:
> 
> 1) Know what these things mean?

There's not a lot of context, so it is hard to know.
Could be talking about multi-path devices.
e.g. you have two fibre-channel controllers which are each connected
to the same drive (or set of drives).  data/commands can be sent down
either channel to the drives.

active/active is where both (all) channels are actively in use (load
balancing?).
active/passive is where one is a warm-spare waiting to take over if
the active one fails.

> 
> 2) Know why active/passive might be preferred over active/active?

No idea.

NeilBrown

> 
> If I had to guess, I'd say that active/active means that n servers are
> all watching n-1 others to decide when they should jump to life, while
> in active/passive perhaps 1 server is primary, and the passive nodes
> only monitor that 1 server.  Maybe?  Just a totally wild guess based on
> next to nothing.  :)
> 
> Thanks!
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
