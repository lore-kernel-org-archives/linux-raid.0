From: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Subject: [mdadm,v1 PATCH 0/6] Extend mdadm [...] --export
Date: Wed, 26 Sep 2012 13:42:36 +0200
Message-ID: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

The following patches:

1. Add support for --mdadm --detail-platform --export with an additional option to provide specific controller to scan. The controller might be an absolute path to an actual   device, or just a symlink.

2. Synchronize two methods of calculating size and add the possibility to choose output format (IEC or JEDEC prefixes).

3. Add an additional value to mdadm --examine --export

---

Maciej Naruszewicz (6):
      imsm: Add --export option for --detail-platform
      imsm: Add --controller-path option for --detail-platform.
      Fix return code for --detail-platform
      Synchronize size calculation in human_size and human_size_brief
      Display size with human_size_brief with a chosen prefix
      Add MD_ARRAY_SIZE for --examine --export


 Create.c      |    2 +
 Detail.c      |   13 +++++--
 Query.c       |    2 +
 ReadMe.c      |    6 ++-
 mdadm.8.in    |   10 +++++
 mdadm.c       |   32 +++++++++++++++++
 mdadm.h       |   14 ++++++--
 super-intel.c |  105 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 super1.c      |   19 ++++++++++
 util.c        |   51 +++++++++++++++++++++-------
 10 files changed, 213 insertions(+), 41 deletions(-)

--
MN
