From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Raid-6 hang on write.
Date: Tue, 01 Mar 2005 10:58:51 +0400
Message-ID: <422412AB.8080907@wasp.net.au>
References: <421DE9A9.4090902@wasp.net.au>	<421F4629.5080309@wasp.net.au> <16930.45319.682534.351648@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <16930.45319.682534.351648@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: lkml <linux-kernel@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> Could you please confirm if there is a problem with
>     2.6.11-rc4-bk4->bk10
> 
> as reported, and whether it seems to be the same problem.

Ok.. are we all ready? I had applied your development patches to all my vanilla 2.6.11-rc4-* 
kernels. Thus they all exhibited the same problem in the same way as -mm1. <Smacks forehead against 
wall repeatedly>

I had applied the patch to correct the looping resync issue with too many failed drives, and just 
continued and applied all the other patches also.

I have been unable to reproduce the fault using a vanilla 2.6.11-rc5-bk2 kernel.

Oh well, at least we now know about a bug in the -mm patches.

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
