From: Neil Brown <neilb@suse.de>
Subject: Re: Linear RAID hot grow
Date: Tue, 21 Aug 2007 09:30:03 +1000
Message-ID: <18122.9211.998879.841835@notabene.brown>
References: <d0e8f6370708201435s33547f5agfdf44b384c9489f2@mail.gmail.com>
	<Pine.LNX.4.64.0708201745170.16270@p34.internal.lan>
	<d0e8f6370708201455i37e21a4mf2dbf8ecb0133cb0@mail.gmail.com>
	<d0e8f6370708201521g15974927lbfb91c03cb4428fe@mail.gmail.com>
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
> The links on Neil's website to those patches are no longer there. When
> I try to hot grow a linear raid, it says that hot grow for linear raid
> is not supported.

What is the exact error message?
What kernel are you using?

hot-grow for linear does work with recent kernels and mdadm - it is
part of my test suite.
  mdadm --grow /dev/md-linear --add /dev/new-device

NeilBrown
