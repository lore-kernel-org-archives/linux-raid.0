From: "Jonathan Vardy" <jonathan@explainerdc.com>
Subject: RE: RAID 5 performance problems
Date: Fri, 4 Apr 2003 17:05:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <73300040777B0F44B8CE29C87A0782E101FA98E7@exchange.explainerdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
content-class: urn:content-classes:message
To: Ezra Nugroho <ezran@goshen.edu>
Cc: "Peter L. Ashford" <ashford@sdsc.edu>, Jonathan Vardy <jonathanv@explainerdc.com>, Stephan van Hienen <raid@a2000.nu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> From: Ezra Nugroho [mailto:ezran@goshen.edu] 

> Your hdc is still running at udma(33). This is also part of the raid,
> right? This will slow the whole thing down since in raid 5 
> write is done
> to all disks simultaneously. Before the system finishes writing to the
> slow drive, the write is not done yet.

 > Your hdc is still running at udma(33). This is also part of the raid,
> right? This will slow the whole thing down since in raid 5 
> write is done
> to all disks simultaneously. Before the system finishes writing to the
> slow drive, the write is not done yet.

This should not cripple the performance to what I get. My friend had
6x80GB 5400rpm drives with two of those on udma33 and four on udma66 and
he managed 80MB/sec (dual 500Mhz)

Jonathan
