From: Tejun Heo <htejun@gmail.com>
Subject: Re: Anybody know about nforce4 SATA II hot swapping + linux raid?
Date: Sat, 08 Oct 2005 16:41:42 +0900
Message-ID: <43477836.6020107@gmail.com>
References: <200510071111.46788.andrew@walrond.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750786AbVJHHlv@vger.kernel.org>
In-Reply-To: <200510071111.46788.andrew@walrond.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Andrew Walrond wrote:
> I need to deploy some very resilient servers with hot swapable drives.
> 
> I always used dac960 based hardware raid for hot swapping in the past, but 
> sata drives are so cheap compared to scsi that I'm considering the Tyan GT24 
> server with 4 hot swappable SATA II drives (nforce4 pro controller)
> 
> 	http://www.tyan.com/products/html/gt24b2891.html
> 
> Before I place an order, I need to know whether sata II hot swapping is up to 
> scratch in the linux kernel, and whether it works nicely with linux software 
> raid (which I already use/am familiar with).
> 
> Any knowledge greatfully accepted :)
> 
> Andrew Walrond

  Unfortunately, SATA hoplug support is not ready yet.  Preliminary 
works are in progress though and it will happen.  Of course, I have 
absolutely no idea how distant the future is. :-)

  One more thing to note is that nVidia cannot supply information 
regarding SATA part (I think network part too) of its chipset to open 
source community.  So, it is possible that not everything goes smoothly 
with nf4 hotplug support even after other pieces come together eventually.

  If you're looking for stability/resilience for production machine, 
IMHO libata isn't still quite ready.

  libata maintainer Jeff Garzik maintains the following status page you 
might be interested in.

http://linux.yyz.us/sata/

-- 
tejun
