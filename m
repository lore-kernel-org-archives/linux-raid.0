From: Stephen Lee <splee@plexio.com>
Subject: mdadm help and howto for newbies?
Date: 19 Apr 2002 13:35:09 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1019248512.10455.1408.camel@ralph.plexio.private>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Is there a Howto for mdadm newbies? The Software raid Howto is too old
to reference mdadm. I have some questions on how to proceed:

1. Do I need to mark my raid1 partitions with the type fd?
2. I tried:  
   mdadm -C /dev/md0 --level raid1 --raid-disks 2 /dev/hda1 missing 
   and got the message:
   md: can not import hda1, has active inodes!
   md: error, md_import_device() returned -16
   Does this mean that the partitions to be added to /dev/md0 must be
   unmounted?
3. If #2 is yes then how do I convert my partitions to raid1? In using 
   raidtools, I simply copied the live drive contents to a spare drive 
   with "fd" type partitions and followed the instructions in the
   Boot+Root+Raid+LILO Howto.
4. Is it possible to boot root raid1 with mdadm and no autodetect?

I am running kernel 2.4.18 with raid1 compiled in.

Thanks for your help,
Stephen


