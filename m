From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Move md raid5 from intel to sparc?
Date: Thu, 12 Jun 2003 11:04:40 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE89688.71AFFAB6@SteelEye.com>
References: <3EE74472.9010505@geodev.com>		 <1055350640.1929.28.camel@langvan.austin.ibm.com>		 <3EE76EDA.1060000@geodev.com>		 <1055359074.1929.70.camel@langvan.austin.ibm.com>		 <00c701c33050$00057360$7b07a8c0@pluto> <1055361035.1930.81.camel@langvan.austin.ibm.com> <3EE78D29.2EEFA36A@SteelEye.com> <3EE89211.4030805@geodev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Matthew Mitchell <matthew@geodev.com>
Cc: Mike Tran <mhtran@us.ibm.com>, 3tcdgwg3 <3tcdgwg3@prodigy.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthew Mitchell wrote:

> Paul Clements wrote:

> > Neil's new version 1 superblock, which is present in the 2.5 kernel,
> > addresses the byte ordering issues that are a problem in the current
> > 0.90 superblock of the 2.4 md driver.
> > The new superblock code stores all numeric values in little endian
> > on-disk and converts them to CPU endianness before use.

> Any possibility of a backport?  If it's not too hairy I don't mind
> attempting it myself, but I haven't even looked at md in 2.5.

If you just wanted to rip out the superblock code from the 2.5 md.c and
use that in 2.4, it probably wouldn't be too bad. The superblock
handling code has been improved and modularized quite a bit, and the md
driver can now handle various different superblock formats.

--
Paul
