From: Brad Campbell <brad@wasp.net.au>
Subject: raid6 creation with mdadm
Date: Thu, 22 Apr 2004 16:57:49 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4087C14D.6030605@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

I'm currently adding raid6 support to raidreconf, and as part of my testing I'm doing all sorts of
nasty things to a 200GB usb2 hard disk.
What happens when I create a raid5 or raid6 with devices of differing sizes? ie the partition list
below.
I can create a raid6 of /dev/sda[5-9] /dev/sda1[0-2] and it lets me do it, it runs and everyone is
happy, except for raidreconf. When I get right to the end of the disk, what happens to the block
calculations if the required blocks don't exist on one of the disks? Or does the md driver base the
whole /dev/md size on the smallest device?

I'm just wondering how to go about assisting raidreconf in coping with this really odd case, as at
the moment it converts everything and then dies painfully before it restores anything to a workable
state. What Would The Kernel Do? (WWKD)


brad@tv:~$ fdisk -l /dev/sda

Disk /dev/sda: 199.9 GB, 199998918656 bytes
255 heads, 63 sectors/track, 24315 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1        1217     9775521    5  Extended
/dev/sda2            1218        1248      249007+  83  Linux
/dev/sda3            1249        1279      249007+  83  Linux
/dev/sda4            1280        1310      249007+  83  Linux
/dev/sda5               1          31      248944+  83  Linux
/dev/sda6              32          62      248976   83  Linux
/dev/sda7              63          93      248976   83  Linux
/dev/sda8              94         124      248976   83  Linux
/dev/sda9             125         155      248976   83  Linux
/dev/sda10            156         186      248976   83  Linux
/dev/sda11            187         217      248976   83  Linux
/dev/sda12            218         248      248976   83  Linux
/dev/sda13            249         279      248976   83  Linux
/dev/sda14            280         310      248976   83  Linux
/dev/sda15            311         341      248976   83  Linux

Regards,
Brad

