From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Date: Thu, 20 Sep 2007 18:27:35 -0700
Message-ID: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Cc: akpm@linux-foundation.org, yur@emcraft.com, saeed.bishara@gmail.com, shannon.nelson@intel.com
List-Id: linux-raid.ids

Fix a couple bugs and provide documentation for the async_tx api.

Neil, please 'ack' patch #3.

git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus

Dan Williams (3):
      async_tx: usage documentation and developer notes
      async_tx: fix dma_wait_for_async_tx
      raid5: fix ops_complete_biofill

Documentation/crypto/async-tx-api.txt |  217 +++++++++++++++++++++++++++++++++
crypto/async_tx/async_tx.c            |   12 ++-
drivers/md/raid5.c                    |   90 +++++++-------
3 files changed, 273 insertions(+), 46 deletions(-)

--
Dan
