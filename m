From: lylai <lylai@csie.nctu.edu.tw>
Subject: building network software raid
Date: 22 May 2002 00:52:17 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1021999937.3067.15.camel@chiayi.csie.nctu.edu.tw>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm a student doing an OS project: build a software raid over the
network.

I intend to use existing software RAID program. The plan is that build
the raid on a device that is not a real physical device, but a device I
made up. I'll handle the I/O request through the network.

I already wrote a simple device driver with all the required functions,
and try to "mkraid" on the created new devices. But it failed with
error:

	/dev/md0: Invalid arguments

I want to know what information is needed to make mkraid, ... etc. run
properly that they see it as a true hard disk. And what operations are
needed to pass these information out.

Thank you for your advices.


