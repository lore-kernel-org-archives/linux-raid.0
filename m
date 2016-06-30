From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2 07/12] pktcdvd: Generate uevent after attribute available
Date: Thu, 30 Jun 2016 09:59:48 +0800
Message-ID: <20160630015953.6888-8-famz@redhat.com>
References: <20160630015953.6888-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20160630015953.6888-1-famz@redhat.com>
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

It is documented that KOBJ_ADD should be generated after the object's
attributes and children are ready.  We can achieve this with the new
disk_gen_uevents interface.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 drivers/block/pktcdvd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 00928406..a4e6bb7 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2785,11 +2785,13 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	disk->events = pd->bdev->bd_disk->events;
 	disk->async_events = pd->bdev->bd_disk->async_events;
 
-	add_disk(disk, true);
+	add_disk(disk, false);
 
 	pkt_sysfs_dev_new(pd);
 	pkt_debugfs_dev_new(pd);
 
+	disk_gen_uevents(disk);
+
 	pkt_devs[idx] = pd;
 	if (pkt_dev)
 		*pkt_dev = pd->pkt_dev;
-- 
2.9.0
