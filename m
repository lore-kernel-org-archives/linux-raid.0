From: Marc MERLIN <marc@merlins.org>
Subject: Re: How to force rewrite of a smart detected bad block with raid5: checkarray?
Date: Wed, 19 Jan 2011 13:03:06 -0800
Message-ID: <20110119210306.GJ7117@merlins.org>
References: <20110119070419.GC31606@merlins.org> <alpine.DEB.1.10.1101190842170.13151@uplift.swm.pp.se> <20110119204115.0fe4b159@notabene.brown> <20110119173150.GB6823@merlins.org> <20110120075842.25912e84@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110120075842.25912e84@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 20, 2011 at 07:58:42AM +1100, NeilBrown wrote:
> Like I suggest, rounding might be necessary.
> I just checked the code and this number does need to be a multiple of the
> chunk size, which is 1024 sectors for you.
> so 
>    echo 3907028992 > sync_min
> 
> should do the trick.

I misunderstood, I thought you were worried that I wouldn't check the right
blocks, not "rounding or it won't be accepted by the kernel" :)

This worked fine, thanks for your help.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
