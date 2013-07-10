From: Priya Kamala <priya.kamala@perpetual-data.com>
Subject: Query regarding disk failure
Date: Wed, 10 Jul 2013 13:09:20 +0100
Message-ID: <51DD4EF0.6020509@perpetual-data.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

If a single disk develops bad sector(s) that affects only a single 
stripe within a given RAID-5 configuration and these bad sectors are 
discovered when running a "check/resync" (echo check > 
/sys/block/mdX/md/sync_action), does this result in the entire disk 
being removed from the RAID? In other words, is access to the other good 
stripes on the drive disabled as well? If so, why is it done this way? 
In case the kernel version makes a difference to the behaviour, I'm 
working with 2.6.21.1.

Thanks,
Priya

