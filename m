From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID-6: help wanted
Date: Fri, 29 Oct 2004 16:28:01 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410292028.i9TKS6N14580@www.watkins-home.com>
References: <20041029192132.GA10079@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041029192132.GA10079@jim.sh>
To: 'Jim Paris' <jim@jtan.com>, "'H. Peter Anvin'" <hpa@zytor.com>
Cc: 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Could you translate this into English?
P' = P + D_n + D_n'
Q' = Q + g^n * D_n + g^n * D_n'

I understand this much:
P    =old parity
D_n  =old data block(s)
P'   =new parity
D_n' =new data block(s)

But is "+" = xor?

I am lost on this one:
Q' = Q + g^n * D_n + g^n * D_n'

With the parity (xor) it can be done by the bit, so an example is easy.
Can Q be done by the bit, and if so, could you give an example?

If it takes more than 10 minutes, just tell me it is magic! :)

Also, on a related subject....
I have a 14 disk RAID5 with 1 spare.
Once RAID6 seems safe and stable I had hoped to convert to a 15 disk RAID6.
Is 15 disks too much for RAID6?
Any idea what a reasonable limit would be?

Thanks,
Guy



-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jim Paris
Sent: Friday, October 29, 2004 3:22 PM
To: H. Peter Anvin
Cc: Guy; 'Neil Brown'; linux-raid@vger.kernel.org
Subject: Re: RAID-6: help wanted

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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

