From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: about the speed /  XP RAID vs md
Date: Thu, 3 Apr 2003 20:03:01 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16012.1749.539480.146944@notabene.cse.unsw.edu.au>
References: <3E87FC9D.5010605@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Farkas Levente on Monday March 31
To: Farkas Levente <lfarkas@bnap.hu>
Cc: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday March 31, lfarkas@bnap.hu wrote:
> hi,
> I'm just read
> http://www.hpl.hp.com/techreports/2002/HPL-2002-352.pdf
> may be it's worth to read. an intersting thing about performance (XP, 
> their user-space raid and than comes kernel raid).

It seems from the article, though they don't explicitly say, that they
are doing their timing by openning  /dev/mdX, and reading/writing on
that.
I have found myself that that isn't very fast on Linux.
Creating a filesystem on the device, and accessing a file on that
filesystem is much faster despite the filesysterm overhead.

And for myself, I am much more interested in performance of a
filesystem than performance of direct IO on /dev/mdX


Also, the raid0 layer in Linux is very thin.  There is now way it can
be adding noticable overhead.  If there are any performance problems
(and there probably are), they will be in either the block device
layer or the memory management layer.
And indeed, lots of work has been done in both of these layers in 2.5
so I have no doubt that 2.6 will get very close to raw device speeds
for raid0.

I think the results are very preliminary and that the authors need to
do a lot mo reexploring to understand exactly what is going on, as
indeed that suggest they will do.

NeilBrown
