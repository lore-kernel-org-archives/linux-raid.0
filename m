From: Michael Schmitt <mschmitt@unixkiste.org>
Subject: inconsitent harddisks, still after checkarray run
Date: Mon, 05 Feb 2007 12:03:05 +0100
Message-ID: <1170673385.17563.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List,

I do have a major problem mith a softraid (partitionable raid1). As it
seemed, one machine was faulty (when under heavy load, write was faulty)
so I replaced that computer, just the SATA Controller, the harddiscs and
the gfx card is the same. I noticed that, as I tried to burn those
images and k3b gave me all the time different md5sums after it has
checked what it has burned. So I checked the files on my own with md5sum
and got the same results. As it was reproducible even after
redoanloading those files I tried to pinpoint the faulty hardware, and
as it seemed the mainboard is broken. So I changed mainboard/CPU/RAM and
after that, I redownloaded that file and the md5sum is all the time the
same.
So, one seems clear, the mainboard was broken, ok... but as I tried to
resync the raid those different md5sums do persist!

This is what I did to check the md5sums:

for i in $(seq 5); do echo \#$i; time md5sum BigFile.putt/BigFile.iso;
time md5sum md5sum BigFile/BigFile.iso; done && for i in $(seq 10); do
echo \#$i; time md5sum BigFile/BigFile.iso; time md5sum
BigFile.putt/BigFile.iso; done

mschmitt@elara:/mnt/md_d0p4/pub$ grep Big /tmp/md5summen.txt |grep -v
putt
d410a7ee50eaa9bee8ec7467a82aa364  BigFile/BigFile.iso
d410a7ee50eaa9bee8ec7467a82aa364  BigFile/BigFile.iso
d410a7ee50eaa9bee8ec7467a82aa364  BigFile/BigFile.iso
d410a7ee50eaa9bee8ec7467a82aa364  BigFile/BigFile.iso
d410a7ee50eaa9bee8ec7467a82aa364  BigFile/BigFile.iso

mschmitt@elara:/mnt/md_d0p4/pub$ grep Big /tmp/md5summen.txt |grep  putt
901ee9aafb44cbc2c3567500257be0d9  BigFile.putt/BigFile.iso
bebd9d6c4bdef9dd6916090626b78c0a  BigFile.putt/BigFile.iso
bebd9d6c4bdef9dd6916090626b78c0a  BigFile.putt/BigFile.iso
901ee9aafb44cbc2c3567500257be0d9  BigFile.putt/BigFile.iso
901ee9aafb44cbc2c3567500257be0d9  BigFile.putt/BigFile.iso
mschmitt@elara:/mnt/md_d0p4/pub$

What should I do? Is this a bug? Is my hardware still faulty? I don't
think so, as all new stuff written to that array is consistent...

Please cc me, I am on the list, but sometimes I miss the posts because
they are filtered/sorted by my mailclient.

TIA
Michael

P.S.: just some infos on my setup:

$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath] [faulty]
md_d0 : active raid1 sda[0] sdb[1]
      120060800 blocks [2/2] [UU]

unused devices: <none>

$ uname -r
2.6.18-8-P4 (homegrown kernel out of debian kernel sources)


$ lspci|grep -i sata
00:06.0 RAID bus controller: Silicon Image, Inc. SiI 3512
[SATALink/SATARaid] Serial ATA Controller (rev 01)

$ dpkg -l mdadm
[...]
ii  mdadm   2.5.6-8  [...]

Debian sid

