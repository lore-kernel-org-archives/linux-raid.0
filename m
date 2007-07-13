From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] ioat fixes, raid5 acceleration, and the async_tx api
Date: Fri, 13 Jul 2007 08:34:27 -0700
Message-ID: <1184340867.7266.4.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, John Magolan <john.magolan@unisys.com>, NeilBrown <neilb@suse.de>, Russell King <rmk@arm.linux.org.uk>, Shannon Nelson <shannon.nelson@intel.com>, Jeff Garzik <jeff@garzik.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Linus, please pull from

	git://lost.foo-projects.org/~dwillia2/git/iop ioat-md-accel-for-linus

to receive:

1/ I/OAT performance tweaks and simple fixups.  These patches have been
   in -mm for a few kernel releases as git-ioat.patch
2/ RAID5 acceleration and the async_tx api.  These patches have also
   been in -mm for a few kernel releases as git-md-accel.patch.  In
   addition, they have received field testing as a part of the -iop kernel
   released via SourceForge[1] since 2.6.18-rc6.

The raid acceleration work can further be subdivided into three logical
areas:
- API -
The async_tx api provides methods for describing a chain of
asynchronous bulk memory transfers/transforms with support for
inter-transactional dependencies.  It is implemented as a dmaengine
client that smooths over the details of different hardware offload
engine implementations.  Code that is written to the api can optimize
for asynchronous operation and the api will fit the chain of operations
to the available offload resources. 

- Implementation -
When the raid acceleration work was proposed, Neil laid out the
following attack plan:
    1/ move the xor and copy operations outside spin_lock(&sh->lock)
    2/ find/implement an asynchronous offload api
The raid5_run_ops routine uses the asynchronous offload api
(async_tx) and the stripe_operations member of a stripe_head to carry
out xor and copy operations asynchronously, outside the lock.

- Driver -
The Intel(R) Xscale IOP series of I/O processors integrate an Xscale
core with raid acceleration engines.  The iop-adma driver supports the
copy and xor capabilities of the 3 IOP architectures iop32x, iop33x, and
iop34x.

All the MD changes have been acked-by Neil Brown.  For the changes made
to net/ I have received David Miller's acked-by.  Shannon Nelson has
tested the I/OAT changes (due to async_tx support) in his environment
and has added his signed-off-by.  Herbert Xu has agreed to let the
async_tx api be housed under crypto/ with the intent to coordinate
efforts as support for transforms like crc32c and raid6-p+q are
developed.

To be clear Shannon Nelson is the I/OAT maintainer, but we agreed that I
should coordinate this release to simplify the merge process.  Going
forward I will be the iop-adma maintainer.  For the common bits,
dmaengine core and the async_tx api, Shannon and I will coordinate as
co-maintainers.

- Credits -
I cannot thank Neil Brown enough for his advice and patience as this
code was developed.

Jeff Garzik is credited with helping the dmaengine core and async_tx
become sane apis.  You are credited with the general premise that users
of an asynchronous offload engine api should not know or care if an
operation is carried out asynchronously or synchronously in software.
Andrew Morton is credited with corralling these conflicting git trees in
-mm and more importantly imparting encouragement at OLS 2006.

Per Andrew's request the md-accel changelogs were fleshed out and the
patch set was posted for a final review a few weeks ago[2].  To my
knowledge there are no pending review items.  This tree is based on
2.6.22.

Thank you,
Dan

[1] http://sourceforge.net/projects/xscaleiop
[2] http://marc.info/?l=linux-raid&w=2&r=1&s=md-accel&q=b

Andrew Morton (1):
      I/OAT: warning fix

Chris Leech (5):
      ioatdma: Push pending transactions to hardware more frequently
      ioatdma: Remove the wrappers around read(bwl)/write(bwl) in ioatdma
      ioatdma: Remove the use of writeq from the ioatdma driver
      I/OAT: Add documentation for the tcp_dma_copybreak sysctl
      I/OAT: Only offload copies for TCP when there will be a context switch

Dan Aloni (1):
      I/OAT: fix I/OAT for kexec

Dan Williams (20):
      dmaengine: refactor dmaengine around dma_async_tx_descriptor
      dmaengine: make clients responsible for managing channels
      xor: make 'xor_blocks' a library routine for use with async_tx
      async_tx: add the async_tx api
      raid5: refactor handle_stripe5 and handle_stripe6 (v3)
      raid5: replace custom debug PRINTKs with standard pr_debug
      md: raid5_run_ops - run stripe operations outside sh->lock
      md: common infrastructure for running operations with raid5_run_ops
      md: handle_stripe5 - add request/completion logic for async write ops
      md: handle_stripe5 - add request/completion logic for async compute ops
      md: handle_stripe5 - add request/completion logic for async check ops
      md: handle_stripe5 - add request/completion logic for async read ops
      md: handle_stripe5 - add request/completion logic for async expand ops
      md: handle_stripe5 - request io processing in raid5_run_ops
      md: remove raid5 compute_block and compute_parity5
      dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
      iop13xx: surface the iop13xx adma units to the iop-adma driver
      iop3xx: surface the iop3xx DMA and AAU units to the iop-adma driver
      ARM: Add drivers/dma to arch/arm/Kconfig
      ioatdma: add the unisys "i/oat" pci vendor/device id

Jeff Garzik (1):
      drivers/dma: handle sysfs errors

 Documentation/networking/ip-sysctl.txt |    6 +
 arch/arm/Kconfig                       |    2 +
 arch/arm/mach-iop13xx/setup.c          |  217 +++-
 arch/arm/mach-iop32x/glantank.c        |    2 +
 arch/arm/mach-iop32x/iq31244.c         |    5 +
 arch/arm/mach-iop32x/iq80321.c         |    3 +
 arch/arm/mach-iop32x/n2100.c           |    2 +
 arch/arm/mach-iop33x/iq80331.c         |    3 +
 arch/arm/mach-iop33x/iq80332.c         |    3 +
 arch/arm/plat-iop/Makefile             |    2 +
 arch/arm/plat-iop/adma.c               |  209 +++
 crypto/Kconfig                         |   12 +-
 crypto/Makefile                        |    6 +
 crypto/async_tx/Kconfig                |   16 +
 crypto/async_tx/Makefile               |    4 +
 crypto/async_tx/async_memcpy.c         |  131 ++
 crypto/async_tx/async_memset.c         |  109 ++
 crypto/async_tx/async_tx.c             |  497 ++++++
 crypto/async_tx/async_xor.c            |  327 ++++
 {drivers/md => crypto}/xor.c           |   55 +-
 drivers/dma/Kconfig                    |   12 +-
 drivers/dma/Makefile                   |    1 +
 drivers/dma/dmaengine.c                |  419 ++++--
 drivers/dma/ioatdma.c                  |  369 +++---
 drivers/dma/ioatdma.h                  |   16 +-
 drivers/dma/ioatdma_io.h               |  118 --
 drivers/dma/iop-adma.c                 | 1467 +++++++++++++++++
 drivers/md/Kconfig                     |    2 +
 drivers/md/Makefile                    |    4 +-
 drivers/md/md.c                        |    2 +-
 drivers/md/raid5.c                     | 2727 ++++++++++++++++++++------------
 include/asm-arm/arch-iop13xx/adma.h    |  544 +++++++
 include/asm-arm/arch-iop13xx/iop13xx.h |   38 +-
 include/asm-arm/arch-iop32x/adma.h     |    5 +
 include/asm-arm/arch-iop33x/adma.h     |    5 +
 include/asm-arm/hardware/iop3xx-adma.h |  892 +++++++++++
 include/asm-arm/hardware/iop3xx.h      |   68 +-
 include/asm-arm/hardware/iop_adma.h    |  118 ++
 include/linux/async_tx.h               |  156 ++
 include/linux/dmaengine.h              |  293 +++--
 include/linux/pci_ids.h                |    3 +
 include/linux/raid/raid5.h             |   97 ++-
 include/linux/raid/xor.h               |    5 +-
 net/core/dev.c                         |  112 +-
 net/ipv4/tcp.c                         |   26 +-
 45 files changed, 7362 insertions(+), 1748 deletions(-)

