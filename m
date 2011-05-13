From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 12:49:29 -0400
Message-ID: <4DCD6119.3080705@turmel.org>
References: <4DCD4A83.8060202@pulseforce.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCD4A83.8060202@pulseforce.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher White <linux@pulseforce.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Christopher,

On 05/13/2011 11:13 AM, Christopher White wrote:
> Greetings.
> 
> I have spent TEN hours trying everything other than regressing to a REALLY old version. I started out on 3.1.4 and have also tried manually upgrading to 3.2.1, but the bug still exists.
> 
> Somewhere along the way, the "auto" partitionable flag has broken.
> 
> sudo mdadm --create --level=raid5 --auto=part2 /dev/md1 --metadata=1.2 --raid-devices=4 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2
> 
> This only creates /dev/md1. It is of course possible to create one big partition as /dev/md1p1 with any partitioning program, but FORGET about trying to create /dev/md1p2.

What exactly did fdisk or parted report when you tried to partition /dev/md1 ?

> The problem is that the RAID array is NOT created in partitionable mode, and only supports one large partition, despite ALL attempts at EVERY format of the --auto option, you name it, -a part2, --auto=mdp2, --auto=part2, --auto=p2, --auto=mdp, --auto=part, --auto=p, --auto=p4, you name it and I've tried it!
> 
> My guess is the functionality of creating partitionable arrays literally DID break somewhere prior to/at version 3.1.4 which is the earliest version I tried.

The mdadm <==> kernel interface for this might be broken, but as a side-effect of the change to make all md devices support conventional partition tables.  I don't recall exactly when this changed, but it was several kernels ago.

What kernel are you running?

> I'm giving up and creating physical n-1 sized partitions on the source disks and creating two RAID 5 arrays from those partitions instead, but decided I really MUST report this bug so that other people don't bang their head against the wall for ten hours of their life as well. ;-)

Consider trying "mdadm --create" without the "--auto" option at all, then fdisk on the resulting array.

Phil
