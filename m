From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/6] mdadm support for journal device of RAID-4/5/6
Date: Fri, 28 Aug 2015 16:27:00 -0700
Message-ID: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Hi,

These are mdadm patches to support journal device in RAID-4/5/6.
Shaohua has sent the kernel patches earlier:
http://marc.info/?l=linux-raid&m=143950154500852

These patches add write journal support for the following commands:

  mdadm --detail
  mdadm --create  --write-journal DEVICE
  mdadm --assemble
  mdadm --incremental
  mdadm --examine

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

 Assemble.c    |  42 +++++++++++++----
 Create.c      |  20 +++++---
 Detail.c      |   3 +-
 Incremental.c |  31 +++++++++++--
 ReadMe.c      |   2 +
 md_p.h        |  64 +++++++++++++++++++++++++
 mdadm.8.in    |   6 +++
 mdadm.c       |  24 ++++++++++
 mdadm.h       |   5 ++
 super1.c      | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 10 files changed, 305 insertions(+), 39 deletions(-)

--
1.8.1
