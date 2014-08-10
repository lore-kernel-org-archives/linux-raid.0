From: <stockhausen@collogia.de>
Subject: [PATCH v1 5/8]     async_pq: add logic for improved rmw syndrome calculation
Date: Sun, 10 Aug 2014 11:56:53 +0000
Message-ID: <bf274981-f9a5-4535-930e-9fb44ad8c7dd@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-c33ed49d-21b7-4183-8cfa-35f0a9dae48a"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-c33ed49d-21b7-4183-8cfa-35f0a9dae48a
Content-Type: text/plain

commit 8dc90c15e1cccd6d17dc056ada38aba8879c914f
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Sun Aug 10 09:41:57 2014 +0000

    async_pq: add logic for improved rmw syndrome calculation
    
    raid5 uses async syndrome functions where possible. Adapt that
    layer so we have a seamless integration of the new xor_syndrome()
    calls. This is achieved by introducing the new submit flag
    ASYNC_TX_PQ_XOR_DST. If it is active the caller wants to factor
    in/out blocks of the syndrome.
    
    For now we focus on the synchronous implementation as the DMA
    assisted feature cannot be tested. The only known device to support
    P/Q calculation is an IOP13XX. See arch/arm/mach-iop13xx/setup.c.
    An implementation of the RAID6 rmw cycle will therefore always run
    on the CPU.
    
    The patch will determine the first and the last block within a
    stripe that conatins changed data. These parameters are handed over
    to xor_syndrome() that can avoid unneeded CPU cycles. To use this
    feature the caller must fill NULL pointers for data pages that
    won't change during a rmw run.

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index d05327c..52922d8 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -124,6 +124,7 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 {
 	void **srcs;
 	int i;
+	int start = -1, stop = disks - 3;
 
 	if (submit->scribble)
 		srcs = submit->scribble;
@@ -134,10 +135,21 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 		if (blocks[i] == NULL) {
 			BUG_ON(i > disks - 3); /* P or Q can't be zero */
 			srcs[i] = (void*)raid6_empty_zero_page;
-		} else
+		} else {
 			srcs[i] = page_address(blocks[i]) + offset;
+			if (i < disks - 2) {
+				stop = i;
+				if (start == -1)
+					start = i;
+			}
+		}
 	}
-	raid6_call.gen_syndrome(disks, len, srcs);
+	if (submit->flags & ASYNC_TX_PQ_XOR_DST) {
+		BUG_ON(!raid6_call.hasxor);
+		if (start >= 0)
+			raid6_call.xor_syndrome(disks, start, stop, len, srcs);
+	} else
+		raid6_call.gen_syndrome(disks, len, srcs);
 	async_tx_sync_epilog(submit);
 }
 
@@ -178,7 +190,8 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 	if (device)
 		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
 
-	if (unmap &&
+	/* XORing P/Q is only implemented in software */
+	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
 	    (src_cnt <= dma_maxpq(device, 0) ||
 	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
 	    is_dma_pq_aligned(device, offset, 0, len)) {
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 179b38f..388574e 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -60,12 +60,15 @@ struct dma_chan_ref {
  * dependency chain
  * @ASYNC_TX_FENCE: specify that the next operation in the dependency
  * chain uses this operation's result as an input
+ * @ASYNC_TX_PQ_XOR_DST: do not overwrite the syndrome but XOR it with the
+ * input data. Required for rmw case.
  */
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
 	ASYNC_TX_XOR_DROP_DST	 = (1 << 1),
 	ASYNC_TX_ACK		 = (1 << 2),
 	ASYNC_TX_FENCE		 = (1 << 3),
+	ASYNC_TX_PQ_XOR_DST	 = (1 << 4),
 };
 
 /**

------=_NextPartTM-000-c33ed49d-21b7-4183-8cfa-35f0a9dae48a
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-c33ed49d-21b7-4183-8cfa-35f0a9dae48a--
