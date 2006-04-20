From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: Soft lockup with 2.6.17-rc1 on amd64
Date: Thu, 20 Apr 2006 13:05:01 +0200
Message-ID: <20060420110500.GA4157@samfundet.no>
References: <20060420024134.GA2798@samfundet.no> <17479.2316.814366.755975@cse.unsw.edu.au> <17479.11207.24738.466684@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17479.11207.24738.466684@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 20, 2006 at 04:35:51PM +1000, Neil Brown wrote:
> However: could you please  give me details of dm-[0-3]?  Particularly
> how big they are, but also what sort of dm target and what underlying
> devices.

They're set up by EVMS, and point to partitions on a normal disk. They're
about 250GB each.

> Also, what is the clock speed of your processor - I assume it is not
> just hyper-threading but actually has two independent core?

pannekake:~# grep MHz /proc/cpuinfo 
cpu MHz         : 2009.274
cpu MHz         : 2009.274

And yes, it's a real dual-core; I don't know any amd64 machines with
hyperthreading.

Note that I'm on serial console; that might be oddly related somehow?

/* Steinar */
-- 
Homepage: http://www.sesse.net/

