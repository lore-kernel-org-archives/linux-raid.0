From: Andrew Rechenberg <arechenberg@shermfin.com>
Subject: Re: [ENBD] is raid of raid possible ?
Date: 14 Jul 2003 08:10:47 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1058184647.1868.4.camel@cinshrlnxws01.shermfin.com>
References: <200307111457.h6BEvIs28677@oboe.it.uc3m.es>
	 <200307141321.42647.bernd.schubert@pci.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200307141321.42647.bernd.schubert@pci.uni-heidelberg.de>
To: Bernd Schubert <bernd.schubert@pci.uni-heidelberg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Not sure if this is relevant, but we've been running a 52-disk Linux
software RAID10 array since January with no isssues re: deadlocking.  I
patched our kernel to use seq_file for /proc/mdstat, but other than
that, I'm using a 'standard' Red Hat kernel.  I cannot comment on ENBD
as I have never used it.  

I may be an exception and not the rule, but I haven't heard of anyone
complaining about RAID on RAID on this list and from my personal
experience it has been stable.

Regards,
Andy.

On Mon, 2003-07-14 at 07:21, Bernd Schubert wrote:
> On Friday 11 July 2003 16:57, Peter T. Breuer wrote:
> > "A month of sundays ago Ulrich Hahn wrote:"
> >
> > > scheme-1 and scheme-2 with software-raid on the fall-back-server will
> > > not work out. I'm not sure if sw-raid over sw-raid is prone to deadlocks
> > > (Peter?), but the tests I did showed that extremly low rebuild-rates,
> > > even
> >
> > It's impossible to say. The raid code is sophisticated = obscure.
> > I think there are no deadlocks - it maintains a separate local cache
> > of request structs per device, as I recall. Ummmm ... but what about
> > buffers? It may maybe deadlock for buffers if there is enough copying
> > and it's done synchronously ...
> >
> > > with tuned md-parameters, will make any medium sized raid unusable.
> >
> 
> Thanks Ulrich and Peter for your answers and help, that helps me a lot for our 
> future plans.
> 
> Best regards,
> 	Bernd
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Andrew Rechenberg <arechenberg@shermfin.com>
Infrastructure Team, Sherman Financial Group
