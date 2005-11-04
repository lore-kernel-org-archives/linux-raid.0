From: Neil Brown <neilb@suse.de>
Subject: Re: Oopsing with md in 2.6.14-rc5-mm1
Date: Fri, 4 Nov 2005 15:59:04 +1100
Message-ID: <17258.60056.453054.686651@cse.unsw.edu.au>
References: <436AE0D2.3080000@reub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Reuben Farrelly on Friday November 4
Sender: linux-raid-owner@vger.kernel.org
To: Reuben Farrelly <reuben-lkml@reub.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 4, reuben-lkml@reub.net wrote:
> 
> I noticed a heap of patches out today from NeilB, are these likely to solve this 
> problem?

Thanks for the report.
This problem has been fixed in a patch sent to Andrew, but I think it
is a little less recent that the bunch you mention.
The fix should be in the next -mm, and maybe even in -rc1 (though it
hasn't made it to -git yet).

NeilBrown
