From: Neil Brown <neilb@suse.de>
Subject: Re: only 4 spares and no access to my data
Date: Tue, 18 Jul 2006 12:17:03 +1000
Message-ID: <17596.17567.790363.193434@cse.unsw.edu.au>
References: <loom.20060709T205013-455@post.gmane.org>
	<62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>
	<loom.20060710T095111-275@post.gmane.org>
	<44B213CD.5010907@idgmail.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Henrik Holst on Monday July 10
Sender: linux-raid-owner@vger.kernel.org
To: Henrik Holst <henrik.holst@idgmail.se>
Cc: Karl Voit <neww@Karl-Voit.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 10, henrik.holst@idgmail.se wrote:
> Karl Voit wrote:
> [snip]
> > Well this is because of the false(?) superblocks of sda-sdd in comparison to
> > sda1 to sdd1.
> 
> I don't understand this. Do you have more than a single partion on sda?
> Is sda1 occupying the entire disk? since the superblock is the /last/
> "128Kb" (I'm assuming 128*1024 bytes) the superblocks should be one and
> the same.

Not exactly.
The superblock locations for sda and sda1 can only be 'one and the
same' if sda1 is at an offset in sda which is a multiple of 64K, and
if sda1 ends near the end of sda.  This certainly can happen, but it
is by no means certain.

For this reason, version-1 superblocks record the offset of the
superblock in the device so that if a superblock is written to sda1
and then read from sda, it will look wrong (wrong offset) and so will
be ignored (no valid superblock here).

NeilBrown
