From: Danilo Godec <danci@agenda.si>
Subject: Re: Fw: DriveReady SeekComplete problems
Date: Sat, 11 May 2002 08:10:08 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205110758030.17857-100000@duplo.agenda.si>
References: <001201c1f85e$468637a0$c264a8c0@hoytpub.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001201c1f85e$468637a0$c264a8c0@hoytpub.com>
To: Artur Jasowicz <arturj@mousebusiness.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 May 2002, Artur Jasowicz wrote:

> The more I think about it the more it seems like the system not
> keeping up with the drives though. Isn't it strange that both my 2000+

It's a wild guess, but you might want to try disabling one of the
processors using 'nosmp' kernel parameter. Maybe Athlons have some issues
with SMP configuration.

Next would be testing a single drive. If the problem exists using a single
drive, you should try some other controller (I never used a HPT, but a
friend of mine has a problem with it - dunno what exactly though).

OR, having three IDE controllers sharing one IRQ just might be a problem.
I remember that on my SMP motherboards I had a lot more available IRQs
(over 25), available through APIC (whatever that is).

   D.


