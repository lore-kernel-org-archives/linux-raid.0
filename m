From: Markus <M4rkusXXL@web.de>
Subject: future of raid 6
Date: Sun, 03 Sep 2017 20:28:15 +0200
Message-ID: <2811558.CnJCJrJZ21@markus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I have one question (maybe more) regarding the raid development. Especially 
raid 6 and better.
I read in some articles[1] that raid 6 will become worse as the size of the 
disks grow but the (unrecoverable) error rate and data rate do not improve as 
much. (Rebuilds are likely to hit an unrecoverable error, not to mention the 
long time it will take to rebuild raids with +10TB per drive.)
They estimated 2019 (that was written ten years ago).

Is there already something in progress for the md-raid in linux kernel?
	If so what and where?
	If not, why? Is it not needed yet? Is md-raid itself depreciated?
	What is the future for redundant mass storage?


Best regards,
Markus


[1] http://queue.acm.org/detail.cfm?id=1670144

