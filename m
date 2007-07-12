From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: adding drives / growing RAID-10?
Date: Thu, 12 Jul 2007 12:42:00 +0200
Message-ID: <46960578.60000@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was wondering if "adding drives / growing RAID-10", similar to the 
same feature available for RAID-5, was ever contemplated by any of 
linux-raid developers?

What would be needed, at least in theory, just to add one disk to 
RAID-10 array?

I assume having to temporarily add "N * 2 + 1" drives (where N is the 
current number of drives in the array) just to add one drive to RAID-10 
is the worst-case scenario.


-- 
Tomasz Chmielewski
