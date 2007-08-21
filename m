From: Neil Brown <neilb@suse.de>
Subject: Re: Linear RAID hot grow
Date: Tue, 21 Aug 2007 15:22:53 +1000
Message-ID: <18122.30381.180760.497094@notabene.brown>
References: <d0e8f6370708201435s33547f5agfdf44b384c9489f2@mail.gmail.com>
	<Pine.LNX.4.64.0708201745170.16270@p34.internal.lan>
	<d0e8f6370708201455i37e21a4mf2dbf8ecb0133cb0@mail.gmail.com>
	<d0e8f6370708201521g15974927lbfb91c03cb4428fe@mail.gmail.com>
	<18122.9211.998879.841835@notabene.brown>
	<d0e8f6370708202018p7bd20122o56c577507320c84a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dat Chu on Monday August 20
Sender: linux-raid-owner@vger.kernel.org
To: Dat Chu <dattanchu@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 20, dattanchu@gmail.com wrote:
> I am currently running 2.6.22.1 kernel with mdadm version 2.6.2.

That combination should work.

> 
> When I try to run
> mdadm --grow /dev/md2 --add /dev/sdd1
> mdadm: Cannot add new disk to this array

Odd.  I tried add a drive to a three-drive linear array and it
worked, though my drives are somewhat smaller than yours - that
shouldn't matter though.

Do you get any kernel messages at the time when you try to add?
  dmesg | tail -20

NeilBrown
