From: Martin T <m4rtntns@gmail.com>
Subject: Linux software-RAID and bootloader
Date: Fri, 7 Mar 2014 03:13:51 +0000
Message-ID: <CAJx5YvGGM7yziWQEefs=_Wte4jy13w1x1oG6MuUOggSgTfodMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

how is it ensured that superblock(for example version 1.2) can be
created at 4KiB from the beginning of the drive? I mean isn't there a
hazard that this area on the disk is already occupied for example by
the bootloader stage 1.5?

In addition, if software-RAID is created using partitions for example
like this: mdadm --create --verbose --level=1 --metadata=1.2
--chunk=64 --raid-devices=2 /dev/md0 /dev/sdb1 /dev/sdc1

..then how should one ensure that for example MBR/GPT is mirrored or
bootloader data is mirrored which both are located out of partition
boundaries?



regards,
Martin
