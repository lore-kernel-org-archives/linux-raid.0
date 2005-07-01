From: "John Madden" <jmadden@ivytech.edu>
Subject: Re: raid0 low performance
Date: Thu, 30 Jun 2005 21:57:40 -0500 (EST)
Message-ID: <50513.168.91.5.7.1120186660.squirrel@localhost>
References: <1120184148.5521.21.camel@localhost.localdomain>
    <42C4AA31.8040307@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42C4AA31.8040307@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: mingz@ele.uri.edu, Linux RAID <linux-raid@vger.kernel.org>, Tyler <pml@dtbb.net>
List-Id: linux-raid.ids

> useage during the tests?  even PCI 32bit, 33mhz should be able to hit
> 133 Mbytes per second I believe.  What are you writing *from* ? dev/zero

~127MB/s is the theoretical bus speed of PCI/33.  Actual throughput is much less
than that, of course.

But you're not on a 33MHz bus, you should be at at least 66MHz (and info in /proc
should tell you).  Given the lack of performance increase though, I'm guessing
you're either pegging the bus or the CPU, not yet the throughput of the kernel
itself.  Does the program block in disk wait when running?

John

(Go Rams)



-- 
John Madden
UNIX Systems Engineer
Ivy Tech Community College of Indiana
jmadden@ivytech.edu

