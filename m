From: Biju A <biju_amaravat@yahoo.com>
Subject: SuSE Linux cluster using MC/ServiceGuard --- shared storage
Date: Mon, 20 Sep 2004 06:28:46 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040920132846.29970.qmail@web61108.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

In a Linux cluster setup, I have some issues.

I am trying to use 'md' driver in Linux for multipath
to shared storage with Enterprise Virtual Array 3000
(EVA 3000)

The O/S is SuSE Linux ES 8.0 which runs on both the
cluster nodes (HP ProLiant ML330 machines). I use
Qlogic HBAs (of different versions) both supporting
failover. 

Do I still need to use the Driver Patch for EVA
Controller Failover? 

I can add the Virtual Disks from the EVA console and
this does not need additional Secure Path installation
to get detected.

EVA offers different RAID functions such as 0,1 and 5
and I guess I use the software RAID on Linux
(implemented thru md drivers) to provide multipath
support. Is there any need for implementing a software
RAID on top of an EVA which already has hardware RAID
functionality (say for example, if I want mirroring
instead of multipath)

The MC/SG spec says that 'md' driver should not be
active at the same time on both the cluster nodes. So,
I am not using the 'fd' type of partition which starts
the arrays at boot time. I just use the default 83
type.

Is there any specific need to update to 2.6 kernel in
order to support LVM 2?

The kernel version of the O/S in the cluster nodes is
2.4.19 which contains lvm 1.0.5-51. It does not
support 'pvremove' and probably the tool 'mkraid' does
have some bugs. No idea if there are fixes for the
same. Is it better to use 'mdadm'? 

I have tried to do the same sequence of steps listed
in "Managing Service Guard for Linux" to create the
logical volume infrastructure. But the first disk
partition grouped using md does not become part of the
array --- after rebooting the nodes. After rebooting,
the second node should get the configuration from the
primary node replicated but this does not happen for
the first partition. Only the second partition seems
to be shown active.  

Any hints/suggestions would be appreciated.

Regards,
Biju A




		
__________________________________
Do you Yahoo!?
Take Yahoo! Mail with you! Get it on your mobile phone.
http://mobile.yahoo.com/maildemo 
