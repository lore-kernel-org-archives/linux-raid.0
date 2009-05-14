From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over
     all strip_zones.
Date: Thu, 14 May 2009 22:22:33 +1000
Message-ID: <18956.3337.786085.284689@notabene.brown>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	<1242297833-13908-2-git-send-email-maan@systemlinux.org>
	<fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from NeilBrown on Thursday May 14
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 14, neilb@suse.de wrote:
> 
> Then the loop could be
>    for (i = 0; i < conf->nr_strip_zones; i++)
>          if (sector < conf->strip_zone[i+1])
>                return conf->strip_zone[i]
> 
> Save our selves an 'add' that way :-)

That should have been

> 
> Then the loop could be
>    for (i = 0; i < conf->nr_strip_zones; i++)
>          if (sector < conf->strip_zone[i+1]->zone_start)
>                return conf->strip_zone[i]
> 
> Save ourselves an 'add' that way :-)

and as we aren't using ->sectors in this loop any more, I think it
can be discarded completely, just making struct strip_zone 20% smaller
and improving cache performance.

What do you think?

NeilBrown
