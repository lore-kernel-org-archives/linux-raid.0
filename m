From: Nicolas Karolak <nicolas.karolak@ubicast.eu>
Subject: Recover RAID6 with 4 disks removed
Date: Thu, 6 Feb 2020 14:46:51 +0100
Message-ID: <CAO8Scz75h0mTqePyyeehnY+706R=eUgh7DOOKyCaWWJfADRUVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I have (had...) a RAID6 array with 8 disks and tried to remove 4 disks
from it, and obviously i messed up. Here is the commands i issued (i
do not have the output of them):

```
mdadm --manage /dev/md1 --fail /dev/sdh
mdadm --manage /dev/md1 --fail /dev/sdg
mdadm --detail /dev/md1
cat /proc/mdstat
mdadm --manage /dev/md1 --fail /dev/sdf
mdadm --manage /dev/md1 --fail /dev/sde
mdadm --detail /dev/md1
cat /proc/mdstat
mdadm --manage /dev/md1 --remove /dev/sdh
mdadm --manage /dev/md1 --remove /dev/sdg
mdadm --manage /dev/md1 --remove /dev/sde
mdadm --manage /dev/md1 --remove /dev/sdf
mdadm --detail /dev/md1
cat /proc/mdstat
mdadm --grow /dev/md1 --raid-devices=4
mdadm --grow /dev/md1 --array-size 7780316160  # from here it start
going wrong on the system
```

I began to have "inpout/output" error, `ls` or `cat` or almost every
command was not working (something like "/usr/sbin/ls not found").
`mdadm` command was still working, so i did that:

```
mdadm --manage /dev/md1 --re-add /dev/sde
mdadm --manage /dev/md1 --re-add /dev/sdf
mdadm --manage /dev/md1 --re-add /dev/sdg
mdadm --manage /dev/md1 --re-add /dev/sdh
mdadm --grow /dev/md1 --raid-devices=8
```

The disks were re-added, but as "spares". After that i powered down
the server and made backup of the disks with `dd`.

Is there any hope to retrieve the data? If yes, then how?

Any help is really appreciated. Thanks in advance.

Regards,
Nicolas KAROLAK
