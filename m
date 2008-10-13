From: Bill Davidsen <davidsen@tmr.com>
Subject: Distributed spares
Date: Mon, 13 Oct 2008 17:50:25 -0400
Message-ID: <48F3C2A1.3080607@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Over a year ago I mentioned RAID-5e, a RAID-5 with the spare(s) 
distributed over multiple drives. This has come up again, so I thought 
I'd just mention why, and what advantages it offers.

By spreading the spare over multiple drives the head motion of normal 
access is spread over one (or several) more drives. This reduces seeks, 
improves performance, etc. The benefit reduces as the number of drives 
in the array gets larger, obviously with four drives using only three 
for normal operation is slower than four, etc. And by using all the 
drives all the time, the chance of a spare being undetected after going 
bad is reduced.

This becomes important as array drive counts shrink. Lower cost for 
drives ($100/TB!), and attempts to drop power use by using fewer drives, 
result in an overall drop in drive count, important in serious applications.

All that said, I would really like to bring this up one more time, even 
if the answer is "no interest."

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


