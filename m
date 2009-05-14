From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over  
     all strip_zones.
Date: Fri, 15 May 2009 06:38:35 +1000 (EST)
Message-ID: <bdf8aeadb1c3d24a5b43ba3264d53dc2.squirrel@neil.brown.name>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
    <1242297833-13908-2-git-send-email-maan@systemlinux.org>
    <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
    <18956.3337.786085.284689@notabene.brown>
    <1242316280.11444.4.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242316280.11444.4.camel@raz>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 15, 2009 1:51 am, raz ben yehuda wrote:
>
> On Thu, 2009-05-14 at 22:22 +1000, Neil Brown wrote:
>> On Thursday May 14, neilb@suse.de wrote:
>> >
>> > Then the loop could be
>> >    for (i = 0; i < conf->nr_strip_zones; i++)
>> >          if (sector < conf->strip_zone[i+1])
>> >                return conf->strip_zone[i]
>> >
>> > Save our selves an 'add' that way :-)
>>
>> That should have been
>>
>> >
>> > Then the loop could be
>> >    for (i = 0; i < conf->nr_strip_zones; i++)
>> >          if (sector < conf->strip_zone[i+1]->zone_start)
>> >                return conf->strip_zone[i]
>> >
>> > Save ourselves an 'add' that way :-)
>>
>> and as we aren't using ->sectors in this loop any more, I think it
>> can be discarded completely, just making struct strip_zone 20% smaller
>> and improving cache performance.
>>
>> What do you think?
> hamm.. please do not do it now. I think i need it for the reshape
> because I have to traverse each zone up to its end.

You don't lose that ability.  Then end of one zone matches the
beginning of the next zone.  So run from
   zone[0].zone_start
to
   zone[1].zone_start

I was thinking further about this and realised that in the first zone,
zone_start is always 0.  And we added a sentinal zone for which only
the zone_start value is set.  This seems silly.
Instead we can just store 'zone_end' in each zone (or possibly
start_of_next_zone) and then we don't need the sentinal and don't waste
the zone_start at the beginning.

NeilBrown


>> NeilBrown
>
>
>

