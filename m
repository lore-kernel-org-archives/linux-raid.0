From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] block: make sure FSEQ_DATA request has the same rq_disk as
 the original
Date: Thu, 02 Sep 2010 19:43:45 +0200
Message-ID: <4C7FE251.2020003@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org> <4C7DFD8F.6070200@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C7DFD8F.6070200@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

rq->rq_disk and bio->bi_bdev->bd_disk may differ if a request has
passed through remapping drivers.  FSEQ_DATA request incorrectly
followed bio->bi_bdev->bd_disk ending up being issued w/ mismatching
rq_disk.  Make it follow orig_rq->rq_disk.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
---
Kiyoshi, can you please apply this patch on top and verify that the
problem goes away?  The reason I and Mike didn't see the problem was
because we were using REQ_FUA capable underlying device, which makes
block layer bypass sequencing for FSEQ_DATA request.

Thanks.

 block/blk-flush.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: block/block/blk-flush.c
===================================================================
--- block.orig/block/blk-flush.c
+++ block/block/blk-flush.c
@@ -111,6 +111,13 @@ static struct request *queue_next_fseq(s
 		break;
 	case QUEUE_FSEQ_DATA:
 		init_request_from_bio(rq, orig_rq->bio);
+		/*
+		 * orig_rq->rq_disk may be different from
+		 * bio->bi_bdev->bd_disk if orig_rq got here through
+		 * remapping drivers.  Make sure rq->rq_disk points
+		 * to the same one as orig_rq.
+		 */
+		rq->rq_disk = orig_rq->rq_disk;
 		rq->cmd_flags &= ~(REQ_FLUSH | REQ_FUA);
 		rq->cmd_flags |= orig_rq->cmd_flags & (REQ_FLUSH | REQ_FUA);
 		rq->end_io = flush_data_end_io;
