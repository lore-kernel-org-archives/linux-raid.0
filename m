From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: No response?
Date: Thu, 20 Jan 2005 19:30:52 +0100
Message-ID: <csotcs$oma$1@sea.gmane.org>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Dougall <davidd@et.byu.edu> wrote:
> If I am running software raid1 and a disk device starts throwing I/O
> errors, Is the filesystem supposed to see any indication of this?  I

Usually this should not happen. Presumed a) this device is not the
only active device in this RAID1 and b) this device is the only
failing one.

> I have servers with xfs as the filesystem and xfs will start to throw I/O
> errors when a disk starts acting up even with software raid in between.

It could be helpful to show the messages appearing (dmesg), the
RAID setup (cat /proc/mdstat) and the mount (cat /etc/fstab /etc/mtab
or /proc/mounts).


regards,
   Mario
-- 
<jv> Oh well, config
<jv> one actually wonders what force in the universe is holding it
<jv> and makes it working
<Beeth> chances and accidents :)

