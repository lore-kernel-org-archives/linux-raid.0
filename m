From: "Suresh Vishnu" <Vishnu@freescale.com>
Subject: fsldma fails on latest async/next
Date: Wed, 31 Dec 2008 18:01:19 +0530
Message-ID: <E585710C42F48B4AB2836DA395185DE3644F@zin33exm21.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I was testing the fsldma driver on the next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx tree.
The driver fails to work.

Initially the driver was failing because alloc_chan_resource was
returning the number of allocated descriptors on success (instead of 0).

This has been rectified. Even after this correction, the driver does not
work.

What are the logical changes to the async layer from the master branch?

--
Vishnu Suresh 
