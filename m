From: Mike Baynton <mikeb414@earthlink.net>
Subject: raidreconf: immediate "reconfiguration failed"
Date: Thu, 12 Aug 2004 00:49:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411B04EF.9060203@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have encountered a problem using raidreconf with fedora core 2. Using 
the raidreconf that shipped with fc2 (0.1.2) as well as the "latest" 
raidreconf from http://unthought.net/raidreconf/ (0.1.1), I am told 
instantly after giving any raidreconf command (other than maybe -V :-)) 
that the reconfiguration failed, and raidreconf exits. The md device 
that I told it to work on seems unharmed.

I poked around in raidreconf.c (0.1.1) enough to find out that it fails 
on line 618, its the if statement that follows:

if (raidseek (fd, old_md_cfg->sb_block_offset[0]) == -1)
	return 1;

I don't think its a problem with the md device being somehow f'ed 
because I've tried it on two of them, my actual array which was born on 
a 2.4 system and a tiny one that I built new on my 2.6.5 fedora system 
just to see what raidreconf would do with it.

Where do I go? What do I do? What does it all mean?

Looking at raidreconf.c I don't think this is even relevant, but I'm 
trying to expand a raid5 onto additional disks. Its worked for me before 
on other systems.

To be complete, some more details on my system: fedora core 2's source 
tree (2.6.5) with some extra disk controller modules and all the md 
related components built-in. Its currently using 4x160gb IDE drives 
which I am trying to expand to 6. In both my tiny expermental array and 
my actual array the ITE IT8212 disk controller, which requires a 
non-linux source tree module, was involved.

-Mike Baynton

