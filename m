From: Nat Makarevitch <nat@makarevitch.org>
Subject: Re: the '--setra 65536' mistery, analysis and WTF?
Date: Fri, 21 Mar 2008 15:12:13 +0000 (UTC)
Message-ID: <loom.20080321T150605-207@post.gmane.org>
References: <18382.54925.354731.996508@tree.ty.sabi.co.UK> <18400.13488.178782.156775@tree.ty.sabi.co.uk> <18402.7274.174605.611654@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Grandi <pg_lxra <at> lxra.for.sabi.co.UK> writes:

> this seems to indicate that not only the Linux block IO subsystems issues
> IO operations in multiples of the read-ahead size, but does so at a fixed
> number of times per second that is a multiple of 10.

Is it the case with a classic controller (not a 3ware?)

http://forums.storagereview.net/index.php?showtopic=25923 may be of
interest.

> Which lead me to think about elevators, which was also mentioned
> in some recent (and otherwise less interesting :->)

Sorry, I don't understand this.

> It still seems the case to me that the block IO subsystem
> structures IO in lots of read-ahead sectors

Isn't it specific to the 3ware driver and/or hardware, even in
SINGLE (JBOD) mode?

> Finally, I am getting a bit skeptical about elevators in general;

> several tests show no-elevator as not being significantly worse
> and sometimes better than any elevator

Isn't it specific to intelligent controllers?


