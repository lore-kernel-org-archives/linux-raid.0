From: Luca Berra <bluca@comedia.it>
Subject: Re: Raid-10 mount at startup always has problem
Date: Fri, 26 Oct 2007 11:15:13 +0200
Message-ID: <20071026091513.GB32550@percy.comedia.it>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com> <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193294406.10336.76.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 25, 2007 at 02:40:06AM -0400, Doug Ledford wrote:
>partition table (something that the Fedora/RHEL installers do to all
>disks without partition tables...well, the installer tells you there's
>no partition table and asks if you want to initialize it, but if someone
>is in a hurry and hits yes when they meant no, bye bye data).
Cool feature!!!!

>
>The partition table is the single, (mostly) universally recognized
>arbiter of what possible data might be on the disk.  Having a partition
>table may not make mdadm recognize the md superblock any better, but it
>keeps all that other stuff from even trying to access data that it
>doesn't have a need to access and prevents random luck from turning your
>day bad.
on a pc maybe, but that is 20 years old design.
partition table design is limited because it is still based on C/H/S,
which do not exist anymore.
Put a partition table on a big storage, say a DMX, and enjoy a 20%
performance decrease.

>Oh, and let's not go into what can happen if you're talking about a dual
>boot machine and what Windows might do to the disk if it doesn't think
>the disk space is already spoken for by a linux partition.
Why the hell should the existance of windows limit the possibility of
linux working properly.
If i have a pc that dualboots windows i will take care of using the
common denominator of a partition table, if it is my big server i will
probably not. since it won't boot anything else than Linux.

>And, in particular with mdadm, I once created a full disk md raid array
>on a couple disks, then couldn't get things arranged like I wanted, so I
>just partitioned the disks and then created new arrays in the partitions
>(without first manually zeroing the superblock for the whole disk
>array).  Since I used a version 1.0 superblock on the whole disk array,
>and then used version 1.1 superblocks in the partitions, the net result
>was that when I ran mdadm -Eb, mdadm would find both the 1.1 and 1.0
>superblocks in the last partition on the disk.  Confused both myself and
>mdadm for a while.
yes, this is fun
On the opposite, i once inserted an mmc memory card, which had been
initialized on my mobile phone, into the mmc slot of my laptop, and was
faced with a load of error about mmcblk0 having an invalid partition
table. Obviously it had none, it was a plain fat filesystem.
Is the solution partitioning it? I don't think the phone would
agree.

>Anyway, I happen to *like* the idea of using full disk devices, but the
>reality is that the md subsystem doesn't have exclusive ownership of the
>disks at all times, and without that it really needs to stake a claim on
>the space instead of leaving things to chance IMO.
Start removing the partition detection code from the blasted kernel and
move it to userspace, which is already in place, but it is not the
default.



-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
