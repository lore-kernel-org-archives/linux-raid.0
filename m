From: "bmoon" <bo@anthologysolutions.com>
Subject: Why I couldn't turn the DMA mode on ?
Date: Thu, 19 Jun 2003 20:56:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00bc01c336df$fdfa92d0$6b01a8c0@bmoon>
References: <200306191914.52921.nick@byu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I rebuilt kernel with 2.4.20 with patch ,
then I can not set the DMA mode on my 
hda drive.

> hdparm -d 1 /dev/hda
/dev/hda:
  setting using_dma to 1(on)
  HDIO_SET_DMA failed: Operation not permitted
 using_dma = 0 (off)

I have no problem with old REDHAT7.1.

From my .config,

CONFIG_BLK_DEV_IDEDMA_PCI = y
# CONFIG_BLK_DEV_IDEDMA_FORCED
CONFIG_IDEDMA_PCI_AUTO = y
CONFIG_BLK_IDEDMA = y

Any comment or suggestion?


Bo
