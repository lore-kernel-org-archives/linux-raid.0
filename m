From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: [urgent] supermicro ejecting disks
Date: Thu, 9 Nov 2006 15:18:11 +0100
Message-ID: <20061109141811.GA5805@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

We recently changed our main server to a Supermicro with 6 scsi disks in 
soft raid6 with kernel 2.6.18. 

After running OK for a few days, 3 disks were suddenly ejected from the 
raid6. We are now trying to reassemble the partition in another box but 
keep getting a "superblock corrupted" error on the fs. We're in a pretty 
bad state right now, as this is a production machine. Of course we have 
bakcups but restoring them will take some time.

Does anyone have any idea of what has happended and how to fix it?

Thanks,
