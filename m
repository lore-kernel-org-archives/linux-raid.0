From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Fix for raid6 reshape.
Date: Fri, 2 Mar 2007 17:40:20 +1100
Message-ID: <17895.50900.585915.565155@notabene.brown>
References: <20070302155626.19014.patches@notabene>
	<1070302045655.19069@suse.de>
	<20070301223619.d9957521.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Thursday March 1
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 1, akpm@linux-foundation.org wrote:
> On Fri, 2 Mar 2007 15:56:55 +1100 NeilBrown <neilb@suse.de> wrote:
> 
> > -	conf->expand_progress = (sector_nr + i)*(conf->raid_disks-1);
> > +	conf->expand_progress = (sector_nr + i) * new_data_disks);
> 
> ahem.


It wasn't like that when I tested it, honest...
But the original got caught up with some other changes which were not
really related so I removed them all and just made this change
manually.... and totally messed it up (again).  Sorry.

Of course it should be

> > +	conf->expand_progress = (sector_nr + i) * new_data_disks;

NeilBrown
