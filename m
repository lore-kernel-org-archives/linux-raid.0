From: Bill Davidsen <davidsen@tmr.com>
Subject: RAID5E
Date: Wed, 31 May 2006 09:47:30 -0400
Message-ID: <447D9E72.3000704@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Where I was working most recently some systems were using RAID5E (RAID5 
with both the parity and hot spare distributed). This seems to be highly 
desirable for small arrays, where spreading head motion over one more 
drive will improve performance, and in all cases where a rebuild to the 
hot spare will avoid a bottleneck on a single drive.

Is there any plan to add this capability?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

