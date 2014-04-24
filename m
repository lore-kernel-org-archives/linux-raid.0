From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 00/11] Intel(R) Smart Response Technology mdadm
 enumeration/assembly
Date: Thu, 24 Apr 2014 00:22:16 -0700
Message-ID: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, dave.jiang@intel.com
List-Id: linux-raid.ids

As mentioned in the kernel enabling [1] these cache volumes augment the
existing imsm model in that cache legs each imply a container.  In the
standard cache configuration two single-drive-raid0 volumes (from
separate containers) are associated into a cached volume.  The diagram
below attempts to make this clearer.

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

In support of the standard mdadm volume discovery model a uuid a
synthesized from the combination of the two container-family-numbers and
immutable volume-ids.  Examine_brief is modified to aggregate cache legs
across containers.

Create support is not included, but existing volumes can be
auto-assembled:

  mdadm -Ebs > conf
  mdadm -Asc conf

To facilitate testing the patches are also available on github, but note
that this branch will rebase according to review feedback.

  git://github.com/djbw/mdadm isrt

[1]: http://marc.info/?l=linux-raid&m=139832034826379&w=2

---

Dan Williams (11):
      sysfs: fix sysfs_set_array() to accept valid negative array levels
      make must_be_container() more selective
      Assemble: show the uuid in the verbose case
      Assemble: teardown partially assembled arrays
      Examine: support for coalescing "cache legs"
      imsm: immutable volume id
      imsm: cache metadata definitions
      imsm: read cache metadata
      imsm: examine cache configurations
      imsm: assemble cache volumes
      imsm: support cache enabled arrays


 Assemble.c    |   27 ++-
 Examine.c     |   92 +++++++++-
 Makefile      |    2 
 isrt-intel.h  |  270 ++++++++++++++++++++++++++++++
 maps.c        |    1 
 mdadm.h       |    4 
 super-intel.c |  516 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 sysfs.c       |   13 +
 util.c        |   18 +-
 9 files changed, 865 insertions(+), 78 deletions(-)
 create mode 100644 isrt-intel.h
