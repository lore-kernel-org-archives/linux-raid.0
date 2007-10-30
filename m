From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Implementing low level timeouts within MD
Date: Tue, 30 Oct 2007 13:12:17 +0100
Message-ID: <20071030121217.GC14342@boogie.lpds.sztaki.hu>
References: <1193418753.4771.17.camel@w100> <1193425254.10336.290.camel@firewall.xsintricity.com> <1193521561.7690.14.camel@w100> <1193529329.10336.366.camel@firewall.xsintricity.com> <1193552822.6541.8.camel@w100> <1193678521.10336.486.camel@firewall.xsintricity.com> <1193720887.3876.8.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193720887.3876.8.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 30, 2007 at 12:08:07AM -0500, Alberto Alonso wrote:

> > > * Internal serverworks PATA controller on a netengine server. The
> > >   server if off waiting to get picked up, so I can't get the important
> > >   details.
> > 
> > 1 PATA failure.
> 
> I was surprised on this one, I did have good luck with with PATA in
> the past. The kernel is whatever came standard in Fedora Core 2

The keyword here is probably not "PATA" but "Serverworks"... AFAIR that
chipset was always considered somewhat problematic. You may want to try
with the libata driver, it has a nice comment:

 *      Note that we don't copy the old serverworks code because the old
 *      code contains obvious mistakes

But even the new driver retained this coment from the old driver:

 * Documentation:
 *      Available under NDA only. Errata info very hard to get.

It isn't exactly giving me warm feelings to trust data to this chipset...

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
