From: Eivind Sarto <eivindsarto@gmail.com>
Subject: md/raid5.c and STRIPE_IO_STARTED
Date: Mon, 10 Feb 2014 13:53:46 -0800
Message-ID: <92C24A71-5C61-420E-A7EB-3D3B8492E77C@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@gmail.com
List-Id: linux-raid.ids

I am looking at drivers/md/raid5.c and I noticed that the flag STRIPE_IO_STARTED is only set and not cleared.
The flag only gets cleared in init_stripe() if a stripe is re-initialized.

Shouldn't it also be cleared whenever the current batch of IOs complete for each stripe?

I'm currently working with SLES11 SP3, but the same should also be the case in latest kernel.org.

-eivind

