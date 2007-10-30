From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Implementing low level timeouts within MD
Date: Tue, 30 Oct 2007 00:08:07 -0500
Message-ID: <1193720887.3876.8.camel@w100>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <1193521561.7690.14.camel@w100>
	 <1193529329.10336.366.camel@firewall.xsintricity.com>
	 <1193552822.6541.8.camel@w100>
	 <1193678521.10336.486.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193678521.10336.486.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2007-10-29 at 13:22 -0400, Doug Ledford wrote:

> OK, these you don't get to count.  If you run raid over USB...well...you
> get what you get.  IDE never really was a proper server interface, and
> SATA is much better, but USB was never anything other than a means to
> connect simple devices without having to put a card in your PC, it was
> never intended to be a raid transport.

I still count them ;-) I guess I just would of hoped for software raid
to really don't care about the lower layers.
> 
> > * Internal serverworks PATA controller on a netengine server. The
> >   server if off waiting to get picked up, so I can't get the important
> >   details.
> 
> 1 PATA failure.

I was surprised on this one, I did have good luck with with PATA in
the past. The kernel is whatever came standard in Fedora Core 2

> 
> > * Supermicro MB with ICH5/ICH5R controller and 2 RAID5 arrays of 3 
> >   disks each. (only one drive on one array went bad)
> > 
> > * VIA VT6420 built into the MB with RAID1 across 2 SATA drives.
> > 
> > * And the most complex is this week's server with 4 PCI/PCI-X cards.
> >   But the one that hanged the server was a 4 disk RAID5 array on a
> >   RocketRAID1540 card.
> 
> And 3 SATA failures, right?  I'm assuming the Supermicro is SATA or else
> it has more PATA ports than I've ever seen.
> 
> Was the RocketRAID card in hardware or software raid mode?  It sounds
> like it could be a combination of both, something like hardware on the
> card, and software across the different cards or something like that.
> 
> What kernels were these under?


Yes, these 3 were all SATA. The kernels (in the same order as above) 
are:

* 2.4.21-4.ELsmp #1 (Basically RHEL v3)
* 2.6.18-4-686 #1 SMP on a Fedora Core release 2
* 2.6.17.13 (compiled from vanilla sources)

The RocketRAID was configured for all drives as legacy/normal and
software RAID5 across all drives. I wasn't using hardware raid on
the last described system when it crashed.

Alberto


