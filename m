From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Observation about RAID 0 performance in 2.6.25 kernel
Date: Tue, 9 Sep 2008 10:58:43 +0100
Message-ID: <18630.18643.702805.666924@tree.ty.sabi.co.uk>
References: <48C52206.9060101@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48C52206.9060101@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> When comparing the 2.6.20.15 kernel with the 2.6.25 kernel,
> I have noticed that: For the underlying 3ware devices, all
> benchmarks -- dd, bonnie++, [ ... ] I get about an 8 percent
> DROP in READING performance with the 2.6.25 kernel.

It seems particularly dumb to avoid giving absolute numbers
here, but yet it is sort of expected from someone thinking that
"READING performance" and benchmark results are the same thing
(expecially someone who uses bonnie++ and does not give the
exact parameters used too).

> Does anybody have any insights into what might be going on
> here? Does Linux software RAID need to be configured
> differently in 2.6.25 to NOT lose READ performance? [ ... ]

A difference of 10% plus or minus is insignificant and well
within measurement error and happenstance. Some people ascribe
significance to such variations, but that is due to lack of
understanding, as if a complex and often poorly designed IO
subsystem that is meant to distribute iops across several
devices had deterministic performance on a multitasking system
with load spread over several CPUs. Variations like that can
depend on a timing bug being fixed in an unrelated driver.

In particular as to MD read performance, it has been reported
quite a few times in this mailing list that it seems to depend
to a very large extent on the precise value of the block device
read ahead, with variations of *several times*, and with best
benchmark results achieved by laughably (also because most
likely counterproductive) large values of that parameter.
Worrying about 8% is pointless and clueless.
