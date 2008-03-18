From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: the '--setra 65536' mistery, analysis and WTF?
Date: Tue, 18 Mar 2008 21:31:28 +0000
Message-ID: <18400.13488.178782.156775@tree.ty.sabi.co.uk>
References: <18382.54925.354731.996508@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18382.54925.354731.996508@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> * Most revealingly, when I used values of read ahead which
>   were powers of 10, the numbers of block/s reported by
>   'vmstat 1' was also a multiple of that power of 10.

Most disturbingly, this seems to indicate that not only the
Linux block IO subsystems issues IO operations in multiples of
the read-ahead size, but does so at a fixed number of times per
second that is a multiple of 10.

Which leads me to suspect that the queueing of IO requests on
the driver's queue, or even the issuing of requests from the
driver to the device, may end up being driven by the clock tick
interrupt frequency, not the device interrupt frequency.

Eventually in my copious free time :-) I shall put in a few
traces to see what is the timewise flow of read requests...

[ ... ]
