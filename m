From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: Cutting power without breaking RAID
Date: Wed, 28 Jun 2006 23:43:50 +0200
Message-ID: <20060628214350.GA23970@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I'm facing this problem:

when my Linux box detects a POWER FAIL event from the UPS, it 
starts a normal shutdown. Just before the normal kernel poweroff, 
it sends to the UPS a signal on the serial line which says 
"cut-off the power to the server and switch-off the UPS".

This is required to reboot the server as soon as the power is 
restored.

The problem is that the root partition is on top of a RAID-1 
filesystem which is still mounted when the program that kills the 
power is run, so the system goes down with a non clean RAID 
volume.

What can be the proper action to do before killing the power to 
ensure that RAID will remain clean? It seems that remounting 
the partition read-only is not sufficient.

-- 
Niccolo Rigacci
Firenze - Italy

Iraq, missione di pace: 38475 morti - www.iraqbodycount.net
