From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: safe segmenting of conflicting changes (was: Two degraded mirror
 segments recombined out of sync for massive data loss)
Date: Fri, 23 Apr 2010 11:08:24 -0400
Message-ID: <4BD1B7E8.9020602@cfl.rr.com>
References: <loom.20100423T152429-20@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100423T152429-20@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/23/2010 9:42 AM, Christian Gatzemeier wrote:
> Maybe the superblocks of members containing conflicting
> changes already provide that information. I.e. won't they claim each other
> to have failed, while a real failed superblock does not claim itself or
> others to have failed?

Indeed, they should both say the other is failed, so when mdadm
--incremental sees the second disk claims the first disk is failed, but
it is active and working fine in the running array, it should realize
that the superblock on the second disk is wrong, and correct it, which
would leave the second disk as failed, removed, and neither use the out
of sync data on the disk, nor overwrite it with a copy from the first.

In the process of correcting the wrong superblock on the second disk,
the write intent bitmap should be reset as well to force a complete
resync if you do add it back to the array.

> Before doing dist-upgrades to your system (or larger refactoring changes
> to data-arrays), it is very handy to pull a member from a raid1 to be
> able to revert back (without much downtime) if something goes wrong, and
> being able to switch between versions/have both versions available
> for comparison/repair.

If you intend to do that you /should/ explicitly split the array first.
 If you cause that to be done by plugging one in alone and activating it
degraded, then do the same to the other, then when you plug in both this
will be detected by the above corrective action, giving you the
opportunity to move the rejected disk to a new array for inspection, or
force add it back to the old array to discard its contents and resync.

>> If you break a mirror, change both halves, then put it together again
>> there is no clearly "right" answer as to what will appear.
> 
> If the members are --incremental(y) hot-plugged I think the first part
> (segment) should appear. Any further segments with conflicting changes
> should not be re-added automatically (because re-syncing is not a
> update action in this case, but implies changes will get lost.)

Exactly.

> * When assembling, check for conflicting "failed" states in the
>   superblocks to detect conflicting changes. On conflicts, i.e. if an
>   additional member claims an allready running member has failed:
>    + that member should not be added to the array
>    + report (console and --monitor event) that an alternative
>      version with conflicting changes has been detected "mdadm: not
>      re-adding /dev/<member> to /dev/<array> because constitutes an
>      alternative version containing conflicting changes"
>    + require and support --force with --add for manual re-syncing of
>      alternative versions (unlike with re-syncing outdated
>      devices/versions, in this case changes will get lost).

Yep, that's pretty much what I've been suggesting in the bug report,
except the detailed message about conflicting changes I see as an
optional nicety.  Simply saying that the second disk is failed and
removed would be sufficient.

> Enhancement 1)
>   To facilitate easy inspection of alternative versions (i.e. for safe and
>   easy diffing, merging, etc.) --incremental could assemble array
>   components that contain alternative versions into temporary
>   auxiliary devices. 
>   (would require temporarily mangling the fs UUID to ensure there are no
>   duplicates in the system)

This part seems like it is outside the scope of mdadm, and should be
handled elsewhere.  Maybe in udisks.
