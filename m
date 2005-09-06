From: Dan Williams <dan.j.williams@gmail.com>
Subject: Accelerating Linux software raid
Date: Tue, 6 Sep 2005 11:24:24 -0700
Message-ID: <e9c3a7c2050906112410dc1d16@mail.gmail.com>
Reply-To: dan.j.williams@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dave.jiang@gmail.com
List-Id: linux-raid.ids

Hello,

I am writing to the list to gauge interest for a modification of the
md driver that allows it to take advantage of raid acceleration
hardware.  I/O processors like the Intel IOP333
(http://www.intel.com/design/iio/docs/iop333.htm) contain an xor
engine for raid5 and raid6 calculations, but currently the md driver
does not fully utilize these resources.

Dave Jiang wrote a driver that re-routed calls to xor_block() to use
the hardware xor engine.  However, from my understating, he found that
performance did not improve, due to the fact that md deals in
PAGE_SIZE (4K) blocks.  At 4K the overhead of setting up the engine
destroys any performance advantage over a software xor.  The goal of
the modification would be to enable md to understand the capacity of
the platform's xor resources and allow it to issue optimal block
sizes.

The first question is whether a solution along these lines would be
valued by the community?  The effort is non-trivial.

Assuming a positive response I will solicit implementation ideas and
acceptance criteria from the list.

Thank you for your consideration,

Dan
