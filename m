From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Sat, 13 Jan 2007 23:23:23 +0000
Message-ID: <eobpl9$df3$1@sea.gmane.org>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>	 <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>	 <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu> <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com> <45A917B8.2060706@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45A917B8.2060706@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
>
> There have been several recent threads on the list regarding software
> RAID-5 performance. The reference might be updated to reflect the poor
> write performance of RAID-5 until/unless significant tuning is done.
> Read that as tuning obscure parameters and throwing a lot of memory into
> stripe cache. The reasons for hardware RAID should include "performance
> of RAID-5 writes is usually much better than software RAID-5 with
> default tuning.

Could you point me at a source of documentation describing how to
perform such tuning?

Specifically, I have 8x500GB WD STAT drives on a Supermicro PCI-X 8-port
SATA card configured as a single RAID6 array (~3TB available space)

Thanks,

R.

