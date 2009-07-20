From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: DMA zeroing destination and zero_sum support
Date: Mon, 20 Jul 2009 15:11:08 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07BC569D@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dan,
   There may be an issue when ADMA doesn't support
xxxx_prep_dma_zero_sum() support    OR  not setting destinations to zero
(ASYNC_TX_XOR_ZERO_DST) . Could you please comment on what are issues on
not zeroing dest when ASYNC_TX_XOR_ZERO_DST is set.
Thanks,
Marri
