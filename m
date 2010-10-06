From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Raid 6 - TLER/CCTL/ERC
Date: Thu, 07 Oct 2010 09:14:50 +1300
Message-ID: <4CACD8BA.2020106@sauce.co.nz>
References: <556404795.674.1286344296358.JavaMail.root@mail.networkmayhem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <556404795.674.1286344296358.JavaMail.root@mail.networkmayhem.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Zieba wrote:

>   - AOC-USAS-L8i Controller

> I could not pass them through the controller I was using, but was able to connect the drives to the controller on the motherboard, set the erc values, and still have drives dropping out.

This controller uses the LSI 1068 controller chip and up until kernel 
2.6.36, is likely to offline attached drives if smartctl or smartd is used.

If you update to this kernel or later , or apply the one line patch to 
the LSI driver in earlier ones, you will be able to safely use these 
monitoring utilities.

Patch as outined by the author on  the bug list and subsequently 
accepted by LSI:


"It seems the mptsas driver could use blk_queue_dma_alignment() to advertise
a stricter alignment requirement.  If it does, sd does the right thing and
bounces misaligned buffers (see block/blk-map.c line 57).  The following
patch to 2.6.34-rc5 makes my symptoms go away.  I'm sure this is the wrong
place for this code, but it gets my idea across."

diff --git a/drivers/message/fusion/mptscsih.c 
b/drivers/message/fusion/mptscsih.c
index 6796597..1e034ad 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2450,6 +2450,8 @@ mptscsih_slave_configure(struct scsi_device *sdev)
                 ioc->name,sdev->tagged_supported, sdev->simple_tags,
                 sdev->ordered_tags));

+       blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
+
         return 0;
  }


Regards,

Richard
