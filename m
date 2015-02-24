From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/5] Fix issues reported by covscan and newer GCC
Date: Tue, 24 Feb 2015 16:00:35 -0500
Message-ID: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

I had some errors thrown at me by covscan and GCC 4.9.2 which prompted
some furthe inspection. In particular patch 3 could result in a local
stack variable passed back to the calling function, and patch 5 with
code not being executed as expected.

Please have a look.

Cheers,
Jes

Jes Sorensen (5):
  Grow.c: Fix classic readlink() buffer overflow
  Check return of stat() to avoid covscan complaining
  add_orom(): Compare content of struct imsm_orom rather than pointers
    to it
  IncrementalScan(): Make sure 'st' is valid before dereferencing it
  write_super_imsm_spares(): C statements are terminated by ;

 Assemble.c       |  6 +++++-
 Grow.c           |  2 +-
 Incremental.c    |  2 +-
 platform-intel.c |  4 ++--
 super-intel.c    | 12 ++++++------
 5 files changed, 15 insertions(+), 11 deletions(-)

-- 
2.1.0

