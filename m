From: Kanoalani Withington <kanoa@cfht.hawaii.edu>
Subject: Re: Couldn't umount on /mnt/md0-device busy???
Date: Wed, 17 Jul 2002 08:52:06 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D35BCD6.7030300@cfht.hawaii.edu>
References: <Pine.LNX.4.33.0207161515560.29547-100000@pandora.is.bizsystems.com> <15668.41627.988382.451061@notabene.cse.unsw.edu.au> <003c01c22db8$57b86590$5701a8c0@bomoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: bo <bo@sosnetwork.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There may be an entry for /mnt/md0 in /etc/exports. If there is, usually 
the startup scripts will start an NFS server at boot time and the 
filesystem will be busy as long as that daemon is running. If you mount 
the volume after the scripts run a server won't be started and the 
volume can be manually unmounted without any errors.

-Kanoa

bo wrote:

>Hello!
>
>I have found a VERY strange issue on using the name "md0" as a mount point.
>If I use "/mnt/md0" as a mount point for the md device or normal HD device,
>I could not umount it after booting the system having "device is busy"
>error.
>
>However, it is OK if I manually make a RAID then mount it to "/mnt/md0".
>I checked if it has any processes running on it with "fuser" but nothing.
>
>Does "/mnt/md0" have a special meaning(usage) for system?
>
>Please provide me a clue.
>
>Thanks,
>
>//Bo
>
>The followins are my experiment on this issue;
>
>root@P3000-PP1:/home/bmoon# cat /proc/mounts
>/dev/root / ext2 rw 0 0
>none /proc proc rw 0 0
>/dev/md0 /mnt/md0 ext2 rw 0 0
>/dev/md3 /mnt/md3 ext2 rw 0 0
>
>root@P3000-PP1:/home/bmoon# umount /mnt/md0
>umount: /mnt/md0: device is busy
>---------------
>root@P3000-PP1:/etc# fuser -v /mnt/md0
>
>                     USER        PID ACCESS COMMAND
>/mnt/md0            root     kernel mount  /mnt/md0
>
>----------------after chnage the name of mount point  from /mnt/md0 to
>/mnt/user---------------
>root@P3000-PP1:/home/bmoon# cat /proc/mounts
>/dev/root / ext2 rw 0 0
>none /proc proc rw 0 0
>/dev/md0 /mnt/user ext2 rw 0 0
>/dev/md3 /mnt/md3 ext2 rw 0 0
>
>root@P3000-PP1:/home/bmoon# umount /mnt/user
>root@P3000-PP1:/home/bmoon#
>------------------------
>root@P3000-PP1:/etc# vi fstab
>/dev/hda2        /               ext2    defaults        1 1
>none             /proc           proc    defaults        0 0
>/dev/hda3        swap            swap    defaults        0 0
>/dev/md0         /mnt/user       ext2    defaults        0 0
>/dev/md3         /mnt/md3        ext2    defaults        0 0
>
>Another experiment
>----------------------
>root@P3000-PP1:/home/bmoon# cat /proc/mounts
>/dev/root / ext2 rw 0 0
>none /proc proc rw 0 0
>/dev/hdb2  /mnt/md0 ext2 rw 0 0
>/dev/md3 /mnt/md3 ext2 rw 0 0
>
>root@P3000-PP1:/home/bmoon# umount /mnt/md0
>umount:  /mnt/md0:  device is busy
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


