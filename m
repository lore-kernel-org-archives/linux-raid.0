From: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Subject: Mustn't be RAID 1 and 0 read-performance be similar?
Date: Thu, 9 Aug 2007 09:15:53 +0200
Message-ID: <735D322AED9CD711BE53000476917CD00281A96B@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello List,

If the speed on RAID 0 is based on reading out in parallel, then it must be
the same on RAID 1, mustn't it?

On RAID 1, it is possible, to read two blocks in parallel to speed up, too.

I tried to measure this some weeks ago, but i couldn't get over the
read-performance of a single disk on my raid 1, so that means, that the
software-raid does not use this easy possibility to speed up?

Kind regards, Florian
**********************************************************************************************
IMPORTANT: The contents of this email and any attachments are confidential. They are intended for the 
named recipient(s) only.
If you have received this email in error, please notify the system manager or the sender immediately and do 
not disclose the contents to anyone or make copies thereof.
*** eSafe scanned this email for viruses, vandals, and malicious content. ***
**********************************************************************************************

