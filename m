From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID autorun support for SunOS disk labels
Date: Tue, 23 Jul 2002 23:13:10 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D3DAAC6.86AFD554@tls.msk.ru>
References: <20020426101101.GA25225@monkey.beezly.org.uk> <1019846049.1670.76.camel@peecee> <20020426190321.GB31434@monkey.beezly.org.uk> <87ptxf6711.fsf@qaip3.ins.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hein Roehrig wrote:
> 
> Andrew Beresford <beezly@beezly.org.uk> writes:
> 
> > [...] I'll create the patch anyway [...]
> 
> Did you ever get around to this? I would be very interested in such a
> patch (need a drop-in replacement for a 2.2.17, can think about
> initrd later when I am the console and not remote-debugging.)

What's wrong with using kernel command-line for raid - e.g.
 linux md=2,/dev/sda1,/dev/sdb1,/dev/sdc1
etc ?  No need for autodetection and no need for initrd.
Works here like a charm (2.4.x kernels, 2.2 has no such
option).

/mjt
