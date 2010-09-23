From: Neil Brown <neilb@suse.de>
Subject: Re: How to prevent auto assembly?
Date: Thu, 23 Sep 2010 14:07:44 +1000
Message-ID: <20100923140744.286ccd6d@notabene>
References: <20100923033822.E7819E30965@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100923033822.E7819E30965@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 22 Sep 2010 21:37:22 -0600
Jim Schatzman <james.schatzman@futurelabusa.com> wrote:

> I put "AUTO -1.X" in my /etc/mdadm.conf file, to try to prevent my version 1.2 arrays from being automatically assembled. Nevertheless, the arrays were auto-assembled at boot time.
> 
> How do I prevent this from happening?

 - use "1.x" rather than "1.X" - that test isn't case-insensitive.
 - make sure the arrays aren't mention in /etc/mdadm.conf, or if they are,
   replace the "/dev/mdXX" part with "ignore".
 - run mkinitramfs if you haven't already - the arrays might be assembled in
   early boot.

NeilBrown


> 
> OS:  Linux l1.fu-lab.com 2.6.34.6-47.fc13.i686.PAE #1 SMP Fri Aug 27 09:29:49 UTC 2010 i686 i686 i386 GNU/Linux
> 
> MDADM: mdadm - v3.1.2 - 10th March 2010
> 
> Arrays are version 1.2.
> 
> Thanks!
> 
> Jim
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

