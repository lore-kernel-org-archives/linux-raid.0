From: TJ <systemloc@earthlink.net>
Subject: Re: Looking for the cause of poor I/O performance
Date: Sun, 5 Dec 2004 10:14:30 -0500
Message-ID: <200412051014.30762.systemloc@earthlink.net>
References: <200412050216.iB52Gk923982@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412050216.iB52Gk923982@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 04 December 2004 09:16 pm, Guy wrote:
> Ok, now I am confused.
> I have a second Dell Precision Workstation 410:
>
> System A:
> CPUs	2 X 500 MHz
> RAM	4 X 128 Meg SDRAM
> Bus	100 MHz
> Timing buffer-cache reads:   128 MB in  0.87 seconds =147.13 MB/sec
>
> System B:
> CPUs	2 X 1000 MHz
> RAM	4 X 256 Meg Registered SDRAM
> Bus	100 MHz
> Timing buffer-cache reads:   524 MB in  2.00 seconds =262.00 MB/sec
>
> Why is system B almost twice as fast?
> Is registered RAM faster?
> I know the CPU speed is twice as fast, but the system bus is still 100 MHz.

Memory interleaving, perhaps? Registered ram has higher latency. It's possible 
that the machine is made to do memory interleaving with ECC ram to boost 
performance.. 

TJ Harrell
