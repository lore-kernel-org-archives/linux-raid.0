From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Move md raid5 from intel to sparc?
Date: Fri, 13 Jun 2003 15:29:04 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16105.24864.782182.63593@gargle.gargle.HOWL>
References: <3EE74472.9010505@geodev.com>
	<1055350640.1929.28.camel@langvan.austin.ibm.com>
	<3EE76EDA.1060000@geodev.com>
	<1055359074.1929.70.camel@langvan.austin.ibm.com>
	<00c701c33050$00057360$7b07a8c0@pluto>
	<1055361035.1930.81.camel@langvan.austin.ibm.com>
	<3EE78D29.2EEFA36A@SteelEye.com>
	<3EE89211.4030805@geodev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Matthew Mitchell on Thursday June 12
To: Matthew Mitchell <matthew@geodev.com>
Cc: Paul Clements <Paul.Clements@SteelEye.com>, Mike Tran <mhtran@us.ibm.com>, 3tcdgwg3 <3tcdgwg3@prodigy.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 12, matthew@geodev.com wrote:
> Paul Clements wrote:
> > Mike Tran wrote:
> > 
> >>On Wed, 2003-06-11 at 14:31, 3tcdgwg3 wrote:
> >>
> >>>I am doing a sparc thingin. I have to build
> >>>the disk images on a x86 system, and move the
> >>>disk to my sparc, for debug/test.  Everhting works
> >>>fine, except the MD's SB.  I tweaked a bit on MD
> >>>driver, then everything is good.  I would think that
> >>>MD should take care the SB format in next release.
> >>>
> >>
> >>This work should start from the MD kernel driver.  That is the MD driver
> >>has to write the SB in one known format and converts the SB to the
> >>native cpu after reading it from disk.  Next, the MD tools (mdadm,
> >>mdreconf, etc.) will need to follow.
> >>
> >>Neil B, Do you have this work item in mind?
> > 
> > 
> > Neil's new version 1 superblock, which is present in the 2.5 kernel,
> > addresses the byte ordering issues that are a problem in the current
> > 0.90 superblock of the 2.4 md driver.
> > The new superblock code stores all numeric values in little endian
> > on-disk and converts them to CPU endianness before use.
> 
> Any possibility of a backport?  If it's not too hairy I don't mind 
> attempting it myself, but I haven't even looked at md in 2.5.
> 

A back-port is really out of the question.
There was massive changes to md in 2.5 in order to prepare the code
for this (and other) extensions.
In 2.4, knowledge of the superblock layout is spread throughout the
code.  In 2.5 it is localised, making multiple superblock formats a
possibility.

If you wanted something like this in 2.4, you would need to get the
code that reads the superblock to look at it, determine what format it
was, and then translate it inplace to the required format (e.g. do
byte swapping).  Then when writing out you would need to translate it
to the original format before writing.
It is certainly do-able, but it wouldn't be a back-port.  It would be
writing brand new code to do a vaguely similar task in a completely
different way.

And to answer the question:
> >>Neil B, Do you have this work item in mind?

No.  I am not really interested in anything other than bug fixes for
2.4 md code.  If someone else wants to write some improvements, I'm
happy to review them and sponsor them into the kernel, but I'm not
interested in pushing anything myself.

NeilBrown
