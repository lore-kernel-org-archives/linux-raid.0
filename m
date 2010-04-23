From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: safe segmenting of conflicting changes (was: Two degraded mirror segments recombined out of sync for massive data loss)
Date: Fri, 23 Apr 2010 13:42:20 +0000 (UTC)
Message-ID: <loom.20100423T152429-20@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

On 4/7/2010 7:49 PM, Neil Brown wrote:
>
> mdadm --incremental should only included both disks in the array if
> 1/ their event counts are the same, or +/- 1, or
> 2/ there is a write-intent bitmap and the older event count is within
>    the range recorded in the write-intent bitmap.
>
> I don't think there is anything practical that could be changed in md
> or
> mdadm to make it possible to catch this behaviour and refuse the
> assemble the array... 

Maybe the superblocks of members containing conflicting
changes already provide that information. I.e. won't they claim each other
to have failed, while a real failed superblock does not claim itself or
others to have failed?


> Given that you have changed both halves, you have implicitly said that
> both halves are still "good".  If they are different, you need to
> explicitly tell md which one you want and which one you don't.

Before doing dist-upgrades to your system (or larger refactoring changes
to data-arrays), it is very handy to pull a member from a raid1 to be
able to revert back (without much downtime) if something goes wrong, and
being able to switch between versions/have both versions available
for comparison/repair.

 
> If you break a mirror, change both halves, then put it together again
> there is no clearly "right" answer as to what will appear.

If the members are --incremental(y) hot-plugged I think the first part
(segment) should appear. Any further segments with conflicting changes
should not be re-added automatically (because re-syncing is not a
update action in this case, but implies changes will get lost.)

Quite the same with --assemble, it should be OK to assemble the parts in the
order given on the command line, but as soon as any conflicting changes
are detected return:

"mdadm: not re-adding /dev/<member> to /dev/<array> because it
constitutes an alternative version containing conflicting changes"


> The easiest way to do this is to use --zero-superblock on the "bad"
> device.

This actually isn't so good in an udev/hot-plugging environment, since
blkid will then detect that device as containing the filesystem on the
md device (same UUID), and it gets mounted directly instead of md device.

Here is an idea to realize safe segmenting of conflicting changes with
the resulting alternative versions manageable in a hot-plugging manner:

* When assembling, check for conflicting "failed" states in the
  superblocks to detect conflicting changes. On conflicts, i.e. if an
  additional member claims an allready running member has failed:
   + that member should not be added to the array
   + report (console and --monitor event) that an alternative
     version with conflicting changes has been detected "mdadm: not
     re-adding /dev/<member> to /dev/<array> because constitutes an
     alternative version containing conflicting changes"
   + require and support --force with --add for manual re-syncing of
     alternative versions (unlike with re-syncing outdated
     devices/versions, in this case changes will get lost).

Enhancement 1)
  To facilitate easy inspection of alternative versions (i.e. for safe and
  easy diffing, merging, etc.) --incremental could assemble array
  components that contain alternative versions into temporary
  auxiliary devices. 
  (would require temporarily mangling the fs UUID to ensure there are no
  duplicates in the system)

Enhancement 2)
  Those that want to be able to disable hot-plugging of
  segments with conflicting changes/alternative versions, after an
  incidence with multiple versions connected at the same time occured,
  will need some additional enhancements:
   + A way to mark some raid members (segments) as containing
     known alternative versions, and to mark them as such when an
     incident occurs in which they come up after another
     segment of the array is already running degraded.
   + An option like
     "AUTO -SINGLE_SEGMENTS_WITH_KNOWN_ALTERNATIVE_VERSIONS"
     to disable hotplug support for alternative versions once they came
     up after some other version.


Kind Regards,
Christian



