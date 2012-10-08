From: Massimo Gais <massimo.gais@iki.fi>
Subject: Issue recovering a md device with first 4kB lost.
Date: Tue, 9 Oct 2012 01:46:15 +0300
Message-ID: <CAPpPG0UTjpwiWQyxKsT+JcZt3VgDeGBVddUBd_+8a2+U-50AzA@mail.gmail.com>
References: <CAPpPG0WfVjk7qoC=EdJ=E=vt1uK8amMr9Hb0Q_P0tVyy63f+_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpPG0WfVjk7qoC=EdJ=E=vt1uK8amMr9Hb0Q_P0tVyy63f+_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm trying to recover an ext4 filesystem in a md device of a degraded
RAID 1 array (i.e. last copy of the mirror), where the beginning of
the partition that was hosting the md device was unreadable, due to
disk failure. Unfortunately I don't have the mdadm.conf file.
Using dd, I was able to copy entirely the damaged partition to a
different disk, except the first 4096 bytes (dd returns I/O error
there).
The md device has been probably created with mdadm v3.14, and under
kernel 2.6.32.12, and it uses metadata v1.2.
From a hexdump, at offset 0x21200 I can see the marker 'LABELONE' and
shortly after that the 'LVM2' (the ext4 partition in question is
contained in a LVM volume).
From my understanding, with metadata 1.2 at offset 0x1000 there should
be the the md superblock, but from the hexdump, nor at 0x1000 and
nowhere in the first 10MB of the partition I can find the 0xa92b4efc
'magic number'. The first non-zero byte in that partition is at offset
0x21200.

I think all what is missing in order to access the ext4 filesystem is
the md superblock, but what can I do to recreate it?
I tried some thing like: mdadm --create /dev/md4 --level=1 --force
--raid-devices=1 --metadata=1.2 --assume-clean /dev/sdd5, but the
command doesn't seem to help and actually after being executed I
noticed I cannot even find anymore the LVM2 marker in the physical
partition behind.

Thanks
