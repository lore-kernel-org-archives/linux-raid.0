From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata
 PCI-e cards)?
Date: Sat, 10 May 2008 10:15:29 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805101014200.1844@p34.internal.lan>
References: <181601c8b2a7$12fe0489$5209f40a@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <181601c8b2a7$12fe0489$5209f40a@exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 10 May 2008, David Lethe wrote:

> You can't generalize whether HW RAID is faster or slower than SW RAID.
> I/O mix, CPU speed, bus type, RAM, file system type/config, queue depth, specific RAID card, drivers, firmware all have significant impact. Even with info you supply, one can easily model config where either RAID architecture will outperform the other.
>
> if performance is vital for you on a certain pc config, then tune everything for HW RAID, test, rebuild for SW RAID, and compare.  Don't forget to yank power to a disk while testing both to see how each work under stress, as well as when consistency checks run.

.. What I meant was is JBOD using a single card with 16 ports faster than
using JBOD with multiple PCI-e SATA cards?

Justin.


