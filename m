From: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Subject: Re: [Fwd: "Enhanced" MD code avaible for review]
Date: Wed, 17 Mar 2004 11:54:05 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2241002704.1079549645@aslan.btc.adaptec.com>
References: <405899E8.8070806@pobox.com> <20040317183756.GA23667@lst.de>
Reply-To: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040317183756.GA23667@lst.de>
Content-Disposition: inline
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Wed, Mar 17, 2004 at 01:33:12PM -0500, Jeff Garzik wrote:
>> A patch to fs/partitions/check.c is also required for this
>> release to function correctly:

Hmm.  I don't think Jeff wrote that.

>> http://people.freebsd.org/~gibbs/linux/SRC/md_announce_whole_device.diff
> 
> Vetoed.  Kernel-level autodetection code is deprecated already, don't
> even try to add functionality for it.

So do you speak for the entire community in expressing that auto-detection
will never make sense in the kernel?  Are you completely unwilling to
entertain even a minor discussion on the topic for those of us that don't
understand the concerns the community has in supporting it?

> As for the actual code please post diffs instead of tarballs.

If you look at the posted code, you'll see that diffs make little
sense at this point.  But I will generate diffs in addition
to the tarball with the next release later this week.

--
Justin

