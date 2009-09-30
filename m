From: CoolCold <coolthecold@gmail.com>
Subject: Re: Cannnot umount to fix a corrupted Superblock on Buffalo
	Terastation (Linux) RAID 5
Date: Wed, 30 Sep 2009 10:18:44 +0400
Message-ID: <f19d625d0909292318v11ea924ex6f62295bda4c3eba@mail.gmail.com>
References: <25674181.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <25674181.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: sidmanm <sidmanm@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You do xfs_repair on md1 while unmounting md0 ?

On Wed, Sep 30, 2009 at 6:50 AM, sidmanm <sidmanm@yahoo.com> wrote:
>
> I suspect that I have a corrupted Superblock, but am stuck with what =
I can do
> next....I have a Buffalo Terastation Pro that runs on Linux. =A0I tri=
ed to run
> xfs_repair, but xfs_repair wants me to umount; umount is busy, and am
> hesitant to umount -F....any guidance is greatly appreciated.
>
> Here's the log from my telnet session:
>
> TS-TGLE79 login: myroot
> root@TS-TGLE79:~# xfs_repair /dev/md1
> xfs_repair: warning - cannot get sector size from block device /dev/m=
d1:
> Invalid argument
> Phase 1 - find and verify superblock...
> sb root inode value 18446744073709551615 (NULLFSINO) inconsistent wit=
h
> calculated value 256
> resetting superblock root inode pointer to 256
> sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsisten=
t with
> calculated value 257
> resetting superblock realtime bitmap ino pointer to 257
> sb realtime summary inode 18446744073709551615 (NULLFSINO) inconsiste=
nt with
> calculated value 258
> resetting superblock realtime summary ino pointer to 258
> Phase 2 - using internal log
> - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which ne=
eds to
> be replayed. Mount the filesystem to replay the log, and unmount it b=
efore
> re-running xfs_repair. If you are unable to mount the filesystem, the=
n use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a=
 mount
> of the filesystem before doing this.
>
> root@TS-TGLE79:~# mount
> /dev/md0 on / type auto (rw,noatime)
> proc on /proc type proc (rw)
> /dev/shm on /mnt/ram type tmpfs (rw,mode=3D1777,size=3D15m)
> /dev/ram1 on /tmp type ext2 (rw)
> devpts on /dev/pts type devpts (rw,gid=3D5,mode=3D620)
> /proc/bus/usb on /proc/bus/usb type usbdevfs (rw)
>
> root@TS-TGLE79:~# umount /dev/md0
> umount: /: device is busy
>
> Any guidance is greatly appreciated.
>
> Kind thanks,
>
> Michael
> --
> View this message in context: http://www.nabble.com/Cannnot-umount-to=
-fix-a-corrupted-Superblock-on-Buffalo-Terastation-%28Linux%29-RAID-5-t=
p25674181p25674181.html
> Sent from the linux-raid mailing list archive at Nabble.com.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
--
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
