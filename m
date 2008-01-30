From: Richard Scobie <richard@sauce.co.nz>
Subject: RAID 1 and grub
Date: Thu, 31 Jan 2008 11:06:20 +1300
Message-ID: <47A0F4DC.9030005@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a machine with Fedora core 8 installed onto RAID1 on IDE drives - 
hda and hdc.

hda has failed and after spending some time with a rescue disk mounting 
hdc's /boot partition (hdc1) and changing the grub.conf device 
parameters, I have no success in booting off it.

I then set them back to the original (hd0,0) and moved hdc into hda's 
position.

Booting from there brings up the message: GRUB hard disk error

Can any grub guru offer any assisentence as to what may be missing here?

Regards,

Richard
