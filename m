From: Jim Paris <jim@jtan.com>
Subject: Re: RAID-6: help wanted
Date: Fri, 29 Oct 2004 15:21:32 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041029192132.GA10079@jim.sh>
References: <20041029114823.GA6431@jim.sh> <200410291256.i9TCuIN13270@www.watkins-home.com> <20041029181514.GA8346@jim.sh> <41829423.2080201@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41829423.2080201@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Guy <bugzilla@watkins-home.com>, 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >I think they can both be updated with read-modify-write:
> >
> >P' = P + D_n + D_n'
> >Q' = Q + g^n * D_n + g^n * D_n'
> 
> It's not a matter of cache-trashing, it's a matter of the fact that very 
> few CPUs have any form of parallel table lookup.  It could be done with 
> dynamic code generation, but that's a whole ball of wax on its own.

Why dynamic?  Are there problems with just pregenerating all 256
optimized codepaths?

-jim
