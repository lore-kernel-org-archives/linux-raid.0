From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Move md raid5 from intel to sparc?
Date: Wed, 11 Jun 2003 16:12:25 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE78D29.2EEFA36A@SteelEye.com>
References: <3EE74472.9010505@geodev.com>
		 <1055350640.1929.28.camel@langvan.austin.ibm.com>
		 <3EE76EDA.1060000@geodev.com>
		 <1055359074.1929.70.camel@langvan.austin.ibm.com>
		 <00c701c33050$00057360$7b07a8c0@pluto> <1055361035.1930.81.camel@langvan.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mike Tran <mhtran@us.ibm.com>
Cc: 3tcdgwg3 <3tcdgwg3@prodigy.net>, Matthew Mitchell <matthew@geodev.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Tran wrote:
> 
> On Wed, 2003-06-11 at 14:31, 3tcdgwg3 wrote:
> > I am doing a sparc thingin. I have to build
> > the disk images on a x86 system, and move the
> > disk to my sparc, for debug/test.  Everhting works
> > fine, except the MD's SB.  I tweaked a bit on MD
> > driver, then everything is good.  I would think that
> > MD should take care the SB format in next release.
> >
> 
> This work should start from the MD kernel driver.  That is the MD driver
> has to write the SB in one known format and converts the SB to the
> native cpu after reading it from disk.  Next, the MD tools (mdadm,
> mdreconf, etc.) will need to follow.
> 
> Neil B, Do you have this work item in mind?

Neil's new version 1 superblock, which is present in the 2.5 kernel,
addresses the byte ordering issues that are a problem in the current
0.90 superblock of the 2.4 md driver.
The new superblock code stores all numeric values in little endian
on-disk and converts them to CPU endianness before use.

--
Paul
