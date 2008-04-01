From: "Mike Snitzer" <snitzer@gmail.com>
Subject: raid1 will force fullsync when it seemingly should not
Date: Tue, 1 Apr 2008 02:41:13 -0400
Message-ID: <170fa0d20803312341u6ea23e39r93030a7381c229b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_20545_15759316.1207032073379"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_20545_15759316.1207032073379
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Neil,

I've been looking into another scenario where a raid1 with members
that have an internal bitmap are performing what seems to be an
unnecessary 'fullsync' on re-add.  I'm using 2.6.22.19 +
918f02383fb9ff5dba29709f3199189eeac55021

To be clear this isn't a pathological bug with the generic sequence
I'm about to describe; it has more to do with my setup where one of
the raid1 members is write-mostly via NBD.  The case that I'm trying
to resolve is when the remote nbd-server is racing to shutdown
_before_ MD has been able to stop the raid1 (while the array is still
clean).  Therefore the nbd-client loses it's connection and the nbd0
member becomes faulty.

So the raid1 marks the remote nbd member faulty and degrades the array
just before the raid1 is stopped.  When the raid1 is reassembled the
previously "faulty" member is deemed "non-fresh" and is kicked from
the array (via super_90_validate's -EINVAL return).  This "non-fresh"
member is then hot-added to the raid1 and in raid1_add_disk()
'fullsync' is almost always set (because 'saved_raid_disk' is -1).

I added a some "DEBUG:" logging and the log looks like this:

end_request: I/O error, dev nbd0, sector 6297352
md: super_written gets error=-5, uptodate=0
raid1: Disk failure on nbd0, disabling device.
        Operation continuing on 1 devices
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sdd1
 disk 1, wo:1, o:0, dev:nbd0
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sdd1
...
md: md0 stopped.
md: bind<nbd0>
md: bind<sdd1>
md: DEBUG: nbd0 is non-fresh because 'bad' event counter
md: kicking non-fresh nbd0 from array!
md: unbind<nbd0>
md: export_rdev(nbd0)
raid1: raid set md0 active with 1 out of 2 mirrors
md0: bitmap initialized from disk: read 13/13 pages, set 1 bits, status: 0
created bitmap (193 pages) for device md0
md: DEBUG: nbd0 rdev's ev1 (30186) < mddev->bitmap->events_cleared
(30187)... rdev->raid_disk=-1
md: DEBUG: nbd0 saved_raid_disk=-1
md: bind<nbd0>
md: DEBUG: nbd0 recovery requires full-resync because rdev->saved_raid_disk < 0
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sdd1
 disk 1, wo:1, o:1, dev:nbd0

Given validate_super() determines the nbd0's events to be less than
the raid1's bitmap's events_cleared it is easy to see why
'saved_raid_disk' is -1 on entry to raid1_add_disk().

For me, this events vs events_cleared mismatch is a regular occurance.
 The healthy member's bitmap's events_cleared is frequently one
greater than the the faulty member's events (and events_cleared).

Why is it so detremental for the "faulty" (or in my case "non-fresh")
member to have it's events be less than the array's bitmap's
events_cleared?  Is there possibly a bug with how events_cleared is
being incremented (when the raid1 is degraded right before being
stopped)?

Doesn't an odd valued events simply mean the array is dirty?  In fact
I've seen the events decrement back one when transitioning from
'dirty' to 'clean', e.g.:
[root@srv1 ~]# mdadm -X /dev/sdd1 /dev/nbd0
        Filename : /dev/sdd1
          Events : 881
  Events Cleared : 881
...
        Filename : /dev/nbd0
          Events : 881
  Events Cleared : 881

then seconds later:

[root@srv2 ~]# mdadm -X /dev/sdd1 /dev/nbd0
        Filename : /dev/sdd1
          Events : 880
  Events Cleared : 880
...
        Filename : /dev/nbd0
          Events : 880
  Events Cleared : 880

Would the following attached "fix" be invalid (super_1_validate would
need patching too)?

Any help would be appreciated, thanks.
Mike

------=_Part_20545_15759316.1207032073379
Content-Type: text/x-patch; name=raid1_valid_degraded_events.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fei3o04b0
Content-Disposition: attachment; filename=raid1_valid_degraded_events.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQuYyBiL2RyaXZlcnMvbWQvbWQuYwppbmRleCA4Mjc4
MjRhLi40NTRlYjM4IDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL21kLmMKKysrIGIvZHJpdmVycy9t
ZC9tZC5jCkBAIC04NDAsNiArODQwLDcgQEAgc3RhdGljIGludCBzdXBlcl85MF92YWxpZGF0ZSht
ZGRldl90ICptZGRldiwgbWRrX3JkZXZfdCAqcmRldikKIAkJLyogaWYgYWRkaW5nIHRvIGFycmF5
IHdpdGggYSBiaXRtYXAsIHRoZW4gd2UgY2FuIGFjY2VwdCBhbgogCQkgKiBvbGRlciBkZXZpY2Ug
Li4uIGJ1dCBub3QgdG9vIG9sZC4KIAkJICovCisJCSsrZXYxOwogCQlpZiAoZXYxIDwgbWRkZXYt
PmJpdG1hcC0+ZXZlbnRzX2NsZWFyZWQpCiAJCQlyZXR1cm4gMDsKIAl9IGVsc2Ugewo=
------=_Part_20545_15759316.1207032073379--
