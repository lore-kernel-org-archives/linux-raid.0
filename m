From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 2 - v2] DM RAID: Add message/status support for
 changing sync action
Date: Tue, 19 Mar 2013 12:15:52 -0500
Message-ID: <1363713352.11184.15.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

Neil,

I've made the updates which Alasdair suggested, re-worked the patch to
apply to 3.9.0-rc3 instead of 3.8.0, and split the patch into two
pieces:
- export reap_sync_thread: to ensure completion of "idle"/"frozen"
commands
- Add message/status support for changing sync action

I still have two questions though:
1)  The mismatch_count is only valid after a "check" has been run,
right?  If I run a "repair", I would expect it to be reset upon
completion, but it is not - not until "check" has been run again.  Is
this the expected behavior?
2)  It is possible to issue "frozen" on an array that is undergoing
"resync" and then issue a "check".  I would expect an EBUSY or
something.  Additionally, checkpointing seems to be done and seems to
make it possible to e.g. "resync" the first 25%, "check" the second 25%
and then finish the last half with a "resync" again.  This would be
really stupid of the user, but should we catch it?  (This would probably
be a follow-on patch if "yes".)

Thanks,
 brassow

P.S.  Here is the expected (and tested) output of the various states if
interested:
Initial (automated) sync:
- health_chars should all be 'a'
- sync_ratio should show progress
- sync_action should be "resync"
[root@bp-01 ~]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
0 10485760 raid raid1 2 aa 5029120/10485760 resync 0

Nominal state:
- health_chars should all be 'A'
- sync_ratio should show 100% (same numerator and denominator)
- sync_action should be "idle"
[root@bp-01 ~]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
0 10485760 raid raid1 2 AA 10485760/10485760 idle 0

Rebuild/replace a device:
- health_chars show devices being replaced as 'a', but others as 'A'
- sync_ratio should show progress
- sync_action should be "recover"
[root@bp-01 ~]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:8 254:9 254:5 254:6
0 10485760 raid raid1 2 aA 655488/10485760 recover 0

Check/scrub:
- health_chars should all be 'A'
- sync_ratio should show progress of "check"
- sync_action should be "check"
[root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
0 10485760 raid raid1 2 AA 1310976/10485760 check 0

Repair:
- health_chars should all be 'A'
- sync_ratio should show progress of "repair"
- sync_action should be "repair"
[root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
0 10485760 raid raid1 2 AA 655488/10485760 repair 0

Check/scrub (when devices differ):
- health_chars should all be 'A'
- sync_ratio should show progress of "check"
- sync_action should be "check"
- mismatch_cnt should show a count of discrepancies
[root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:8 254:9 254:5 254:6
0 10485760 raid raid1 2 AA 655488/10485760 check 81920

Repair:
- health_chars should all be 'A'
- sync_ratio should show progress of "repair"
- sync_action should be "repair"
- IS MISMATCH_CNT INVALID UNTIL A "check" IS RUN AGAIN?
- SHOULD "repair" RESET MISMATCH_CNT WHEN FINISHED?
[root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:8 254:9 254:5 254:6
0 10485760 raid raid1 2 AA 655488/10485760 repair 81920
[root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:8 254:9 254:5 254:6
0 10485760 raid raid1 2 AA 10485760/10485760 idle 81920

Possible issues:
- We can freeze initialization and then start a check instead.
  SHOULD THIS PRODUCE AN ERROR (like EBUSY)?
[root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
0 10485760 raid raid1 2 aa 2715136/10485760 resync 0
[root@bp-01 linux-upstream]# dmsetup message vg-lv 0 frozen
[root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
0 10485760 raid raid1 2 aa 5558784/10485760 frozen 0
[root@bp-01 linux-upstream]# dmsetup message vg-lv 0 check
[root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
0 10485760 raid raid1 2 AA 655488/10485760 check 0



