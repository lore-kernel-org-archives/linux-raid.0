From: Gordon Henderson <gordon@drogon.net>
Subject: Moving Disks [Re: Multipath problem in a SAN enviromnent]
Date: Wed, 11 Jun 2003 17:42:05 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0306111736010.7103-100000@unicorn.drogon.net>
References: <3EE7585E.45D851CE@SteelEye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EE7585E.45D851CE@SteelEye.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 11 Jun 2003, Paul Clements wrote:

> Ionut Nistor wrote:
>
> > So scsi1, bus0, target0, lun2 is now 8,16 instead of 8,32
> >
> > However, the raid superblock still has 8,32 in it - this confuses
> > multipath
>
> One way to get around this problem is to use non-persistent superblocks
> for your arrays and just re-create them at bootup time by calling mkraid
> (or mdadm) after you've correctly identified (using WWID or similar)
> which devices belong to each particular raid set.

Hm. This is vaguely intersting to me, as soon I'm going to be moving 8
drives off one server (arranged as 2 md RAID5's, 4 drives each) into a
server which already has 4 drives fitted... (configured as various md
RAID1 and RAID5 devices)

Should I expect any problems? Can I degrade an existing running set into
non persistent superblock mode to facilitate with this move?

Gordon

