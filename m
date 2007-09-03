From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: very very strange simultaneous RAID resync on sep 2, 01:06 CEST
 (+2)
Date: Mon, 3 Sep 2007 05:39:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0709030538550.6070@p34.internal.lan>
References: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755496AbXICJkA@vger.kernel.org>
In-Reply-To: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
Sender: linux-kernel-owner@vger.kernel.org
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 3 Sep 2007, Xavier Bestel wrote:

> Hi,
>
> I have a server running with RAID5 disks, under debian/stable, kernel
> 2.6.18-5-686. Yesterday the RAID resync'd for no apparent reason,
> without even mdamd sending a mail to warn about that:

This is normal, you probably are running Debian(?) or a Debian-derived
distribution and the checkarray script runs once a month by default I
believe.

Justin.
