From: Hein Roehrig <hpr@eml.cc>
Subject: Re: RAID autorun support for SunOS disk labels
Date: 23 Jul 2002 21:49:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87k7nm6x8d.fsf@qaip3.ins.cwi.nl>
References: <20020426101101.GA25225@monkey.beezly.org.uk> <1019846049.1670.76.camel@peecee> <20020426190321.GB31434@monkey.beezly.org.uk> <87ptxf6711.fsf@qaip3.ins.cwi.nl> <3D3DAAC6.86AFD554@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> writes:

> What's wrong with using kernel command-line for raid - e.g.
>  linux md=2,/dev/sda1,/dev/sdb1,/dev/sdc1
> etc ?  No need for autodetection and no need for initrd.
> Works here like a charm (2.4.x kernels, 2.2 has no such
> option).

When you remove or exchange drives this is not nice. And I have six
disks in a set. I have a preliminary patch (posted in another message)
but now I have other transition problems 2.2.17->2.4.19-rc3. Once
these are resolved and I have the system working with 2.4.19, I am
going to think about a nice long-term solution.

Thanks,
Hein


