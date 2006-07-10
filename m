From: "Christian Pernegger" <pernegger@gmail.com>
Subject: ICH7 sata-ahci + software raid warning
Date: Mon, 10 Jul 2006 18:48:32 +0200
Message-ID: <bb145bd20607100948y2f41e034re3c0fb30c8bd1ad5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm (still) trying to setup a md array on the ICH7 SATA controller of
an Intel SE7230NH1-E with 4 WD5000YS disks.

On this controller (in ahci mode) I have not yet managed to get a disk
mark as failed.

- a bad cable just led to hangs and timeouts
- pulling the power on one of the SATA drives (while the system is running)
  had the exact same result.

Apparently the error handling up to 2.6.17 is so buggy that it never
returns an error that might cause md to fail the disk. (Bad blocks
maybe, can't test that.)

Regards,

C.
