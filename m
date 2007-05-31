From: Hubert Verstraete <hubskml@free.fr>
Subject: problems with faulty disks and superblocks 1.0, 1.1 and 1.2
Date: Thu, 31 May 2007 11:20:17 +0200
Message-ID: <465E9351.2070505@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I'm having problems with a RAID-1 configuration. I cannot re-add a disk 
that I've failed, because each time I do this, the re-added disk is 
still seen as failed.
After some investigations, I found that this problem only occur when I 
create the RAID array with superblocks 1.0, 1.1 and 1.2.
With the superblock 0.90 I don't encounter this issue.

Here are the commands to easily reproduce the issue

mdadm -C /dev/md_d0 -e 1.0 -l 1 -n 2 -b internal -R /dev/sda /dev/sdb
mdadm /dev/md_d0 -f /dev/sda
mdadm /dev/md_d0 -r /dev/sda
mdadm /dev/md_d0 -a /dev/sda
cat /proc/mdstat

The output of mdstat is:
Personalities : [raid1]
md_d0 : active raid1 sda[0](F) sdb[1]
       104849 blocks super 1.2 [2/1] [_U]
       bitmap: 0/7 pages [0KB], 8KB chunk
unused devices: <none>

I'm wondering if the way I'm failing and re-adding a disk is correct. 
Did I make something wrong?

If I change the superblock to "-e 0.90", there's no problem with this 
set of commands.

For now, I found a work-around with superblock 1.0 which consists in 
zeroing the superblock before re-adding the disk. But I suppose that 
doing so will force a full rebuild of the re-added disk, and I don't 
want this, because I'm using write-intent bitmaps.

I'm using mdadm - v2.5.6 on Debian Etch with kernel 2.6.18-4.

Bug or misunderstanding from myself? Any help would be appreciated :)

Thanks
Hubert
