From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 8-port SATA PCI/PCIX adaptor
Date: Sat, 2 Apr 2005 17:31:55 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0504021656340.30253@lion.drogon.net>
References: <d2mae1$ii$1@sea.gmane.org> <Pine.LNX.4.56.0504021552250.30253@lion.drogon.net>
 <20050402155221.GA22746@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050402155221.GA22746@lists.us.dell.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2 Apr 2005, Matt Domsch wrote:

> On Sat, Apr 02, 2005 at 04:04:48PM +0100, Gordon Henderson wrote:
> > The cheaper cards that I've used seem to have mostly the SII chipset - and
> > that appears to be well supported by Linux. The 3112 is a dual-port card,
> > the 3114, quad. There are RAID and non-RAID variants, and all the ones
> > I've used seem to have a JBOD mode anyway (so you use s/w RAID rather than
> > their supplied h/w RAID) (The exception would seem to be the Dell/Adaptec
> > 6-port SATA card I had recently - it has 3 x SII 3112 chips on it, and a
> > big Adaptec/Dell chip which hides them from bus )-:
>
> The Dell CERC SATA 1.5/6ch cards use the standard aacraid driver, so
> no worries about unavailable/closed-source drivers there.

Ah, intersting. I must have a look at it one day. I got it in a free Dell
server I got when I ordered a bunch of other Dell stuff. I've no idea why
they included it, as the on-board SATA ports seem to work just as well. I
didn't really have time to play with it as the client wanted it online
sooner rather than later, so it's currently whirring away with the drives
on the on-board (Intel) controller using s/w RAID...

Cheers,

Gordon

