From: "Jeffrey B. Layton" <laytonjb@charter.net>
Subject: mdadm array not found on reboot
Date: Mon, 07 May 2007 12:45:10 -0400
Message-ID: <463F5796.1060808@charter.net>
Reply-To: laytonjb@charter.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I apologize if this is a FAQ question or a typical newbie question,
but by google efforts have yielded anything yet.

I built a RAID-1 using mdadm (Centos 4.2 with 2.6.16.19 kernel
and mdadm 1.6.0-2). It's just two SATA drives that I created using:

mdadm --create --verbose /dev/md1 --level=raid1 --raid-devices=2 
/dev/sda1 /dev/sdb1

The md built correctly and I built an ext3 on it. I created /etc/mdadm.conf
and modified /etc/fstab to mount the device. But when I reboot, the kernel
drops into RAID repair mode because it can't seem to find /dev/md1 and
yells about not finding any valid superblock (I can get the exact message
if needed). However I can mount /dev/sda1 with no problems.

The only way I can get md1 back is to issue the command:

mdadm -A /dev/md1 /dev/sda1 /dev/sdb1

and everything works. I want to have /dev/md1 mounted automatically
on boot. I'm missing something simple here - how do I do this?

TIA!

Jeff

