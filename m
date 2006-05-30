From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: adding multipath device without reboot?
Date: Tue, 30 May 2006 17:42:07 +0200
Message-ID: <fd8d0180605300842j62602621jd9550c5411459826@mail.gmail.com>
References: <447C4FC5.3030502@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <447C4FC5.3030502@cc.kuleuven.be>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guess hdparm -z /dev/md12 would do the trick, if you're lucky enough...

2006/5/30, Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>:
> I'm trying to add a new SAN LUN to a system, create a multipath mdadm
> device on it, partition it, and create a new filesystem on it, all
> without taking the system down.
>
> All goes well, up to partitioning the md device:
>
>    # fdisk /dev/md12
>    Device contains neither a valid DOS partition table, nor Sun, SGI
>    or OSF disklabel
>    Building a new DOS disklabel. Changes will remain in memory only,
>    until you decide to write them. After that, of course, the
>    previous content won't be recoverable.
>
>    The number of cylinders for this disk is set to 8569312.
>    There is nothing wrong with that, but this is larger than 1024,
>    and could in certain setups cause problems with:
>    1) software that runs at boot time (e.g., old versions of LILO)
>    2) booting and partitioning software from other OSs
>       (e.g., DOS FDISK, OS/2 FDISK)
>    Warning: invalid flag 0x0000 of partition table 4 will be
>    corrected by w(rite)
>
>    Command (m for help): p
>
>    Disk /dev/md12: 35.0 GB, 35099901952 bytes
>    2 heads, 4 sectors/track, 8569312 cylinders
>    Units = cylinders of 8 * 512 = 4096 bytes
>
>         Device Boot      Start         End      Blocks   Id  System
>
>    Command (m for help): n
>    Command action
>       e   extended
>       p   primary partition (1-4)
>    p
>    Partition number (1-4): 1
>    First cylinder (1-8569312, default 1):
>    Using default value 1
>    Last cylinder or +size or +sizeM or +sizeK (1-8569312, default
>    8569312):
>    Using default value 8569312
>
>    Command (m for help): w
>    The partition table has been altered!
>
>    Calling ioctl() to re-read partition table.
>
>    WARNING: Re-reading the partition table failed with error 22:
>    Invalid argument.
>    The kernel still uses the old table.
>    The new table will be used at the next reboot.
>    Syncing disks.
>
> I know a reboot will read the new table, but is there any way to clear
> the in-memory table and replace it with the newly written one?
> The entire point of this exercise is to be able to add diskspace without
> having to reboot.
>
> Kind regards,
>
> Herta
>
> Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
