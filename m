From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 0/7] mdadm support for Partial Parity Log
Date: Mon,  5 Dec 2016 16:31:57 +0100
Message-ID: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is the mdadm part of the PPL functionality. It adds a new parameter to
mdadm to allow selecting the RWH policy for an array. Other changes include
displaying the RWH policy in the output from --detail and --examine.

As with the kernel patches sent earlier, all of this is currently targeted and
tested with IMSM and native MD v1.1 and v1.2 metadata arrays.

v2:
- Rebased to latest mdadm code.
- Fixed runtime policy switching.
- Recognize IMSM PPL journal drive correctly.
- Removed bitfields from imsm_dev.
- Made dirty/consistent checks in imsm_set_array_state() more readable.
- Added comment about calculating sb_start.

Artur Paszkiewicz (6):
  imsm: metadata changes for PPL
  Generic support for --rwh-policy and PPL
  imsm: PPL support
  super1: PPL support
  Allow changing the RWH policy for a running array
  Man page changes for --rwh-policy

Pawel Baldysiak (1):
  imsm: allow to assemble with PPL even if dirty degraded

 Assemble.c    |   4 +-
 Create.c      |  26 +++++++--
 Detail.c      |  18 ++++++-
 Grow.c        |  15 +++++-
 Kill.c        |   2 +-
 Manage.c      |  79 +++++++++++++++++++++++++++
 ReadMe.c      |   1 +
 maps.c        |   7 +++
 mdadm.8.in    |  28 ++++++++++
 mdadm.c       |  44 +++++++++++++--
 mdadm.h       |  21 ++++++--
 super-ddf.c   |   6 +--
 super-gpt.c   |   2 +-
 super-intel.c | 169 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 super-mbr.c   |   2 +-
 super0.c      |   8 +--
 super1.c      |  92 ++++++++++++++++++++++++++------
 sysfs.c       |  15 ++++++
 18 files changed, 481 insertions(+), 58 deletions(-)

-- 
2.10.1

