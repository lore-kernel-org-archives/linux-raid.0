From: Ezra Nugroho <ezran@goshen.edu>
Subject: RE: RAID 5 performance problems
Date: 04 Apr 2003 09:39:09 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1049467150.30062.6215.camel@ezran.goshen.edu>
References: <73300040777B0F44B8CE29C87A0782E101FA988F@exchange.explainerdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73300040777B0F44B8CE29C87A0782E101FA988F@exchange.explainerdc.com>
To: Jonathan Vardy <jonathan@explainerdc.com>
Cc: "Peter L. Ashford" <ashford@sdsc.edu>, Jonathan Vardy <jonathanv@explainerdc.com>, Stephan van Hienen <raid@a2000.nu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> hdc: host protected area => 1
> hdc: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
> UDMA(33)


Your hdc is still running at udma(33). This is also part of the raid,
right? This will slow the whole thing down since in raid 5 write is done
to all disks simultaneously. Before the system finishes writing to the
slow drive, the write is not done yet.



