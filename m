From: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: EIO AP-1680 ATA133 RAID PCI Controller
Date: Tue, 11 Feb 2003 10:55:30 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.04.10302111052491.17292-100000@12-228-21-100.client.attbi.com>
References: <1044998190.12695.3.camel@gregdell>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1044998190.12695.3.camel@gregdell>
To: Gregory Leblanc <gleblanc@linuxweasel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11 Feb 2003, Gregory Leblanc wrote:
> While the performance of RAID 5 using software RAID is generally far
> superior to that provided by hardware RAID, host CPU usage can be
> -quite- high in high-load situations.  The benchmarks recently posted
> had cpu usage numbers at over 90% on most sequeential writes and reads.

But what is the CPU usage per MB/sec?  If software RAID5 was just as efficient
as hardware RAID5, except twice as fast, you would expect the CPU usage to be
double.

