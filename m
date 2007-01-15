From: Gordon Henderson <gordon@drogon.net>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Mon, 15 Jan 2007 21:32:20 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0701152131370.18484@lion.drogon.net>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>
 <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>
 <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu>
 <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com>
 <45A917B8.2060706@tmr.com> <eobpl9$df3$1@sea.gmane.org> <45AB9DC6.50509@tmr.com>
 <45ABAA43.2000902@robinbowes.com> <Pine.LNX.4.64.0701151321190.16472@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701151321190.16472@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Jan 2007, dean gaudet wrote:

> you can also run monthly "checks"...
>
> echo check >/sys/block/mdX/md/sync_action
>
> it'll read the entire array (parity included) and correct read errors as
> they're discovered.

A-Ha ... I've not been keeping up with the list for a bit - what's the 
minimum kernel version for this to work?

Cheers,

Gordon
