From: Danilo Godec <danci@agenda.si>
Subject: Re: Fw: DriveReady SeekComplete problems
Date: Mon, 13 May 2002 08:22:28 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205130817280.20245-100000@duplo.agenda.si>
References: <003401c1fa38$6e3ba600$050010ac@niunia.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003401c1fa38$6e3ba600$050010ac@niunia.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 12 May 2002, Artur Jasowicz wrote:

> As long as DMA was on, I couldn't complete syncing array after configuring
> it. Contstant lockups. After I did hdparm -d 0 /dev/hd[e,g,i,k] the arrays
> synced and seem to be working correctly now. I need to develop a way of
> checking for data corruption. Of course the price is the speed. With DMA on
> I was getting 2000K/s syncing speed. without DMA - 800K. I am running plain

I'm used to sync speeds above 20000K/s these days. With DMA, of course.

> Is your CPU usage also close to 100% when using RAID?

Nope, not even close. But having the DMA turned off is certanly a way to
put a lot of load on your CPU(s).

It seems that either the HPTs have a design flaw or the driver is not
fully supporting them.


  D.


