From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 0/6] mdadm support for journal device of RAID-4/5/6
Date: Thu, 8 Oct 2015 22:51:40 -0700
Message-ID: <1444369906-1804157-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Hi,

These are v2 of mdadm patches to support journal device in RAID-4/5/6.
Shaohua has sent latest kernel patches earlier today

http://marc.info/?l=linux-raid&m=144436646730381

Most of these patches are very close to v1, except --assemble, where
we improved checks for journal devices.

The following are copied from v1 pathes.

These patches add write journal support for the following commands:

  mdadm --detail
  mdadm --examine
  mdadm --create  --write-journal DEVICE
  mdadm --assemble
  mdadm --incremental

Journal device is assigned with dev_role 0xFFFD (where 0xFFFF is for
spare and 0xFFFE is for failed). Note that there is compatibility
issue that older mdadm will show journal device as spare in --detail:

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8       48        1      active sync   /dev/sdd
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf

       4       8       17        -      spare   /dev/sdb1

Also, older mdadm will show journal device as "Active device 65533"
in --examine:

   Device Role : Active device 65533
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

Song Liu (6):
  add macros for MD_DISK_ROLE_(SPARE/FAULTY)
  Show device as journal in --detail --examine
  Enable create array with write journal (--write-journal DEVICE).
  Assemble array with write journal
  Check write journal in incremental
  Add help message and man entry for --write-journal

 Assemble.c    |  57 ++++++++++++++++++-----
 Create.c      |  20 +++++---
 Detail.c      |   3 +-
 Incremental.c |  31 +++++++++++--
 ReadMe.c      |   2 +
 md_p.h        |  64 ++++++++++++++++++++++++++
 mdadm.8.in    |   6 +++
 mdadm.c       |  23 ++++++++++
 mdadm.h       |   5 ++
 super1.c      | 144 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 10 files changed, 313 insertions(+), 42 deletions(-)

--
2.4.6
