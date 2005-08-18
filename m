From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: perfomance question.
Date: Thu, 18 Aug 2005 14:59:23 +1000
Message-ID: <17156.5547.61133.39733@cse.unsw.edu.au>
References: <20050717182650.24540.patches@notabene>
	<E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au>
	<009001c58ac8$9ab25d40$0400a8c0@LocalHost>
	<17114.55335.687696.686786@cse.unsw.edu.au>
	<03e501c5a120$f3a79a00$0400a8c0@LocalHost>
	<17151.60931.26972.713074@cse.unsw.edu.au>
	<011101c5a187$3bc8cf00$0400a8c0@LocalHost>
	<016001c5a26a$05ad3e40$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from djani22@dynamicweb.hu on Tuesday August 16
Sender: linux-raid-owner@vger.kernel.org
To: djani22@dynamicweb.hu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 16, djani22@dynamicweb.hu wrote:
> Hello list,
> 
> I have performance problem. (again) :-)
> 
> What chunk size is better in  raid5, and raid0?
> The lot of small chunks, or some bigger?

This is highly dependant one workload and hardware performance. 
The best thing to do is develop a test that simulates your real
workload and run it with various stripe sizes, and see which one wins.

I suspect there would be very little gain in going to very small chunk
sizes (<16k).  Anywhere between there and 1Meg is worth trying.

mdadm uses a default of 64k which is probably not too bad for most
situations, but I cannot promise it being optimal for any.

Sorry I cannot be more helpful.

Your performance problem may not be chunk-size related.  Maybe
increasing the readahead (with blockdev) would help...

NeilBrown
