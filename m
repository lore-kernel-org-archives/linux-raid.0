From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: Re: safe segmenting of conflicting changes, and hot-plugging between alternative versions
Date: Mon, 26 Apr 2010 21:10:50 +0000 (UTC)
Message-ID: <loom.20100426T214001-727@post.gmane.org>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <loom.20100423T213339-797@post.gmane.org> <4BD5C927.6030608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford <dledford <at> redhat.com> writes:
> 
> Actually, I have a feature request that I haven't gotten around to yet
> for something similar to this.  It's the ability pause a raid1 array,
> causing a member of the array to stop all updates while the rest of the
> array operates as normal.

Indeed that is quite similar. Related terms would be "paused segment" and
"alternative version/segment", the latter probably "locked-out".

The main differences being that cleanly pausing a segment would be done by
issuing a command while segmenting can also happen due to failure modes or
intentional hot/cold-plugging. And that a segment containing an alternative
version would not necessarily have to be static. Though, by making use of some
new "locking-out" functionality the pause command could make sure the
alternative version is never auto-assembled and stays static from the start,
while the proposed enhancement 2) thought only after incidents where conflicting
versions appeared together. 

So it looks, as if intentionally "pausing" could be implemented as ("alternative
version" + "lock-out") and could at the same time allow safe segmenting in other
circumstances.

Only a mark to "locked out" members may be enough to implement all this. So I'd
suggest that "a superblock marking itself as removed" may be a mark for "locked
out" rather than for "alternative version", and be exempt from auto-readding.

If we can reliably detect alternative versions by checking for conflicts in
failed claims of superblocks, we probably don't need another extra measure to
mark superblocks as containing an alternative version. And pausing a segment 
would (on shutdown) make the paused segment claim the rest of the array failed
and the paused segments were removed, while rest claims the paused segment
failed and was removed.

Can someone find a flaw with the superblock marking itself as removed approach?




> However, this is fairly orthogonal to the original problem you
> mentioned, specifically that mounting to members of a raid1 array
> independently can trick them into thinking they are in sync when they
> aren't.

Hm, more or less. In the case at hand detection of the conflicting changes
failed, and thus auto-segmenting, or more explicitly keeping the alternative
versions appart that were created by degrading different segments on different
boots failed. I was seeing it as a test case for safe segmenting, in which the
versions are not diverged much (+-1 same event count or bitmap range).

> The simplest solution to solve that problem would be to add a
> generation count to each device's data in each superblock

Ah ok, I understand that may be easier to implement.

Can you see some flaw in checking for superblocks that mark running superblocks
as faulty, as a conflict detection algorithm? That may not be limited only to
new superblocks.





