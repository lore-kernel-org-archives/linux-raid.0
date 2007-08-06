From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [RFT] 2.6.22.1-iop1 for improved sequential write performance (stripe-queue)
Date: Mon, 6 Aug 2007 14:59:09 -0700
Message-ID: <e9c3a7c20708061459u22f25567v6baeda12ca673664@mail.gmail.com>
References: <e9c3a7c20707191717s4809eab1s4966f7e0c21c6424@mail.gmail.com>
	 <Pine.LNX.4.64.0708041049420.14065@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708041049420.14065@filesrv1.baby-dragons.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/4/07, Mr. James W. Laferriere <babydr@baby-dragons.com> wrote:
>         Hello Dan ,
>
> On Thu, 19 Jul 2007, Dan Williams wrote:
> > Per Bill Davidsen's request I have made available a 2.6.22.1 based
> > kernel with the current raid5 performance changes I have been working
> > on:
> > 1/ Offload engine acceleration (recently merged for the 2.6.23
> > development cycle)
> > 2/ Stripe-queue, an evolutionary change to the raid5 queuing model (take4)
> >
> > The offload engine work only helps platforms with offload engines and
> > should not affect performance otherwise.  The stripe-queue work is an
> > attempt to increase sequential write performance and should benefit
> > most platforms.
> >
> > The patch series is available on the Xscale(r) IOP SourceForge page:
> >       http://downloads.sourceforge.net/xscaleiop/patches-2.6.22.1-iop1-x86fix.tar.gz
> >
> > Use quilt to apply the series on top of a fresh 2.6.22.1 source tree:
> > $ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
> > $ tar xjf linux-2.6.22.1.tar.bz2
> > $ cd linux-2.6.22.1
> > $ tar xzvf patches-2.6.22.1-iop1.tar.gz
> > $ cp patches/series.x86 patches/series
> > $ quilt push -a
> >
> > Configure and build the kernel as normal, there are no configuration
> > options for stripe-queue.
> > Any feedback, bug report, fix, or suggestion is welcome.
>
>         Following these instructions .  With 2.6.22.1 gets me the below(*) .
>         Undoubtedly I have missed some message that said us a differnat pathset
> or something along those lines .
I believe you inadvertently used the series file with xscale specific
patches.  The patch that is causing your compile failures is
"iop13xx-pci-sysfs-mmap.patch".  Try 'quilt pop -a' then verify that
your series file looks like the following:

# This series applies on GIT commit 7dcca30a32aadb0520417521b0c44f42d09fe05c
iop13xx-add-iop-attr-for-tpmi.patch
iop-section-mismatch.patch
has-dma-compilation-fix.patch
# comment out the following patch for an x86 build
#iop13xx-workaround-uart-iir-errata.patch
arm-allow-dma-none.patch
ioatdma-push-pending-4.patch
ioatdma-sysfs-errors.patch
ioatdma-kill-register-access-wrappers.patch
ioatdma-killwriteq.patch
ioatdma-document-tcp_dma_copybreak.patch
ioatdma-only-offload-at-context-switch.patch
ioatdma-warning-fix.patch
ioat-kexec-fix.patch
ioat-unisys-pciid.patch
dmaengine-dma_async_tx_descriptor-refactor.patch
dmaengine-client-channel-management.patch
xor-move.patch
add-the-async_tx-api.patch
raid5-refactor.patch
raid5-pr_debug.patch
md-add-raid5_run_ops.patch
md-enable-raid5_run_ops.patch
md-async-write-operations.patch
md-async-compute-operations.patch
md-async-check-operations.patch
md-async-read-operations.patch
md-async-expand-operations.patch
md-move-io-to-raid5_run_ops.patch
md-remove-compute_block-and-compute_parity5.patch
iop-adma-device-driver.patch
iop13xx-adma-support.patch
iop3xx-adma-support.patch
arm-add-drivers-dma.patch
iop-watchdog.patch
i2c-m41st85w.patch
iop13xx-imu.patch
iop13xx-imu-scsi.patch
iop13xx-imu-directed-core-reset.patch
iop13xx-xsc3-oprofile.patch
# comment out the following patch for an x86 build
#iop13xx-pci-sysfs-mmap.patch
iop13xx-pmon-oprofile.patch
arm-udivdi3.patch
pbi_compact_flash.patch
# comment out the following patch for an x86 build
#dma-copy-clear-page.patch
# comment out the following patch for an x86 build
#try-dma-memcpy.patch
# comment out the following patch for an x86 build
#try-dma-copy-to-user.patch
# comment out the following patch for an x86 build
#try-dma-copy-from-user.patch
isc813xx.patch
iop-defconfig-update.patch
# comment out the following patch for an x86 build
#iop-cross-compile-default.patch
raid5-stripe-queue-intro.patch
raid5-stripe-queue-tree.patch
v2.6.22.1-iop1.patch

Regards,
Dan
