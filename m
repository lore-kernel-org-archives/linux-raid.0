From: "Arnab Chowdry" <achowdry@socrates.Berkeley.EDU>
Subject: mkraid hangs system
Date: Wed, 12 May 2004 11:21:32 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405121819.i4CIJO60013175@socrates.Berkeley.EDU>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I know there's a similar thread created a few days ago, but I think my
situation might be different. I'm setting up a software RAID for my lab, and
I've run into no end of problems.

The RAID setup I'm going for is a 1+0 using four IDE disks. Each disk is
connected to a unique controller on two Promise PCI cards. Due to some
hardware problems with the motherboard, the system crashed during an initial
RAID reconstruction. Now that I've worked out the hardware problems with the
motherboard, the system hangs whenever I try to mkraid.

The system hangs within the first few seconds of mkraid, after it says that
it's analyzing the superblock. I've tried mkraid --really-force, tried
partitioning the drives using fdisk, and even tried to reset their MBR's.
Nothing seems to help the problem. 

I suspect it's some sort of corruption on the drives because of the original
crash that the RAID layer can't handle...so I'm wondering if there's some
way to wipe the drives completely and start from scratch again? Or if there
are any other suggestions?

I'm using Mandrake 9.2 with raidtools installed using urpmi.

Thanks,
Arnab Chowdry

