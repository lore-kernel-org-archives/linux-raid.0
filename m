From: =?ISO-8859-1?Q?Tero_M=E4ntyvaara?= <termant@gmail.com>
Subject: Removing physical disk from RAID & LVM
Date: Tue, 15 May 2012 08:24:47 +0300
Message-ID: <4FB1E89F.5080407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have filesystem build up with 5 x 320 GB disks with identical
partitions. Disks have 2 partitions and the first one is dedicated for
RAID-1 (/dev/md0) and second one is dedicated for RAID-5 (/dev/md1). The
disk /dev/md0 is mounted as /boot and the /dev/md1 is prepared for LVM.
PE size is 32 MiB and there is 38035 PEs.

I am going to remove one 320 GB disk and have already reduced the sizes
of existing LV:s. 1) What is the sufficient free PE number before I can
imagine shrinking of RAID-5 device? 2) How should I procede after having
enough free PE:s?


Tero

