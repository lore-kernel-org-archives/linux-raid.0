From: Scott McDermott <vaxerdec@frontiernet.net>
Subject: Re: Mirroring swap
Date: Thu, 26 Jun 2003 21:56:06 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030626215606.A29149@newbox.localdomain>
References: <Pine.LNX.4.43.0306260916190.5551-100000@unicorn.drogon.net> <1056662597.10690.6.camel@gregdell.example.com> <200306261444280640.52F72FDF@shargaas.coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200306261444280640.52F72FDF@shargaas.coreyfro.com>; from coreyfro@coreyfro.com on Thu, Jun 26, 2003 at 02:44:28PM -0700
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Corey McGuire on Thu 26/06 14:44 -0700:
> In Linux, is there a reason for using swap if you can
> afford the RAM?

Hmm...if you really aren't using some pages, why not have
them paged out during some idle time and have more free
physical memory available immediately without having to wait
for pageout, should demand occur? I don't know if Linux will
ever page out even very old pages if there is no memory
pressure at all, but it probably makes sense to do so in
order to have memory available immediately, should a huge
demand occur.  Then again, should those pages be demanded
again, you would have to wait for pagein.  I wonder what
Linux does?
