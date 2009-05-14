From: raz ben yehuda <raziebe@gmail.com>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over
	all strip_zones.
Date: Thu, 14 May 2009 18:51:20 +0300
Message-ID: <1242316280.11444.4.camel@raz>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
	 <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
	 <18956.3337.786085.284689@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18956.3337.786085.284689@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Thu, 2009-05-14 at 22:22 +1000, Neil Brown wrote:
> On Thursday May 14, neilb@suse.de wrote:
> > 
> > Then the loop could be
> >    for (i = 0; i < conf->nr_strip_zones; i++)
> >          if (sector < conf->strip_zone[i+1])
> >                return conf->strip_zone[i]
> > 
> > Save our selves an 'add' that way :-)
> 
> That should have been
> 
> > 
> > Then the loop could be
> >    for (i = 0; i < conf->nr_strip_zones; i++)
> >          if (sector < conf->strip_zone[i+1]->zone_start)
> >                return conf->strip_zone[i]
> > 
> > Save ourselves an 'add' that way :-)
> 
> and as we aren't using ->sectors in this loop any more, I think it
> can be discarded completely, just making struct strip_zone 20% smaller
> and improving cache performance.
> 
> What do you think?
hamm.. please do not do it now. I think i need it for the reshape
because I have to traverse each zone up to its end. 
> NeilBrown



