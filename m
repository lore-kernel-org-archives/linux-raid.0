From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: Move md raid5 from intel to sparc?
Date: 11 Jun 2003 14:50:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1055361035.1930.81.camel@langvan.austin.ibm.com>
References: <3EE74472.9010505@geodev.com>
	 <1055350640.1929.28.camel@langvan.austin.ibm.com>
	 <3EE76EDA.1060000@geodev.com>
	 <1055359074.1929.70.camel@langvan.austin.ibm.com>
	 <00c701c33050$00057360$7b07a8c0@pluto>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00c701c33050$00057360$7b07a8c0@pluto>
To: 3tcdgwg3 <3tcdgwg3@prodigy.net>
Cc: Matthew Mitchell <matthew@geodev.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2003-06-11 at 14:31, 3tcdgwg3 wrote:
> I am doing a sparc thingin. I have to build
> the disk images on a x86 system, and move the
> disk to my sparc, for debug/test.  Everhting works
> fine, except the MD's SB.  I tweaked a bit on MD
> driver, then everything is good.  I would think that
> MD should take care the SB format in next release.
> 

This work should start from the MD kernel driver.  That is the MD driver
has to write the SB in one known format and converts the SB to the
native cpu after reading it from disk.  Next, the MD tools (mdadm,
mdreconf, etc.) will need to follow.

Neil B, Do you have this work item in mind?

-Mike Tran

