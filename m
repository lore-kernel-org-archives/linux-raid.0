From: Semyon Enskiy <semyon.enskiy@yandex.ru>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Thu, 26 Nov 2015 16:21:36 +0300
Message-ID: <3145991448544096@web18m.yandex.ru>
References: <189791448292518@web28m.yandex.ru> <565359F6.3020201@turmel.org>
	 <3822301448453563@web17m.yandex.ru> <5655B62F.2070806@turmel.org>
	 <240681448462882@web25o.yandex.ru> <939171448463324@web17m.yandex.ru>
	 <5655D75B.9020901@turmel.org> <166511448468944@web24o.yandex.ru>
	 <5655E8D1.2050906@turmel.org> <398591448472730@web17m.yandex.ru> <5655F4B1.4030403@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5655F4B1.4030403@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Should say firstly, that before committing any changes, 10 MB of /dev/sd?3
head and tail was dumped, so array can be returned to initial state.

> mdadm --create --assume-clean --chunk=512 --data-offset=262144 \
>    --level=5 --raid-devices=10 --metadata=1.2 /dev/md3 \
>    /dev/sd{f,i,h,g,d,e,b,c}3 missing /dev/sdj3

Done this with overwriting old superblock, no errors occurred.

Then I booted to Debian Live, mdadm.conf got old array description with new
one, so old was commented:
# ARRAY /dev/md/3  metadata=1.2 UUID=9bdc0939:483889af:b67c199b:2aaecb4e name=ubuntu:3
   spares=1
ARRAY /dev/md/3  metadata=1.2 UUID=89dc7cd3:a7641d65:fe399415:9cdfd5a5 name=bnt:3

Previously "blkid" returned
/dev/md3: UUID="4bz7kl-2QWk-4YZX-IDmH-IFXL-eM3l-F2dB2n" TYPE="LVM2_member"
now nothing.
Regardless to this I am attempted to start LVM, LVM was waiting dev with
UUID from blkid output, so starting was possible only on recovery mode,
"--activationmode partial", as result "data" logical volume's block dev was
created as in past, but mount not found FS superblock, LVM reported errors
on logical extend at that time. As I remember, the Testdisk utility reported
buffer I/O errors while running on logical volume's block dev, but reported
nothing while running on array's block dev.

Apparently, revert-reshape was unsuccessful, so I'm going to collect more
information before going to forward.
