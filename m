From: danci@agenda.si
Subject: Re: IDE Soft-RAID5, poor performance (suspected)
Date: Thu, 13 Mar 2003 19:13:14 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303131905320.26504-100000@duplo.agenda.si>
References: <20030313150047.ALLYOURBASEAREBELONGTOUS.C10081@bla.fasel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030313150047.ALLYOURBASEAREBELONGTOUS.C10081@bla.fasel.org>
To: Wolfram Schlich <lists@schlich.org>
Cc: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 13 Mar 2003, Wolfram Schlich wrote:

> Overall I'm not very satisfied with the current situation, as you'd
> expect ;-) The hardware *should* be capable of doing much better, I
> believe.

First of all, check 'cat /proc/ide/hdX/settings' if the disks are set to
their maximum speed. There should be a line 'current_speed' and it should
read 69 or 70.

In my system, using Promise Ultra100 and Ultra133TX2, the disks are set to
speed 34 by default. They do have DMA on, however.

So using 'hdparm -X69' helps a lot in my case. The only problem is that if
the disks are busy (resyncing the RAID array), I cannot safely use hdparm
as it sometimes gets stuck and blocks IDE completely.

> I'd be pleased to give more details as needed.
> Should I run any tiobench/tiotest or bonnie++ benchmarks?

Yes, you should use benchmarks like that and you should limit the amount
of memory to prevent caching (or use very large test files which take a
lot of time).

I usually use 'mem=32M' and then use some 256MB or 512MB test files with
tiobench...

  D.


