From: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Subject: How do i limit the bandwidth-usage while resyncing on RAID 1?
Date: Wed, 10 Oct 2007 17:11:04 +0200
Message-ID: <735D322AED9CD711BE53000476917CD002972B92@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello List,

while resyncing, the process takes the whole bandwidth from disk to disk.

This leads in a VERY unhappy situation, because the system on this raid is
unpractical slow now, because it has to wait for disk-io.

How can i tune this? I want somthing like "nice -n 19 dm-mirror" ;)

Kind regards, Florian
**********************************************************************************************
IMPORTANT: The contents of this email and any attachments are confidential. They are intended for the 
named recipient(s) only.
If you have received this email in error, please notify the system manager or the sender immediately and do 
not disclose the contents to anyone or make copies thereof.
*** eSafe scanned this email for viruses, vandals, and malicious content. ***
**********************************************************************************************

