From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: second controller: what will my discs be called, and does it matter?
Date: Fri, 7 Jul 2006 15:15:48 +0200
Message-ID: <20060707131548.GF26669@boogie.lpds.sztaki.hu>
References: <200607062012.14684.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200607062012.14684.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 06, 2006 at 08:12:14PM +0200, Dexter Filmore wrote:

> How can I tell if the discs on the new controller will become sd[e-h] or if 
> they'll be the new a-d and push the existing ones back?

If they are the same type (or more precisely, if they use the same
driver), then their order on the PCI bus will decide. Otherwise, if you
are using modules, then the order you load the drivers will decide. If
the drivers are built into the kernel, then their link order will
decide.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
