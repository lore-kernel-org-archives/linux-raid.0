From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v3 0/6] mdadm support for Partial Parity Log
Date: Thu, 16 Mar 2017 22:09:42 +0100
Message-ID: <20170316210948.21093-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This is the mdadm part of the PPL functionality. It adds a new parameter to
mdadm to allow selecting the consistency policy for an array and implements PPL
as one of the policies.

All of this is currently targeted and tested with imsm and super1 metadata
arrays. The kernel patches are available on Shaohua's md tree on the for-next
branch.

v3:
- Rebased to latest mdadm code.
- Replaced --rwh-policy with --consistency-policy.
- Adjusted to the kernel interface changes.
- Write the initial ppl header in mdadm when creating an array.
- Validate ppl when starting an imsm array. 
- Support for --update.
- Support also 1.0 metadata.
- Use Grow mode for enabing or disabling ppl for an active array.

v2:
- Rebased to latest mdadm code.
- Fixed runtime policy switching.
- Recognize IMSM PPL journal drive correctly.
- Removed bitfields from imsm_dev.
- Made dirty/consistent checks in imsm_set_array_state() more readable.
- Added comment about calculating sb_start.

Artur Paszkiewicz (6):
  Generic support for --consistency-policy and PPL
  Detail: show consistency policy
  imsm: PPL support
  super1: PPL support
  Add 'ppl' and 'no-ppl' options for --update=
  Grow: support consistency policy change

 Assemble.c    |  58 ++++++++++
 Create.c      |  20 +++-
 Detail.c      |  90 +++++++++------
 Grow.c        | 187 ++++++++++++++++++++++++++++++-
 Incremental.c |   3 +
 Kill.c        |   2 +-
 Makefile      |   5 +-
 ReadMe.c      |   7 +-
 maps.c        |  10 ++
 md_p.h        |  25 +++++
 mdadm.8.in    |  85 ++++++++++++--
 mdadm.c       |  64 ++++++++++-
 mdadm.h       |  30 ++++-
 super-ddf.c   |  12 +-
 super-gpt.c   |   2 +-
 super-intel.c | 347 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
 super-mbr.c   |   2 +-
 super0.c      |  12 +-
 super1.c      | 214 +++++++++++++++++++++++++++++++-----
 sysfs.c       |  25 +++++
 20 files changed, 1069 insertions(+), 131 deletions(-)

-- 
2.11.0

