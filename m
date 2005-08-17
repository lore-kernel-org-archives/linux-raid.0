From: Ricky <rickycheng@qnap.com.tw>
Subject: [2.4.30] raidstop command hang until recovering of raid 1 finished.
Date: Wed, 17 Aug 2005 03:49:39 +0000 (UTC)
Message-ID: <loom.20050817T053936-734@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, this is Ricky

I have a problem in kernel version 2.4.30. When I try to raidstop /dev/mdx, it 
will hang on until recovering of raid 1 finished.
 
raitstop will go on when finishing recovering of raid.
it will show "md: ioctl lock interrupted, reason -4, cmd 2354"

But the same step I did in kernel version 2.4.18
Everything will be ok....

Thx.
Ricky

