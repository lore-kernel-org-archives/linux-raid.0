From: TJ <systemloc@earthlink.net>
Subject: Re: Looking for the cause of poor I/O performance
Date: Fri, 3 Dec 2004 02:12:38 -0500
Message-ID: <200412030212.38288.systemloc@earthlink.net>
References: <200412021138.17311.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412021138.17311.systemloc@earthlink.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's some info on the VIA chipset problem..

Here's the article that really cracked the VIA chipset problem. It seems there 
are problems with the default timings and latency settings:
http://www.tecchannel.de/hardware/817/8.html

This guy, independant of VIA, came up with some chipset register tweaks to 
improve performance of the PCI bus for the broken VIAs.
http://www.georgebreese.com/net/software/
http://www.georgebreese.com/net/software/readmes/vlatency_v020b21_readme.HTM
http://adsl.cutw.net/dlink-dsl200-via.html


The linux kernel sources indicate a problem with VIA chipsets too, but the 
author doesn't have it fixed to his satisfaction, obviously.

From linux-2.6.7/drivers/pci/quirks.c:

/*  The VIA VP2/VP3/MVP3 seem to have some 'features'. There may be a 
workaround
    but VIA don't answer queries. If you happen to have good contacts at VIA
    ask them for me please -- Alan

    This appears to be BIOS not version dependent. So presumably there is a
    chipset level fix */


I'm wondering if I could get the tweaks that George Breese has made and 
implement them in linux. If I could, how would I benchmark to check for 
improvement? Bonnie? hdparm -tT? Some PCI benchmark?

TJ Harrell
