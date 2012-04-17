From: Ken Gunderson <kgunders@teamcool.net>
Subject: non fs-data and gpt partitioned md
Date: Tue, 17 Apr 2012 14:40:10 -0600
Message-ID: <1334695210.6026.31.camel@hermes>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello:

I'm wanting to set up a new md root lvm based configuration and after
reading various docs am confused about how I should be going about this.
My intent is to have mirrored /boot and swap partitions and a raid10 /
partition with LVM.

Issue #1: gpt is recommended over mbr based partitioning for new
installs, even on BIOS based systems (presuming these BIOS will boot
gpt, wh/mine do). Auto-assemble is not recommended for new installations
(my understanding is that it is not necessary with initramfs) so I
presume I should be specifying partition type DA.  However, while gdisk
et.al. allow for selecting type FD, they do not offer DA as an option.  

Issue #2: Is there any reason to prefer 1.0 vs. 1.2 metadata? I can use
either grub2 or Syslinux boot loaders.  My understanding is that
Syslinux supports the former while Grub2 supports 1.2. All other things
being equal, I'd prefer to use Syslinux.  Unless there is some technical
reason to favor 1.2 metadata and/or Grub2.

So what would be best practices recommended way to proceed here?

Thanks-- Ken

-- 
Ken Gunderson <kgunders@teamcool.net>

