From: Sevatio <sevatio@atella.com>
Subject: Bootable Raid Problem
Date: Fri, 14 May 2004 08:11:27 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40A4E19F.4080405@atella.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having a problem with md0.  It's supposed to bind hda5 and hdc5 but 
it's only able to bring up hdc5 for md0.  md0 is being mounted as /boot. 
  Being that it's /boot, I can't seem to umount it to do anything to it. 
  Perhaps I'm not approaching this correctly.  How do I fix this so that 
hda5 is also running along side hdc5 for md0?

Thanks,
Sevatio
