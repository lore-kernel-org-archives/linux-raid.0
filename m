From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 9 Jun 2013 22:05:08 +0000 (UTC)
Message-ID: <loom.20130610T000503-316@post.gmane.org>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com> <51B47088.4000501@redhat.com> <CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steve Bergman <sbergman27 <at> gmail.com> writes:

> Is this level of corruption expected behavior for delayed allocation?
> Or have I hit a bug that needs to be reported to the ext4 guys? Should
> delayed allocation be the default in an enterprise distribution which
> does not, itself, make proper use of fsync? Should the risks of
> delayed allocation be made more salient than they are to people who
> upgrade from say, RHEL5 to RHEL6? Should options which trade data
> integrity guarantees for performance be the defaults in any case? As
> an admin, I don't care about benchmark numbers. But I care very much
> about the issue of data endangerment "by default".

There's quite a lot I could follow up on or correct in your previous couple
emails, but here is a quick one:

Delayed allocation is a technique which chooses a physical location for data
when IO is sent to disk, not when the write() syscall is issued.

There is nothing at all inherently dangerous about that mode of operation.

ext4 may conflate this a little, because when delalloc is off, the old jbd
5-second-commit behavior is what starts pushing data out, rather than
periodic writeback.

But whether the filesystem chooses a physical block ahead of time or at the
time of IO has no direct effect on safety or data integrity.

-Eric

