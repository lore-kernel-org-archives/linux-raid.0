From: Yuri Tikhonov <yur@emcraft.com>
Subject: dmaengine: fix dependency chaining
Date: Tue, 13 Jan 2009 00:22:50 +0300
Message-ID: <200901130022.50231.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, dzu@denx.de, wd@denx.de, Ilya Yanok <yanok@emcraft.com>
List-Id: linux-raid.ids

In dmaengine we track the dependencies between the descriptors
using the 'next' pointers of the structure. These pointers are
set to NULL as soon as the corresponding descriptor has been
submitted to the channel (in dma_run_dependencies()).

But, the first 'next' in chain is still remaining set, regardless
the fact, that tx->next has been already submitted. This may lead to
multiple submissions of the same descriptor. This patch fixes this.

Actually, some previous implementation of the xxx_run_dependencies()
function already had this fix in place. The fdb..0eaf3 commit, beside the
correct things, broke this.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
---
 drivers/dma/dmaengine.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 403dbe7..6df144a 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -961,6 +961,8 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx)
 	if (!dep)
 		return;
 
+	/* we'll submit tx->next now, so clear the link */
+	tx->next = NULL;
 	chan = dep->chan;
 
 	/* keep submitting up until a channel switch is detected
-- 
1.6.0.6

