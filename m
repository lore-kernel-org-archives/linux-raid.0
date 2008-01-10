From: Dennison Williams <evoltech@2inches.com>
Subject: The effects of multiple layers of block drivers
Date: Thu, 10 Jan 2008 14:58:49 -0800
Message-ID: <4786A329.90702@2inches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am starting to dig into the Block subsystem to try and uncover the
reason for some data I lost recently.  My situation is that I have
multiple block drivers on top of each other and am wondering how the
effectss of a raid 5 rebuild would affect the block devices above it.

The layers are raid 5 -> lvm -> cryptoloop.  It seems that after the
raid 5 device was rebuilt by adding in a new disk, that the cryptoloop
doesn't have a valid ext3 partition on it.

As a raid device re-builds is there ant rearranging of sectors or
corresponding blocks that would effect another block device on top of it?

Sincerely,
Dennison Williams
