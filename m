From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Tue, 14 Feb 2012 05:10:27 -0600
Message-ID: <4F3A4123.1050508@hardwarefreak.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <CAGqmV7qoKW-7S26VwOS5szRRfvkr_cKh=ggXkXueMifhjJMhfA@mail.gmail.com> <4F3A23F1.6090908@westcontrol.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3A23F1.6090908@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: CoolCold <coolthecold@gmail.com>, keld@keldix.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/14/2012 3:05 AM, David Brown wrote:

> I believe that if you have XFS on LVM, then making a snapshot will first
> "freeze" the filesystem, take the snapshot, then "thaw" the filesystem.
>  This process will sync the system, flushing out outstanding writes, and
> delay new writes until the "thaw" - thus you get a bit better than a
> "power-off copy".  In particular, you don't get zeroed-out files no
> matter what you've done with your barrier settings.

xfs_freeze[1] was a feature/command carried over from IRIX to Linux
during the XFS port.  This functionality was later moved from the XFS
layer into the VFS layer.  Now FS freezing is fully automatic when an
LVM snapshot is taken.  Now in the VFS layer, this works with any
filesystem type, EXT2/3/4, Reiser, JFS, XFS.  I don't have the date or
kernel rev handy where this was integrated in mainline.  It's been at
least a couple/few years.  I'm not inclined to dig it up.


[1] xfs_freeze(8)

NAME
       xfs_freeze - suspend access to an XFS filesystem

SYNOPSIS
       xfs_freeze -f | -u mount-point

DESCRIPTION
       xfs_freeze suspends and resumes access to an XFS filesystem (see
xfs(5)).
[...]


-- 
Stan
