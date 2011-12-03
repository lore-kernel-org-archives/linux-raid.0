From: Vincent Pelletier <plr.vincent@gmail.com>
Subject: Spin down
Date: Sat, 3 Dec 2011 12:23:37 +0100
Message-ID: <CAF78GY0YdJ0c0WWpyDnnzitAec_7VZZnEsP_n_UHuec5JmVAng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

Short system description:
up-to-date Debian sid, used on a NAS-ish machine (iscsi with
open-iscsi's kernel module, nfs, dnsmask for netboot), ext4 FS over
RAID1 on both system partition and exported data partitions.

I would like disks containing raid arrays to spin down, but there are
periodic disk writes which prevent this.
They do not show up in iotop (although it does show a write activity
in the topmost line).
Enabling /proc/sys/vm/block_dump generates the following output:

<7>[  918.078079] md0_raid1(304): WRITE block 8 on sda1 (2 sectors)
<7>[  918.078169] md0_raid1(304): WRITE block 8 on sdc1 (2 sectors)
<7>[  918.092124] md1_raid1(311): WRITE block 8 on sda5 (2 sectors)
<7>[  918.092184] md1_raid1(311): WRITE block 8 on sdc5 (2 sectors)
<7>[  918.292627] md0_raid1(304): WRITE block 8 on sda1 (2 sectors)
<7>[  918.292714] md0_raid1(304): WRITE block 8 on sdc1 (2 sectors)
<7>[  918.308500] md1_raid1(311): WRITE block 8 on sda5 (2 sectors)
<7>[  918.308588] md1_raid1(311): WRITE block 8 on sdc5 (2 sectors)
<7>[  923.113309] md0_raid1(304): WRITE block 8 on sda1 (2 sectors)
<7>[  923.113397] md0_raid1(304): WRITE block 8 on sdc1 (2 sectors)
<7>[  923.129330] md1_raid1(311): WRITE block 8 on sda5 (2 sectors)
<7>[  923.129388] md1_raid1(311): WRITE block 8 on sdc5 (2 sectors)
<7>[  923.332489] md0_raid1(304): WRITE block 8 on sda1 (2 sectors)
<7>[  923.332545] md0_raid1(304): WRITE block 8 on sdc1 (2 sectors)
<7>[  923.348507] md1_raid1(311): WRITE block 8 on sda5 (2 sectors)
<7>[  923.348595] md1_raid1(311): WRITE block 8 on sdc5 (2 sectors)

Note the 5-seconds pause between each half of this output.
Block 8 seems to be the md superblock (dixit hexdump + description of
md superblock), and "mdadm --examine" shows the "Update time" is being
increased.
Those arrays are in clean state, no synchronisation is happening and
no checking that I know of (I would expect a lot of disk activity).

Is there any reason why those writes are happening ?
I can imagine a mechanism like filesystem superblock periodic
flushing, but AFAIK it only happens when changes are happening (even
if they are not flushed themselves), and I would expect the same to
happen here.
Is there any knob to control those writes ?

Regards,
-- 
Vincent Pelletier
