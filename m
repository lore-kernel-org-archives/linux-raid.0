From: Gordon Henderson <gordon@drogon.net>
Subject: ECC: RE: ext3 blah blah blah ...
Date: Wed, 5 Jan 2005 17:34:16 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501051729290.9117@lion.drogon.net>
References: <Pine.LNX.3.96.1050105091502.9709A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050105091502.9709A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 5 Jan 2005, Alvin Oga wrote:

> even if one uses ecc... ecc can only fix certain errors,
> and non-correctable errors are flagged and not fixed
> ( burst errors are hard to fix )
>
> and people that use ecc memory ... usually have higher-end motherboards
> and more memory in the system vs the $50 motherboard+cpu combo (disasters)
> from fries ( a local pc store )

One thing thats been irritating me for a long time is that it's all very
well using (and paying for!) ECC memory, but there are parts of the system
that don't have ECC or parity - eg. the PCI bus, processor bus and
internal paths, and so on...

But where do you draw the line?

Gordon
