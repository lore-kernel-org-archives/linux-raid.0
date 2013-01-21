From: Eddy Ilg|univation <eddy.ilg@univation.de>
Subject: Recovering RAID1 superblock
Date: Mon, 21 Jan 2013 21:41:08 +0100
Message-ID: <50FDA7E4.9010705@univation.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear linux-raid users,

I have a disk of a 2-disk RAID1 array with damaged superblock. Please 
forgive me if this question as already been asked, but as I am afraid of 
executing a dangerous command, I need to ask:

To recover the superblock, I would run
mdadm --create /dev/md2 --level=1 --raid-devices=2 /dev/sdb2 missing

Is is correct, that this will NOT erase the data on /dev/sdb2?

Best regards,


Eddy Ilg
