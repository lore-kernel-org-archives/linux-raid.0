From: Bill Davidsen <davidsen@tmr.com>
Subject: Catching a RAID error in a process
Date: Wed, 18 Jul 2012 16:31:55 -0400
Message-ID: <50071D3B.3090309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Can someone point me to the docs to have a process run or notified when a RAID 
event triggers? I've been playing with some recovery ideas, but polling states 
and status is not the proper way to do this, and I want to test with a user 
program before I start putting patches in the kernel.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

