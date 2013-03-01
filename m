From: mwilck@arcor.de
Subject: DDF / RAID10 patch series for mdadm
Date: Fri,  1 Mar 2013 23:28:21 +0100
Message-ID: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Hello Neil, hello everybody,

I am working on improved DDF support in mdadm. I would be grateful
for a review on this patch series. The main new feature is support for
RAID 10 in DDF, such that md is able to interoperate with an LSI 
Megaraid Software RAID driver on a RAID10 array.

The DDF/RAID10 support is not feature complete, but usable. Both
assembly and incremental assembly work as expected. I verified that
the 2+2 layout maps cleanly to that used by the LSI SW RAID stack. Meta
data are saved cleanly and interpreted correctly by the LSI stack.
What is yet missing is code to handle disk failures and additions.
I would appreciate some guidance in that area, in particular how to test it.

In the DDF Spec, RAID10 is a special case of the broad "secondary RAID
level" concept. The intersection between DDF RAID 10 and md RAID 10 is
tiny - just the "near" layout with an even number of disks. Fortunately this
is also the only type of "secondary RAID" supported by my LSI stack,
and generally the most common multilevel RAID, AFAICT.

The DDF 2nd level RAID concept would be matched more closely by a
different approach where md only creates the BVDs and the secondary
RAID is implemented with the device mapper on top of it. But I opted
for the direct mapping of DDF RAID10 to md RAID10 for several reasons:
1) dm wouldn't handle the generic "striped" and "spanned" secondary
levels out-of-the box, either. 2) I wanted to take full benefit of the
advanced features and performance of md RAID10 (it actually performed
better than the LSI stack in a few simple benchmarks).  3) It is
simpler to handle this way. 4) This is non-exclusive, code could still
be added later to use dm for more "exotic" secondary DDF RAID levels.

The series stars out with 3 patches I already submitted a while
ago. They fix interoperability related to meta data handling, in particular
DDF header locations and Sequential numbers. They are unrelated to RAID10.

Patch 4..9 introduce support for DDF RAID 10. The current mdadm
implementation of DDF ignores secondary level completely and stores
only the BVD information in the super block, one BVD for every DDF
"Virtual disk configuration record". I had to add an additional data
structure to hold information about the "other BVDs" belonging to a
second level RAID set. The most intersting stuff happens in
container_content_ddf, which translates the DDF RAID 10 setup into md
structures.

Patch 10 adds some missing sanity checks in compare_super_ddf. Patch 11
extends compare_super_ddf() such that information from the new disk that
is missing in the current superblock is added. This fixes a problem where
mdmon would save updated meta data only on those disks that were present
while mdadm was started, not on disks added later.

Finally, patch 12 is a small improvement to Detail() that results in
better output of mdadm -D for complex DDF setups.

Regards
Martin

Martin Wilck (12):
  DDF: cleanly save the secondary DDF structure
  DDF: use existing locations for primary and secondary DDF structure
  DDF: increase seq number when writing meta data
  DDF: added other_bvd to struct vcl
  DDF: load_ddf_local: store VD conf for other BVDs
  DDF: container_content_ddf: change array disk search loop
  DDF: container_content_ddf: check for secondary RAID
  DDF: container_content_ddf: handle RAID layout for RAID10
  DDF: __write_init_super_ddf: use correct VD conf
  DDF: add sanity checks in compare_super_ddf
  DDF: compare_super_ddf: merge local info of other superblock
  Detail.c: call load_container for container subarrays

 Detail.c    |   10 +-
 super-ddf.c |  556 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 484 insertions(+), 82 deletions(-)

-- 
1.7.3.4
