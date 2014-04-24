From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 0/3] Base compatibility support for Intel(R) Smart
 Response Technology
Date: Wed, 23 Apr 2014 23:18:44 -0700
Message-ID: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

Initial request for comment on kernel support for these
platform-firmware defined SSD + HDD cache configurations shipping on
recent platforms.  Note, mdadm support to enumerate/assemble these
arrays is included in a follow on patchset.

The largest architectural difference over the existing "imsm" external
metadata support is a new md personality "isrt" that handles the
cache-specific metadata.  The base metadata required to assemble the
volume is handled in userspace.  The next major difference is that these
configurations span "containers".  In the standard cache configuration
two single-drive-raid0 volumes (from separate containers) are associated
into a cached volume.  The diagram below attempts to make this clearer.


+-----------------------+              +----------------------+             
|          sda          | SSD          |         sdb          | HDD         
| +-------------------+ |              | +------------------+ |             
| |   /dev/md/imsm0   | | Container0   | |  /dev/md/imsm1   | | Container1  
| | +---------------+ | |              | | +--------------+ | |             
| | | /dev/md/vol0  | | | RAID Volume0 | | | /dev/md/vol1 | | | RAID Volume1
| | |  +---------+  | | |              | | | +----------+ | | |             
| | |  |SRT Cache|  | | |              | | | |SRT Target| | | |             
+-+-+--+----+----+--+-+-+              +-+-+-+----+-----+-+-+-+             
            |                                     |                         
            |                                     |                         
            |          HDD Cached by SSD          |                         
            |           +--------------+          |                         
            +-----------+ /dev/md/isrt +----------+                         
                        +--------------+                                    

"Base compatibility" refers to the fact that this implementation does
not target performance.  Instead, this simply provides the ability to
perform cache coherent reads and writes.  For example, cache-inserts are
never performed.  The only case where we update the cache metadata is
dirtying an existing frame in the cache, otherwise the write is directed
to the HDD.  Reads are decomposed into portions that can be routed and wholly
consumed by the SSD or the HDD (directed by the cache metadata).

The primary motivation for this release is dual-boot compatibility.
Whether this support is paired with existing multi-device cache policy
engines in the kernel for a performance oriented use case is TBD.

Existing bug reports and feature requests:
https://bugzilla.redhat.com/show_bug.cgi?id=890881
https://bugzilla.redhat.com/show_bug.cgi?id=1040362

To simplify testing these patches are also available via github, but be
warned this tree will rebase in response to review feedback:

  git://github.com/djbw/linux isrt

---

Dan Williams (3):
      md/isrt: base infrastructure and metadata loading
      md/isrt: read support
      md/isrt: write support


 drivers/md/Kconfig  |   18 +
 drivers/md/Makefile |    1 
 drivers/md/isrt.c   |  745 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/isrt.h   |  300 +++++++++++++++++++++
 4 files changed, 1064 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/isrt.c
 create mode 100644 drivers/md/isrt.h
