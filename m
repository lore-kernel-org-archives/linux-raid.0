From: Bernd Schubert <bernd.schubert@pci.uni-heidelberg.de>
Subject: Re: [ENBD] is raid of raid possible ?
Date: Mon, 14 Jul 2003 13:21:42 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307141321.42647.bernd.schubert@pci.uni-heidelberg.de>
References: <200307111457.h6BEvIs28677@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200307111457.h6BEvIs28677@oboe.it.uc3m.es>
Content-Disposition: inline
To: enbd@lists.community.tummy.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 11 July 2003 16:57, Peter T. Breuer wrote:
> "A month of sundays ago Ulrich Hahn wrote:"
>
> > scheme-1 and scheme-2 with software-raid on the fall-back-server will
> > not work out. I'm not sure if sw-raid over sw-raid is prone to deadlocks
> > (Peter?), but the tests I did showed that extremly low rebuild-rates,
> > even
>
> It's impossible to say. The raid code is sophisticated = obscure.
> I think there are no deadlocks - it maintains a separate local cache
> of request structs per device, as I recall. Ummmm ... but what about
> buffers? It may maybe deadlock for buffers if there is enough copying
> and it's done synchronously ...
>
> > with tuned md-parameters, will make any medium sized raid unusable.
>

Thanks Ulrich and Peter for your answers and help, that helps me a lot for our 
future plans.

Best regards,
	Bernd
