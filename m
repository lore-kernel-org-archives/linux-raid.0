From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md0
Date: Thu, 28 Aug 2008 12:07:57 +0200
Message-ID: <48B678FD.1050801@rabbit.us>
References: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thomas62186218@aol.com wrote:
> Hi all,
> 
> I am struggling with an issue on an Ubuntu 8.0.4 64-bit system. The
> system has 12 SATA drives. I create a RAID 5 array using mdadm as follows:
> 
> mdadm -Cv /dev/md0 -n12 -l5 -c128 /dev/sd[b-m] -R -f
> 

As a side note, what you are about to do is sheer madness. At least use
RAID6. Search for raid5 in the list archives for a number of discussions
why using RAID5 with a large number of disks is rather shortsighted.

HTH

Peter
