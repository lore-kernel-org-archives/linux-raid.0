From: Richard Scobie <richard@sauce.co.nz>
Subject: SCSI TCQ
Date: Sat, 31 Dec 2005 14:16:39 +1300
Message-ID: <43B5DBF7.3050104@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Slightly of topic, but I have just added a RAID 1 array using SCSI 
disks, containing the maildirs for a small (25 users) mail and IMAP server.

I notice the default kernel setting for TCQ on the disks, is a depth of 
4 and wondered if there was much to be gained from making this larger, 
or do the disks just end up fighting the elevator code?

Regards,

Richard
