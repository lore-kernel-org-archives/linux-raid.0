From: Rajasekhar Pulluru <pullururajasekhar@gmail.com>
Subject: async_tx and RAID HW xor engine
Date: Mon, 30 Apr 2012 15:35:30 +0530
Message-ID: <CAGA5_H55asVEekOd1ae2OjkK07W5Okf1iTCg10oRSX4+M7FLEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to understand how are hardware xor engine's utilized by
async_tx module. I don't get the exact link that connects async_tx and
hardware xor engine.
Could someone help me understand it.

Registration of a RAID HW XOR engine happens in
drivers/dma/<soc-xor.c> using dma_async_device_register(). Does this
registration function connect the async_tx api's
to use the HW XOR engine? Or is there anything we need to support to
make async_tx api's to take advantage of the hardware XOR engine?

Thanks & Regards,
Rajasekhar
