From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Performance difference between two raid0 arrays on same drives?
Date: Sat, 12 Jul 2003 16:20:00 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0307121548180.6220-100000@unicorn.drogon.net>
References: <200307121537.33889.michel@ket.kth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200307121537.33889.michel@ket.kth.se>
To: Michel Bellais <michel@ket.kth.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 12 Jul 2003, Michel Bellais wrote:

> You're right, I thought about it too, but the fastest array is built with
> partitions closer to the centre of the disk, so it should be the slowest
> indeed.
> The disks are big (180 Gb), the partitions represent less than 10% of it and
> follow each others.  It cannot explain 30% difference in performance.
>
> I have created a third array on the disk, which is a copy of the slowest
> array. It has the same content. This last array shows much better performance
> than the original. And it is even closer to the centre...
> So i really don't understand.

Just a thought: What if modern disk manufacturers write from the inside
out, rather than traditionally from the outside in?

CD's are read from the inside out so we can have different size discs.

Or maybe the hard disk manufacturers cottoned on to the fact that most
people would benchmark freshly partitioned disks hoping the file would be
at the "start" so they make it on the inside and get a better benchmark?

Who knows! And I guess without taking one to bits to watch it work it's
going to be hard to find out...

Gordon

