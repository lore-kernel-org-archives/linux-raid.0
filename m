From: Tim White <weirdit@gmail.com>
Subject: Raid10 Reshape/Grow
Date: Fri, 12 Apr 2013 11:55:18 +1000
Message-ID: <51676986.40303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently watched Neil's LCA2013 video, and so was wondering if RAID10 
reshape/grow is ever going to be implemented?

The way I see it, if we are adding pairs of disks to the RAID10 array 
(not necessarily the same size as current disks, but the pair being the 
same size), then we should be able to reshape to grow the RAID10.

 From what I can see, the current options are to not use RAID10 if we 
want to be able to expand later, or to use LVM over RAID1.

I'm obviously not expecting it to be in any distro's yet, but am just 
wondering what the state of these features are. I have a mdadm git 
checkout, and am willing to do testing to assist with this.

Thanks

Tim
