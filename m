From: lilha@legend.com.cn
Subject: about delete raid
Date: Thu, 23 May 2002 21:58:12 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <OF46EF560E.DDE1731B-ON48256BC2.00497654@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i have setup raid0 and linear in my computer.
now i want to remove it and release my disk.
i use raidstop to stop all of md,and remove the file of /etc/raidtab
then i use fdisk to delete all of raid disk partitions.
at last , i reboot machine.

then i want to setup raid again, but it can't work now.

Following is my configure and the error output.

Disk /dev/hda: 255 heads, 63 sectors, 2434 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1             1       383   3076416   83  Linux
/dev/hda3           767      2434  13398210    5  Extended
/dev/hda4           448       511    514080   8e  Linux LVM
/dev/hda5           767       783    136521   82  Linux swap
/dev/hda6           784       800    136521   83  Linux
/dev/hda7           801       864    514048+  fd  Linux raid autodetect
/dev/hda8           865       928    514048+  fd  Linux raid autodetect

Disk /dev/hdc: 255 heads, 63 sectors, 392 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdc1             1        64    514048+  83  Linux
/dev/hdc4           193       392   1606500    5  Extended
/dev/hdc5           193       256    514048+  fd  Linux raid autodetect
/dev/hdc6           257       358    819283+  fd  Linux raid autodetect


[root@snap /root]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
read_ahead not set
unused devices: <none>

[root@snap /root]# vi /etc/raidtab
raiddev /dev/md8
        raid-level              0
        nr-raid-disks           2
        persistent-superblock   1
        chunk-size              32
        device                  /dev/hda7
        raid-disk               0
        device                  /dev/hdc5
        raid-disk               1
raiddev /dev/md9
        raid-level              0
        nr-raid-disks           2
        persistent-superblock   1
        chunk-size              32
        device                  /dev/hda8
        raid-disk               0
        device                  /dev/hdc6
        raid-disk               1


[root@snap /root]# mkraid /dev/md8
handling MD device /dev/md8
analyzing super-block
/dev/hda7: device too small (0kB)
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.
[root@snap /root]# mkraid /dev/md9
handling MD device /dev/md9
analyzing super-block
/dev/hda8: device too small (0kB)
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.


Can you tell me where is wrong?
thanks a lot.


With our best regards, echo

