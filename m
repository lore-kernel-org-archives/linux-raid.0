From: Andreas Kahnt <aka@aka.coware.de>
Subject: Re: 3ware 7500-8 controller, hardware or software raid, kernel crash
Date: Sun, 4 May 2003 22:25:04 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0305042218040.19228-100000@aka.coware.de>
References: <Pine.LNX.4.44.0305040947540.11386-100000@portal.bppiac.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0305040947540.11386-100000@portal.bppiac.hu>
To: Farkas Levente <lfarkas@bnap.hu>
Cc: linux-raid@vger.kernel.org, ataraid-list@redhat.com, Adam Radford <aradford@3WARE.com>
List-Id: linux-raid.ids

Hi,

> after we format it, start to copy back the data (about 250GB) from nfs.
> after about 2 minutes the kernel crash with some kind of io error on the
> 3ware controller. unfortunately we don't have time to write down the
> kernel's error message since this is one of our production enviroment
> server. what's more I wouldn't like to buy more such card to play with if
> it's not  well functional. you can read the kernel log after that crash at
> the end of this mail.

We had the same problem using SuSE-8.0/2.4.18. We 'solved' the problem using
6+1 - Raid-5 and removed the 8. disk. Now the last disk is a cold spare ;-).
This work well for a couple of months uptime.

aka

Andreas.Kahnt@coware.de

