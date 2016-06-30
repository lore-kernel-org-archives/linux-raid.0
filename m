From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2 00/12] gendisk: Generate uevent after attribute available
Date: Thu, 30 Jun 2016 09:59:41 +0800
Message-ID: <20160630015953.6888-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, Keith Busch <keith.busch@intel.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, Nitin Gupta <ngupta@vflare.org>, famz@redhat.com, Jiri Kosina <jikos@kernel.org>, linux-block@vger.kernel.org, "Ed L. Cashin" <ed.cashin@acm.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, linux-mmc@vger.kernel.org, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, Brian Norris <computersforpeace@gmail.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-raid.ids

The race condition is noticed between disk_add() and disk attributes, on
virtio-blk hotplug.

Userspace listens to the KOBJ_ADD uevent generated in add_disk(). At that
point we haven't created the serial attribute file, therefore depending
on how fast udev reacts, the /dev/disk/by-id/ entry doesn't always get
created.

As pointed out by Christoph Hellwig in the specific fix [1], virtio-blk is not
the only driver that suffers from this, so we cannot count on every driver to
send events manually. Moreover as suggested in uevent documentation, it is
advised to defer the KOBJ_ADD event until all attributes are ready:

Documentation/kobject.txt:
> Use the KOBJ_ADD action for when the kobject is first added to the kernel.
> This should be done only after any attributes or children of the kobject
> have been initialized properly, as userspace will instantly start to look
> for them when this call happens.

Unfortunately it seems impossible to fix this generally without touching the
offending callers.  The approach I'm proposing here is adding a flag to
suppress uevent in add_disk(), which is patch 1, then in later patches, convert
any caller to only trigger the uevent when attributes are added.

[1] https://lkml.org/lkml/2016/6/28/550

Fam Zheng (12):
  genhd: Add "gen_uevent" parameter to add_disk
  genhd: Honor gen_uevent and add disk_gen_uevents
  virtio-blk: Generate uevent after attribute available
  axonrom: Generate uevent after attribute available
  aoeblk: Generate uevent after attribute available
  mtip32xx: Generate uevent after attribute available
  pktcdvd: Generate uevent after attribute available
  zram: Generate uevent after attribute available
  md: Generate uevent after attribute available
  mmc: Generate uevent after attribute available
  mtd: Generate uevent after attribute available
  nvme: Generate uevent after attribute available

 arch/m68k/emu/nfblock.c                     |  2 +-
 arch/powerpc/sysdev/axonram.c               |  3 ++-
 arch/um/drivers/ubd_kern.c                  |  2 +-
 arch/xtensa/platforms/iss/simdisk.c         |  2 +-
 block/genhd.c                               | 26 +++++++++++++++++++++-----
 drivers/block/DAC960.c                      |  2 +-
 drivers/block/amiflop.c                     |  2 +-
 drivers/block/aoe/aoeblk.c                  |  3 ++-
 drivers/block/ataflop.c                     |  2 +-
 drivers/block/brd.c                         |  4 ++--
 drivers/block/cciss.c                       |  2 +-
 drivers/block/drbd/drbd_main.c              |  2 +-
 drivers/block/floppy.c                      |  2 +-
 drivers/block/hd.c                          |  2 +-
 drivers/block/loop.c                        |  2 +-
 drivers/block/mg_disk.c                     |  2 +-
 drivers/block/mtip32xx/mtip32xx.c           |  3 ++-
 drivers/block/nbd.c                         |  2 +-
 drivers/block/null_blk.c                    |  2 +-
 drivers/block/osdblk.c                      |  2 +-
 drivers/block/paride/pcd.c                  |  2 +-
 drivers/block/paride/pd.c                   |  2 +-
 drivers/block/paride/pf.c                   |  2 +-
 drivers/block/pktcdvd.c                     |  4 +++-
 drivers/block/ps3disk.c                     |  2 +-
 drivers/block/ps3vram.c                     |  2 +-
 drivers/block/rbd.c                         |  2 +-
 drivers/block/rsxx/dev.c                    |  2 +-
 drivers/block/skd_main.c                    |  2 +-
 drivers/block/sunvdc.c                      |  2 +-
 drivers/block/swim.c                        |  2 +-
 drivers/block/swim3.c                       |  2 +-
 drivers/block/sx8.c                         |  2 +-
 drivers/block/umem.c                        |  2 +-
 drivers/block/virtio_blk.c                  |  3 ++-
 drivers/block/xen-blkfront.c                |  2 +-
 drivers/block/xsysace.c                     |  2 +-
 drivers/block/z2ram.c                       |  2 +-
 drivers/block/zram/zram_drv.c               |  3 ++-
 drivers/cdrom/gdrom.c                       |  2 +-
 drivers/ide/ide-cd.c                        |  2 +-
 drivers/ide/ide-gd.c                        |  2 +-
 drivers/lightnvm/core.c                     |  2 +-
 drivers/md/bcache/super.c                   |  4 ++--
 drivers/md/dm.c                             |  2 +-
 drivers/md/md.c                             |  3 ++-
 drivers/memstick/core/ms_block.c            |  2 +-
 drivers/memstick/core/mspro_block.c         |  2 +-
 drivers/mmc/card/block.c                    |  3 ++-
 drivers/mtd/mtd_blkdevs.c                   |  3 ++-
 drivers/mtd/ubi/block.c                     |  2 +-
 drivers/nvdimm/blk.c                        |  2 +-
 drivers/nvdimm/btt.c                        |  2 +-
 drivers/nvdimm/pmem.c                       |  2 +-
 drivers/nvme/host/core.c                    |  3 ++-
 drivers/s390/block/dasd_genhd.c             |  2 +-
 drivers/s390/block/dcssblk.c                |  2 +-
 drivers/s390/block/scm_blk.c                |  2 +-
 drivers/s390/block/xpram.c                  |  2 +-
 drivers/sbus/char/jsflash.c                 |  2 +-
 drivers/scsi/sd.c                           |  2 +-
 drivers/scsi/sr.c                           |  2 +-
 drivers/staging/lustre/lustre/llite/lloop.c |  2 +-
 include/linux/genhd.h                       |  3 ++-
 64 files changed, 98 insertions(+), 70 deletions(-)

-- 
2.9.0
