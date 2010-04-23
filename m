From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: Re: safe segmenting of conflicting changes, and hot-plugging between alternative versions
Date: Fri, 23 Apr 2010 21:04:35 +0000 (UTC)
Message-ID: <loom.20100423T213339-797@post.gmane.org>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phillip Susi <psusi <at> cfl.rr.com> writes:

> when mdadm
> --incremental sees the second disk claims the first disk is failed, but
> it is active and working fine in the running array, it should realize
> that the superblock on the second disk is wrong, and correct it, which
> would leave the second disk as failed, removed, and neither use the out
> of sync data on the disk, nor overwrite it with a copy from the first.

"Correcting the superblocks" of conflicting members, would translate into having
a defined way to mark those members as composing a segment that contains a known
alternative version of the array. The earliest an alternative version can be
detected, and thus be known and marked as such, is on an incident when a
conflicting segment comes up while another segment of the array is already
running degraded. (To simply support segments consisting of single raid member
devices it may be enough if a superblock marking itself as failed would mean it
is contains conflicting changes. Multi member segments would require segment IDs)

IMHO all segments with alternative versions can be marked as known on such 
incidences. However whether the segments containing alternative versions
continue to be normally assembled when they come up after the incident like
before, or if they get ignored in favor of the arbitrary first segment of the
incidence, should be configurable.

For users that don't need or want to be able to switch between versions of an
array by simply switching disks in a hot-pluggable manner, and for those
concerned about a failure mode that may exist and make disks available in an
alternating manner and them not noticing it all the time until an incident, I
suggested "AUTO -SINGLE_SEGMENTS_WITH_KNOWN_ALTERNATIVE_VERSIONS".

In order to manage segments with alternative versions in a hot-plug manner
however, all segments need to continue to show up under their real array ID, if
they are connected first or one at a time. (KNOWN_ALTERNATIVE_VERSIONS need to
be assembled if they come up.) If the segments would be transformed into
separate arrays the system won't recognize the segment of the array as such and
not boot or open it correctly any more. And you wouldn't be able to switch
between versions by switching the disks that are connected.
 
Kind regards,
Christian



