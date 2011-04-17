From: saeed bishara <saeed.bishara@gmail.com>
Subject: RAID/dmaengine violates the dma-streaming API
Date: Sun, 17 Apr 2011 19:00:52 +0300
Message-ID: <BANLkTinMA_U1r6K4t8UZKUr4nZBsWPSv9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-raid.ids

Hi,
     when md uses the dma for offloading xor and memcpy operations, it
violates the dma-mapping API.  here is the scenario I'm taking about
(under write to degraded raid5):
1. ops_run_prexor sends xor operation from buffers A and B, and the
destination is A.
2. ops_run_biodrain: sends mempcy operation from C to B.
3. ops_run_reconstruct5: sends xor operation from A and B, and the
destination is A again.

in step 1, the async tx maps A using dma_map_page, and in step 3, it
maps again the same buffer. but, if the request from step 1 still
being handled the dma engine, then we end with a case where the buffer
mapped while it still belongs to the dma hw.
when the arch is ARMv6/SMP mode (without io coherency), the cache
maintenance involves read/write access to the buffers, that means, the
second mapping above may access the buffer(with read/write) while the
dma is writing to it!!.

also, from performance sake, it would be great if this multiple
mappings get avoided.

saeed
