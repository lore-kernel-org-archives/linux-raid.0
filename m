From: Nathan Lewis <nathapl@cs.okstate.edu>
Subject: Testing md modules?
Date: Thu, 26 Feb 2004 23:43:29 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.2.20040226233706.0290bec0@mail.athenet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm to the point now where my Reed-Solomon code appears to be working, at 
least for some simple tests I've thrown at it.  I'd like to test it more 
exhaustively - does anybody have any scripts or programs that work 
deterministicly on a block device to test it for correctness?  What has 
been done in the past to make sure the previous RAID modules worked, beside 
sticking the code out there and waiting for bug reports?

