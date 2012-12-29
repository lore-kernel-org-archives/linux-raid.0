From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Linear raid extend component
Date: Sat, 29 Dec 2012 21:44:55 +1000
Message-ID: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have 3 RAID devices, 2 RAID1 which are then combined into a linear RAID. I've now replaced both drives of one of the RAID1 (from 2 x 1TB TO 2 x 3TB). 

I now want to grow the raid1 from 1TB to 3TB and then grow the linear to include the extra space. However, my concern is that if this is the first array in the linear I will corrupt the filesystem because there will be a big blank space in the middle. 

mdadm --misc --query /dev/md1
/dev/md1: 931.51GB raid1 2 devices, 0 spares. 
/dev/md1: device 1 in 2 device unknown linear array. 
mdadm --misc --query /dev/md2
/dev/md2: 1863.01GB raid1 2 devices, 0 spares. 
/dev/md2: device 0 in 2 device unknown linear array. 

So, I've increased the size of md1 which should be the end of md3.
So can I just do:
mdadm --grow /dev/md1 --size=max
Then when complete:
mdadm --grow /dev/md3 --size=max

Thanks for any assistance. 

Regards,
Adam

Sent from my mobile
Adam Goryachev
Website Managers
http://www.websitemanagers.com.au