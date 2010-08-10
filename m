From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 0/2] two 3.1.3 regression fixes (incremental assembly)
Date: Tue, 10 Aug 2010 09:46:38 -0700
Message-ID: <20100810164551.26691.17944.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

The mdadm -I --no-degraded option needs to be acceptable for some time
to come, do you have a policy for when deprecated options can be scheduled for
removal?  The error code for -I shall be zero in the 'not enough' case to
restore the correct and established pre-3.1.3 behavior.

Also available via git:

   git://github.com/djbw/mdadm.git master

---

Dan Williams (2):
      Incremental: return success in 'container not enough' case
      Incremental: accept '--no-degraded' as a deprecated option

 Incremental.c |    2 +-
 mdadm.c       |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

