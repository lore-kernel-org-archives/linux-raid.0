From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6: help wanted
Date: Fri, 29 Oct 2004 19:04:03 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41829423.2080201@zytor.com>
References: <20041029114823.GA6431@jim.sh> <200410291256.i9TCuIN13270@www.watkins-home.com> <20041029181514.GA8346@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041029181514.GA8346@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: Guy <bugzilla@watkins-home.com>, 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Paris wrote:
> 
> I think they can both be updated with read-modify-write:
> 
> P' = P + D_n + D_n'
> Q' = Q + g^n * D_n + g^n * D_n'
> 
> However, the multiplications by g^n for computing Q' could be killer
> on your CPU, so it's a tradeoff.  Since we're updating e.g. 128k at
> once for a single value of n, it's possible that it could be done 
> in such a way that it's not too intensive (or cache-thrashing).
> Or perhaps you have so many disks that it really is worth the time
> to do the computation rather than read from all of them.  
> 

It's not a matter of cache-trashing, it's a matter of the fact that very 
few CPUs have any form of parallel table lookup.  It could be done with 
dynamic code generation, but that's a whole ball of wax on its own.

	-hpa

