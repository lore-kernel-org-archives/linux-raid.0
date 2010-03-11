From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: How to fix Current_Pending_Sector?
Date: Thu, 11 Mar 2010 11:51:56 +0000
Message-ID: <C7BE89DC.10FE9%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Smartd emailed me to say I have "1 Currently unreadable (pending) sectors".
This actually happened for two disks now.

I ran a check and then a repair on my array and they both gave mismatch_cnt
of 8.

I ran a long self-test on both and they completed without error with no
errors logged. Yet the 'Current_Pending_Sector' is still 1 on both, and one
disk also has a 'UDMA_CRC_Error_Count' of 1.

I ran 'hdrecover' on both and they are both telling me "Couldn't recover
sector 2930277168". It's asking if I want to overwrite it with zeros to fix
it, but I would assume this will damage my array?

The disk sizes are 1500301910016 bytes and I use 1500250M partition sizes
for the array components. Does that sector fall outside my partition, and
hence would it be safe to overwrite it with zeros?

Also, why did I have a mismatch_cnt? I haven't run another check since I did
the repair, as I wanted to fix the pending sector.

BTW, I have a 15 drive RAID6.

Hope y'all can help.


Iain


