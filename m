From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Fix for raid6 reshape.
Date: Tue, 6 Mar 2007 11:01:53 +1100
Message-ID: <17900.44913.481329.963558@notabene.brown>
References: <20070302155626.19014.patches@notabene>
	<1070302045655.19069@suse.de>
	<20070301223619.d9957521.akpm@linux-foundation.org>
	<17895.50900.585915.565155@notabene.brown>
	<45E88A50.8060906@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Friday March 2
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 2, davidsen@tmr.com wrote:
> >   
> >>> +	conf->expand_progress = (sector_nr + i) * new_data_disks;
> >>>       
> Will the (real) fix be in 2.6.21?

It is now in Linus' git tree, so yes.

NeilBrown
