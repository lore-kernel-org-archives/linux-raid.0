From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Enable HTT with dual xeon fileserver ?
Date: Wed, 18 Sep 2002 20:49:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15752.23100.95651.59572@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0209162301200.24650-100000@ddx.a2000.nu>
	<001d01c25ef9$6bc25240$900d0d93@M02WS17219>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin Eriksson on Wednesday September 18
To: Martin Eriksson <nitrax@giron.wox.org>
Cc: raid@ddx.a2000.nu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 18, nitrax@giron.wox.org wrote:
> 
> A follow-up question: Does sw-raid5 checksumming use multiple CPUs in any
> way?

It could if separate threads were submitting requests on the same
array, but I don't think it would be very likely.  Lots of the
checksumming is done by raid5d which is single threaded.

Ofcourse if you had 2 raid5 arrays, they could quite possibly use one
cpu each.

NeilBrown
