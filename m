From: Felipe Alfaro Solana <felipe_alfaro@linuxmail.org>
Subject: Re: RAID 5 performance problems
Date: 03 Apr 2003 23:06:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1049403984.1175.2.camel@teapot.felipe-alfaro.com>
References: <73300040777B0F44B8CE29C87A0782E101FA97B2@exchange.explainerdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <73300040777B0F44B8CE29C87A0782E101FA97B2@exchange.explainerdc.com>
To: Jonathan Vardy <jonathan@explainerdc.com>
Cc: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2003-04-03 at 17:45, Jonathan Vardy wrote:
> I'm having trouble with getting the right performance out of my software
> raid 5 system. I've installed Red Hat 9.0 with kernel 2.4.20 compiled
> myself to match my harware (had the same problem with the default
> kernel). When I test the raid device's speed using 'hdparm -Tt /dev/hdx'
> I get this:
> /dev/md0:
> Timing buffer-cache reads:   128 MB in  1.14 seconds =112.28 MB/sec
> Timing buffered disk reads:  64 MB in  2.39 seconds = 26.78 MB/sec

Well, if I'm not wrong, you're testing physical, individual drives, not
the RAID5, combined, logical volume. So, your values are pretty normal.

________________________________________________________________________
Linux Registered User #287198
