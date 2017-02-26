From: Reindl Harald <h.reindl@thelounge.net>
Subject: RAID10 reshape and change lout possible?
Date: Sun, 26 Feb 2017 15:37:24 +0100
Message-ID: <ae9c2ffb-808a-c905-ea29-1c8f5493b2ad@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

since in recent news i saw that convert several raid-levels with respahe 
is possible now

is it somehow possible to change a existing md RAID10 array from "2 
near-copies" to "2 far-copies" and what would be the mdadm syntax? the 
IO intense workload here are large reads within virtual disks and as far 
as i can see far-layout would here be the better option but as installed 
the stuff in 2011 not sure if anaconda even offered that in the OS installer

so i would like to change the layout "on-the-fly" without dump/restore 
data (which is hard for the OS itself while keep dracut and friends 
working just fine) and also important keep all the UUID's (there is a 
second cloned machine which is in large parts rsynced including 
grub-config and fstab)


