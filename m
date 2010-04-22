From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Subject: Re: Compile error with 2.6.34-rc5+
Date: Thu, 22 Apr 2010 16:27:21 +0200
Message-ID: <201004221627.23600.s.L-H@gmx.de>
References: <20100422134550.GA4886@gibson.comsick.at>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100422134550.GA4886@gibson.comsick.at>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guntsche <mike@it-loops.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

On Thursday 22 April 2010, Michael Guntsche wrote:
> Hi,
> 
> While compiling current git HEAD on one of my boxes I got a compile error.
> Current head is at 1ef6ce7a340f9ed139a73147ff9cf7ad56889414 and the
> compile error is
> 
> drivers/built-in.o: In function `raid5_compute_sector':
> raid5.c:(.text+0x85a36): undefined reference to `__umoddi3'
> raid5.c:(.text+0x85a67): undefined reference to `__umoddi3'
> raid5.c:(.text+0x85a9c): undefined reference to `__umoddi3'
> raid5.c:(.text+0x85acd): undefined reference to `__umoddi3'
> raid5.c:(.text+0x85b23): undefined reference to `__umoddi3'
> drivers/built-in.o:raid5.c:(.text+0x85b54): more undefined references to
> `__umoddi3' follow

This seems to be the same problem as 
	http://lkml.indiana.edu/hypermail/linux/kernel/1004.2/01814.html
fixed in
	http://lkml.indiana.edu/hypermail/linux/kernel/1004.2/01816.html

> The config file was taken straight from a -rc4 kernel and make oldconfig
> was run before that. 
> This runs on/is compiled for a 32bit Pentium IV system so I wonder why umoddi3 is being used.
> 
> Kind regards,
> Michael

Regards
	Stefan Lippers-Hollmann
