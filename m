From: Dominik Kubla <dominik@kubla.de>
Subject: Re: New mailing list for 2.6 Medley RAID (Silicon Image 3112 etc.) BIOS RAID development
Date: Mon, 9 Feb 2004 18:54:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040209175421.GD1795@intern.kubla.de>
References: <Pine.LNX.4.40.0402091220130.8715-100000@jehova.dsm.dk> <4027BBDE.1090300@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4027BBDE.1090300@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Thomas Horsten <thomas@horsten.com>, Arjan van de Ven <arjanv@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 09, 2004 at 11:57:02AM -0500, Jeff Garzik wrote:
> Thomas Horsten wrote:
> >My gut feeling is that if it is provided by the BIOS and reliable
> >autodetection is possible, it should be autodetected. Why require the user
> >to discover and supply information that the kernel could easily and
> >reliably find out by itself? Besides, if there is no autodetection, the
> 
> The autodetection will occur, reliably and without additional user 
> information, from initramfs.
> 
> As Arjan said, we are moving this type of stuff out of the kernel.
> 
> 	Jeff

Is there any existing code using initramfs? So far all i have seen is
very incomplete.  I would love to move to initramfs and get rid of
mkinitrd, but too many pieces seem to be still missing...

Regards,
  Dominik Kubla
-- 
The more cordial the buyer's secretary, the greater the odds that the
competition already has the order.
