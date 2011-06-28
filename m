From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: Re: Raid auto-assembly upon boot - device order
Date: Tue, 28 Jun 2011 21:18:33 +0200
Message-ID: <4E0A2909.5030501@ivitera.com>
References: <4E089067.8010904@ivitera.com> <4E08980B.5080002@turmel.org> <4E09AA68.2050302@ivitera.com> <4E09B50B.20306@turmel.org> <4E09C295.8040102@ivitera.com> <4E09F5A5.3020903@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E09F5A5.3020903@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 28.6.2011 17:39, Phil Turmel napsal(a):
>> 
>> It took me several years to find a reasonably fast way to
>> offline-backup that partition with tens of millions of backuppc
>> hardlinks :)
> 
> I've heard of hardlink horrors with backuppc.  I don't use it myself.
> I prefer to use LVM on top of MD, then take compressed backups of LVM
> snapshots.

One of my goals was to be able to stick the offline backup drives to any
PC, boot from a debian netinstall CD, chroot to the mirrored root, mount
the large data partitions, and be ready to start recovery in a
matter of minutes. Therefore I prefer the whole filesystems mirror.
> 
> Mirror w/ bitmap would make 1:1 backups faster.  I understand why you
> are doing this, but I'd be worried about filesystem integrity at the
> point in time you disconnect the backup drive.  Have you performed
> any tests to be sure you can recover usable data from the offline
> copy?  If I recall correctly, an LVM snapshot operation incorporates
> a filesystem metadata sync.

Yes, I am using a rather complicated automatic procedure. When the
resyncing finishes, the script waits until backuppc finishes the
currently running jobs (while starting new ones is disabled), shuts
backuppc down, kills all other processes accessing the partition,
umounts the filesystem, removes the offline drives from the md5/md6
arrays, mounts the backup raid again, restarts the backup processes, and
then checks the offline copy: mounts the offline drives as partition and
tries to read a random file from it. Only after that are the offline
drives unmounted, their array disassembled and the drives put to sleep,
until the operator removes them from their external bays and takes away
from the company premises.

The offline drives have saved my butt several times :)

Regards,

Pavel.
