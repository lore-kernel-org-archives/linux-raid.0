From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Can you help me on Linux SW RAID?
Date: Thu, 28 Apr 2005 13:29:04 +0200
Message-ID: <20050428112904.GC17359@unthought.net>
References: <IFNIZD$19CF4F5AC29109D5327F89A86EC57541@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <IFNIZD$19CF4F5AC29109D5327F89A86EC57541@libero.it>
Sender: linux-raid-owner@vger.kernel.org
To: "miele@inwind.it" <miele@inwind.it>
Cc: linux-raid <linux-raid@vger.kernel.org>, mingo <mingo@chiara.csoma.elte.hu>, bueso <bueso@vives.org>
List-Id: linux-raid.ids

On Thu, Apr 28, 2005 at 12:11:37PM +0200, miele@inwind.it wrote:
> 
> Hi.
> 
...
> All is wonderful but.. when all seems ok and my work seems to be finished..
> ..I'm having hard doubts on this RAID configuration and its stability.

With good reason - there is no way that this can work reliably.

> I fear that RAID SW modules that runs on each of two Linux nodes, and
> works on the same data of the shared disk array, could produce
> conflicts, misalignments, or I don't know what other..

This is exactly what will happen. It will not work.

> 
> Can you give me a comment or suggests about RAID SW use i've made?

> 

You cannot share storage between multiple SW RAID "masters".

If you take SW RAID and LVM out of the equation, you will still have
problems with the filesystem - you cannot share storage between two
nodes by mounting the same storage.  Again, both nodes will write to the
journal with no synchronization between them, both will cache data
locally with no cache synchronization, etc. etc.  Disaster lies ahead.

Look into GFS for a solution to the filesystem problem.

You can use some of the linux-ha stuff to make sure that only one node
at a time will actually use the underlying storage, if that is an
acceptable solution (pure fail-over).

But all in all, there's no plug'n'play solution for what you're trying
to accomplish.

Personally, I think I'd get a "storage box" which did the RAID for me
(that could be an off the shelf iSCSI/FC box, or it could be another
Linux box exporting a software RAID over iSCSI, it could be a lot of
things depending on your needs and budget), then, I'd look into GFS or
Oracle's recently opensourced shared filesystem for the shared
filesystem.

Maybe others on this list have better suggestions.

But first of all; stop what you are doing now, you are hurting yourself
and your data  ;)

-- 

 / jakob

