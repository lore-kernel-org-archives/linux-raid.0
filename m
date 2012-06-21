From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Mounting MD raid1 array blocked by "Stale NFS file handle"
Date: Thu, 21 Jun 2012 03:36:26 -0500
Message-ID: <4FE2DD0A.8000501@hardwarefreak.com>
References: <CAO7BsSmJiQb6PCmf+j6RnxVSFpDkK9w2wmimx86PqQxd+kY6Nw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO7BsSmJiQb6PCmf+j6RnxVSFpDkK9w2wmimx86PqQxd+kY6Nw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Skip Coombe <skipcoombe@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry bout the off-list only reply.  vger lists don't conform to standards.

On 6/20/2012 7:12 AM, Skip Coombe wrote:

> $ sudo mount -t ext2 -U dadb7d1c-daa2-4e56-8ef7-2816db397289 /mnt/back
> mount: Stale NFS file handle
> 
> $ sudo mount -t ext2 /dev/md1 /mnt/back
> mount: Stale NFS file handle
> 
> I do not have NFS intalled, only ssh and smb.
> 
> Any help will be appreciated. Please point out any info I have missed.

What you have missed is that the mount command doesn't mount devices, it
mounts filesystems, which reside on devices.  That means mount has
nothing to do with, and no knowledge of, the md driver or devices.  The
error is not indicative of the problem as you don't have NFS installed.
 The error msg is a bug.  File a report against mount and/or ext2 with
your distribution--looks like ubuntu.

Something is wrong with the filesystem nonetheless.  So the first thing
to do is run an fsck.  If that doesn't fix it, ask for help in the
various ubuntu fora.

-- 
Stan
