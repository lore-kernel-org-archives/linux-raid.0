From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Raid-10 mount at startup always has problem
Date: Mon, 27 Aug 2007 11:14:21 -0700
Message-ID: <46D3147D.2040201@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have a four-disk Raid-10 array that I created and mount with mdadm.  
It seems like every re-boot, either the array is not recognized 
altogether, or one of the disks is not added.  Manually adding using 
mdadm works.

Ubuntu, custom compiled kernel, 2.6.22
mdadm 2.6.2
Sata hard drives, nvidia CK804 controller - NOT using nvidia raid.

-- 
Daniel
