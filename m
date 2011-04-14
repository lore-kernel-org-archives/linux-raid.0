From: Tapani Tarvainen <raid@tapanitarvainen.fi>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Thu, 14 Apr 2011 14:41:18 +0300
Message-ID: <20110414114118.GF6876@baribal.tarvainen.info>
References: <4DA6CCFE.8020708@crc.id.au>
 <20110414165433.7a7d1cdc@natsu>
 <20110414110558.GD6876@baribal.tarvainen.info>
 <20110414172528.72122371@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110414172528.72122371@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 14, 2011 at 05:25:28PM +0600, Roman Mamedov (rm@romanrm.ru) wrote:

> > > I suggest that you avoid Silicon Image 3132, they have data corruption
> > > issue (on some board designs?), triggered or amplified by transferring via
> > > both ports at the same time, at full speed.

> See this thread: http://comments.gmane.org/gmane.linux.raid/30629

Thanks! Based on that, it'd seem it's not so much Sil3132 per se,
but some (too cheaply?) boards built around it, and the obvious
conclusion is that they should only be bought with plan to
test them before real use and return flakey ones.

I _have_ had similar data corruption problems with one Sil3124
card, none with two more, and also none with a 3114 card
(in heavy use for several years by now).

On the other hand I've had similar trouble with a JMicron card
and a Marvell-based card. So planning to test and return
bad cards is probably a good idea with them as well.

-- 
Tapani Tarvainen
