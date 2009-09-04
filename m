From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 00/18] ioatdma: raid5/raid6 offload support
Date: Thu, 03 Sep 2009 23:44:35 -0700
Message-ID: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

The Intel(R) QuickData Technology specification version 3.2 adds support
for offloading raid parity calculations.  This patchset builds upon the
md raid6 acceleration patchset [1] and the ioatdma refactoring patchset
[2].  Beyond the new operation types and descriptor formats these raid
engines require a few changes to the current dmaengine/async_tx offload
infrastructure:
1/ v3.2 channels may prefetch descriptors which leads to later
   descriptors in the chain possibly starting their reads before earlier
   descriptors in the chain have completed their writes.  A 'fence' bit is
   specified in the descriptor to disable this optimization in case there
   are data dependencies in the chain.  Fenced operation must be explicitly
   requested at the async_tx api level. 
2/ The descriptor ring scheme of the ioatdma driver for v2+ devices
   precludes async_tx channel switching.  The scheme requires that ->prep()
   and ->submit() calls not be reordered.  To support this constraint the
   dmaengine channel allocator is modified to only return "raid" engines
   when CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y which ensures that the
   async_tx api only ever sees channels that have all the requisite
   capabilities.
3/ Raid operations must be 4-byte aligned, so per operation alignment
   checks are added to the async_tx api.

A couple user visible changes are included in this update:
1/ A 'quickdata' attribute directory is added to the sysfs path of ioatdma
   channel objects.  This allows channels with raid capabilities to be
   identified and the activity of the channel to be monitored.
2/ The ioatdma module will now be auto-loaded by the hotplug
   infrastructure.  Add "blacklist ioatdma" to /etc/modprobe.d/blacklist to
   maintain the prior policy.

Provided the md raid6 acceleration patches [1] are accepted this
patchset will follow them into 2.6.32.

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git ioat-raid

Regards,
Dan

[1]: http://marc.info/?l=linux-raid&m=125173687620741&w=2
[2]: http://marc.info/?l=linux-raid&m=125203215231330&w=2

---

Dan Williams (15):
      dmaengine: add fence support
      dmaengine, async_tx: add a "no channel switch" allocator
      dmaengine: cleanup unused transaction types
      dmaengine, async_tx: support alignment checks
      ioat2+: add fence support
      ioat3: hardware version 3.2 register / descriptor definitions
      ioat3: split ioat3 support to its own file, add memset
      ioat: add 'ioat' sysfs attributes
      ioat3: enable dca for completion writes
      ioat3: xor support
      ioat3: xor self test
      ioat3: pq support
      ioat3: support xor via pq descriptors
      ioat3: interrupt descriptor support
      ioat3: segregate raid engines

Roland Dreier (2):
      Add MODULE_DEVICE_TABLE() so ioatdma module is autoloaded
      I/OAT: Convert to PCI_VDEVICE()

Tom Picard (1):
      ioat3: ioat3.2 pci ids for Jasper Forest

 arch/arm/mach-iop13xx/setup.c       |    7 -
 arch/arm/plat-iop/adma.c            |    2 -
 crypto/async_tx/async_memcpy.c      |    9 +-
 crypto/async_tx/async_memset.c      |    9 +-
 crypto/async_tx/async_pq.c          |   11 +-
 crypto/async_tx/async_raid6_recov.c |   47 +-
 crypto/async_tx/async_tx.c          |    4 +
 crypto/async_tx/async_xor.c         |   16 +-
 drivers/dma/Kconfig                 |    4 +
 drivers/dma/dmaengine.c             |   40 ++
 drivers/dma/dmatest.c               |   14 +
 drivers/dma/ioat/Makefile           |    2 +-
 drivers/dma/ioat/dma.c              |  136 ++++-
 drivers/dma/ioat/dma.h              |   34 +-
 drivers/dma/ioat/dma_v2.c           |  129 ++--
 drivers/dma/ioat/dma_v2.h           |   46 ++-
 drivers/dma/ioat/dma_v3.c           | 1220 +++++++++++++++++++++++++++++++++++
 drivers/dma/ioat/hw.h               |  142 ++++
 drivers/dma/ioat/pci.c              |   45 +-
 drivers/dma/ioat/registers.h        |   20 +
 drivers/dma/iop-adma.c              |    5 +-
 drivers/md/raid5.c                  |   37 +-
 include/linux/async_tx.h            |    3 +
 include/linux/dmaengine.h           |   60 ++-
 include/linux/pci_ids.h             |   10 +
 25 files changed, 1880 insertions(+), 172 deletions(-)
 create mode 100644 drivers/dma/ioat/dma_v3.c
