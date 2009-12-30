From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] dmaengine/async_tx fixes for 2.6.33-rc3
Date: Wed, 30 Dec 2009 14:22:12 -0700
Message-ID: <1262208132.32461.48.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Maciej Sosnowski <maciej.sosnowski@intel.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Hi Linus, please pull from:

     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

Dan Williams (4):
      ioat3: fix p-disabled q-continuation
      async_tx: expand async raid6 test to cover ioatdma corner case
      ioat2,3: put channel hardware in known state at init
      Merge branch 'ioat' into fixes

Guennadi Liakhovetski (1):
      sh: fix DMA driver's descriptor chaining and cookie assignment

Julia Lawall (2):
      drivers/dma: drop unnecesary memset
      drivers/dma: Correct use after free

Nicolas Ferre (1):
      dma: at_hdmac: correct incompatible type for argument 1 of 'spin_lock_bh'

1/ A shdma fix from Guennadi that has been pending for a while, but
finally acked by the original driver author.
2/ Some Coccinelle fixes from Julia.
3/ A typo fix in at_hdmac from Nicolas.
4/ Two ioatdma driver fixes, one for a kexec reboot regression reported
by Roland, and a descriptor processing error when performing raid
recovery on a 11 or 12-disk raid6 array.

All of these have been in -next for a week or so.  Maciej has also
recently acked them, but to preserve the commit-ids I did not rebase.

 crypto/async_tx/raid6test.c  |    7 +
 drivers/dma/at_hdmac.c       |    4 +-
 drivers/dma/coh901318.c      |    2 +-
 drivers/dma/dw_dmac.c        |    2 -
 drivers/dma/ioat/dma.c       |    2 +-
 drivers/dma/ioat/dma.h       |   18 +++
 drivers/dma/ioat/dma_v2.c    |   69 +++++++---
 drivers/dma/ioat/dma_v2.h    |    2 +
 drivers/dma/ioat/dma_v3.c    |   60 ++++++--
 drivers/dma/ioat/registers.h |    1 +
 drivers/dma/shdma.c          |  324 +++++++++++++++++++++++++++---------------
 drivers/dma/shdma.h          |    9 +-
 12 files changed, 341 insertions(+), 159 deletions(-)

One note, this diffstat was created by hand via a test merge branch as
the one created by 'git request-pull' was:

     806 files changed, 13676 insertions(+), 6334 deletions(-)

Not sure where that came from, the 'fixes' branch was based on
2.6.32-rc6 while the ioat changes were based on 2.6.32.

--
Dan


commit f80ca163d65903276bec7045a484a79c0897eb2d
Merge: 0794ec8 a6d52d7
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Dec 22 17:21:47 2009 -0700

    Merge branch 'ioat' into fixes

commit 0794ec8ce327ec74416b569b8fb1951274693700
Author: Julia Lawall <julia@diku.dk>
Date:   Tue Dec 22 21:30:59 2009 +0100

    drivers/dma: Correct use after free
    
    Move the kfree after the iounmap that refers to the same structure.
    
    A simplified version of the semantic match that finds this problem is as
    follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    expression x,e;
    identifier f;
    iterator I;
    statement S;
    @@
    
    *kfree(x);
    ... when != &x
        when != x = e
        when != I(x,...) S
    *x->f
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1e9d1b13efae7e0a2705611d47ae5f07e27015f0
Author: Julia Lawall <julia@diku.dk>
Date:   Sat Dec 19 08:30:30 2009 +0100

    drivers/dma: drop unnecesary memset
    
    memset of 0 is not needed after kzalloc
    
    The semantic patch that makes this change is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    expression x;
    statement S;
    @@
    
    x = kzalloc(...);
    if (x == NULL) S
    ... when != x
    -memset(x,0,...);// </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a6d52d70677e99bdb89b6921c265d0a58c22e597
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Dec 19 15:36:02 2009 -0700

    ioat2,3: put channel hardware in known state at init
    
    Put the ioat2 and ioat3 state machines in the halted state with all
    errors cleared.
    
    The ioat1 init path is not disturbed for stability, there are no
    reported ioat1 initiaization issues.
    
    Cc: <stable@kernel.org>
    Reported-by: Roland Dreier <rdreier@cisco.com>
    Tested-by: Roland Dreier <rdreier@cisco.com>
    Acked-by: Simon Horman <horms@verge.net.au>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e02a0e47a3f061c1a53fc4376332a988ec047e8a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Dec 17 13:55:38 2009 -0700

    async_tx: expand async raid6 test to cover ioatdma corner case
    
    Add explicit 11 and 12 disks cases to exercise the 0 < src_cnt % 8 < 3
    corner case in the ioatdma driver.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit cd78809f6191485a90ea6c92c2b58900ab5c156f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Dec 17 13:52:39 2009 -0700

    ioat3: fix p-disabled q-continuation
    
    When continuing a pq calculation the driver needs 3 extra sources.  The
    driver can perform a 3 source calculation with a single descriptor, but
    needs an extended descriptor to process up to 8 sources in one
    operation.  However, in the p-disabled case only one extra source is
    needed.  When continuing a p-disabled operation there are occasions
    (i.e. 0 < src_cnt % 8 < 3) where the tail operation does not need an
    extended descriptor.  Properly account for this fact otherwise invalid
    'dmacount' values will be written to hardware usually causing the
    channel to halt with 'invalid descriptor' errors.
    
    Cc: <stable@kernel.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3542a113ab2f5880f1b62e5909d754250fb57d6b
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Thu Dec 17 09:41:39 2009 -0700

    sh: fix DMA driver's descriptor chaining and cookie assignment
    
    The SH DMA driver wrongly assigns negative cookies to transfer descriptors,
    also, its chaining of partial descriptors is broken. The latter problem is
    usually invisible, because maximum transfer size per chunk is 16M, but if you
    artificially set this limit lower, the driver fails. Since cookies are also
    used in chunk management, both these problems are fixed in one patch. As side
    effects a possible memory leak, when descriptors are prepared, but not
    submitted, and multiple races have also been fixed.
    
    Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Acked-by: Paul Mundt <lethal@linux-sh.org>
    Acked-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4297a462f455e38f08976df7b16c849614a287da
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Wed Dec 16 16:28:03 2009 +0100

    dma: at_hdmac: correct incompatible type for argument 1 of 'spin_lock_bh'
    
    Correct a typo error in locking calls.
    
    Cc: <stable@kernel.org>
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>



