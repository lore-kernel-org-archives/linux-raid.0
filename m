From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: where is async_tx_clear_ack() function called.
Date: Thu, 9 Jul 2009 16:36:55 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07B08A8F@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dan,
    While I was debugging file system crash with AMCC ADMA driver , I
noticed that async_tx_clear_ack() never been called. Where is the
async_tx->flags is cleared up on completion of DMA transfer ? Looks like
this not cleared and I am hitting the BUG_ON() in async_tx_submit(). If
I call async_tx_clear_ack() in ppc4xx_ adma_free_slots() function
everything seems working fine .  

This doesn't sound normal something is going on. Somehow descriptors are
allocated even though they are not free .

Thanks and Regards,
Marri

