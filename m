From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Disable raid auto assemble at boot
Date: Fri, 31 May 2013 14:26:40 -0300
Message-ID: <CAGmni9prcynqMeprE3Nmjzkn2QgTkeHPxq=qSGzQBrt_bAziCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Could anyone tell me how can i avoid the auto assemble of my raid
device during boot?
I am running:
debian 7.0 with kernel 3.9.3-amd64

#cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-3.9.3-amd64 root=/dev/sda2 ro quiet panic=3
raid=noautodetect

#cat /etc/mdadm/mdadm.conf
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root
ARRAY /dev/md/md1 metadata=1.2 name=zotac:md1
UUID=082dc730:aedd3e21:1820edc4:6f20acd0
ARRAY /dev/md/md0 metadata=1.2 name=zotac:md0
UUID=d260f467:92241c75:0c742da1:8af824f6


both /etc/init.d/mdadm and /etc/init.d/mdadm-raid are disabled.

all raid components are set to FD type.

And somehow the array is always assembled at boot.
I started notice this 'forced auto assemble' after replace the 0.9
metadata to 1.2 metadata.

Thanks !





[]'s
Salatiel
