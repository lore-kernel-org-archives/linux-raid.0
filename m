From: Oliver Martin <oliver@volatilevoid.net>
Subject: Creating a 3-disk RAID6 array
Date: Thu, 17 May 2012 03:24:26 +0200
Message-ID: <4FB4534A.5070608@volatilevoid.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

is there any specific reason why md refuses to create a RAID6 array with 
3 disks? My (probably naive) understanding suggests it should be the 
same as a 3-disk RAID1, similar to a 2-disk RAID5.

The reason I'm asking is that I currently have space on three disks for 
a new array, and would like to expand it when I add a fourth. I tried 
this scenario with a few loopback devices, but the only way to go from a 
3-disk RAID1 to a 4-disk RAID6 seems to be via an intermediate 3-disk 
RAID5, requiring two reshapes. I'd like to avoid one of them, if at all 
possible.

Regards,
Oliver
