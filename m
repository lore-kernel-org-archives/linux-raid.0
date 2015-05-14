From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/7] mdadm support for caching layer in raid 5/6
Date: Wed, 13 May 2015 23:43:49 -0700
Message-ID: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Hi, 

These are mdadm patches to support cache layer in raid 5/6. Shaohua
has sent the kernel patch earlier with subject "a caching layer 
for raid 5/6". 

These patches add write cache support for the following commands:

  mdadm --detail
  mdadm --create
  mdadm --assemble
  mdadm --incremental
  mdadm --examine
  mdadm --zero-super

Cache device is assigned with dev_role 0xFFFD (where 0xFFFF is for 
spare and 0xFFFE is for failed). Note that there is compatibility
issue that older mdadm will show cache device as spare in --detail:

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8       48        1      active sync   /dev/sdd
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf

       4       8       17        -      spare   /dev/sdb1

Also, older mdadm will show cache device as "Active device 65533" 
in --examine: 

   Device Role : Active device 65533
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)


Song Liu (7):
  Show device as cache in --detail
  Enable create array with write cache (--write-cache DEVICE).
  Create write-cache superblock in mdadm --create
  Assemble array with writecache
  Check write cache in incremental
  Zero write-cache superblock in --zero-super
  Add information about write-cache superblock to --examine

 Assemble.c    |  52 +++++++++++++----
 Create.c      |  21 +++++--
 Detail.c      |   3 +-
 Examine.c     |  29 +++++++++-
 Incremental.c |  37 ++++++++++--
 Kill.c        |  19 ++++++
 ReadMe.c      |   1 +
 md_p.h        |  74 ++++++++++++++++++++++++
 mdadm.c       |  19 ++++++
 mdadm.h       |  11 +++-
 super1.c      | 182 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 util.c        |   3 +-
 12 files changed, 422 insertions(+), 29 deletions(-)

-- 
1.8.1

