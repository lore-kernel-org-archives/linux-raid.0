From: dean gaudet <dean@arctic.org>
Subject: Re: md array numbering is messed up
Date: Mon, 30 Oct 2006 03:58:38 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0610300352370.26021@twinlark.arctic.org>
References: <45451A4C.9010708@peeble.net> <17733.7315.357603.311275@cse.unsw.edu.au>
 <4545DECE.7030705@tls.msk.ru> <4545E0BC.5010103@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4545E0BC.5010103@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Neil Brown <neilb@suse.de>, Peb <peb-misc@peeble.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 30 Oct 2006, Brad Campbell wrote:

> Michael Tokarev wrote:
> > My guess is that it's using mdrun shell script - the same as on Debian.
> > It's a long story, the thing is quite ugly and messy and does messy things
> > too, but they says it's compatibility stuff and continue shipping it.
...
> 
> I'd suggest you are probably correct. By default on Ubuntu 6.06
> 
> brad@bklaptop2:~$ cat /etc/init.d/mdadm-raid
> #!/bin/sh
> #
> # Start any arrays which are described in /etc/mdadm/mdadm.conf and which are
> # not running already.
> #
> # Copyright (c) 2001-2004 Mario Jou/3en <joussen@debian.org>
> # Distributable under the terms of the GNU GPL version 2.
> 
> MDADM=/sbin/mdadm
> MDRUN=/sbin/mdrun

fwiw mdrun is finally on its way out.  the debian "unstable" mdadm package 
is full of new goodness (initramfs goodness, 2.5.x mdadm featurefulness, 
monthly full array check goodness).  ubuntu folks should copy it again 
before they finalize edgy.

-dean
