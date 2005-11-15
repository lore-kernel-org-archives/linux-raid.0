From: Frido Ferdinand <frido@zolder.org>
Subject: High system load on 2.6.15-r1 & software raid
Date: Tue, 15 Nov 2005 19:38:48 +0100
Message-ID: <20051115183848.GE30507@borneo.zolder.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@VGER.KERNEL.ORG
List-Id: linux-raid.ids

Hi,

Yesterday i installed the new 2.6.15-rc1 kernel to test ata passthrough to
get smartctl working on my sata disks. After boot I noticed a rather
high load of ~5. I checked with top, ps, but no processes where running
taking up CPU, and the system was 100% idle:

Cpu0  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu1  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si

After thinking about it, i realised i had 5 different software raid 1
partitions running, md0 to md4. After disabling each of them with 
with about 10 minutes in between, i saw the load drop by exactly
1 each time. This problem didn't happen on 2.6.14.2. Has anyone seen
this problem before, maybe on another kernel ? As for smartctl, it
works,but I didn't enable smartd nor mdadm when testing.

System info/config: http://www.zolder.org/raidload

Regards,

	-- Frido

