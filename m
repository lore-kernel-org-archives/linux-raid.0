From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: GRUB warning after replacing disk drive in RAID1
Date: Wed, 1 Mar 2017 15:36:45 -0800
Message-ID: <008101d292e4$b1aeafe0$150c0fa0$@wnsdev.com>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com> <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net> <008001d29205$e4f503c0$aedf0b40$@wnsdev.com> <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net> <009601d29218$9fd3e460$df7bad20$@wnsdev.com> <97135270-088a-69da-8789-c64f1054ee72@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <97135270-088a-69da-8789-c64f1054ee72@thelounge.net>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Reindl,

My comments are interleaved. thanks:
___________________________________________________

>#!/bin/bash

>GOOD_DISK="/dev/sda"
>BAD_DISK="/dev/sdc"

># clone MBR
>dd if=$GOOD_DISK of=$BAD_DISK bs=512 count=1

Here I run the command sfdisk -d /dev/$GOOD_DISK | sfdisk -f /dev/$BAD_DISK.

I think dd and sfdisk are doing the same thing which is cloning the
partitions and copy the MBR ?

># force OS to read partition tables
>partprobe $BAD_DISK

Why run partprobe if the partitions have not changed?


># install bootloader on replacement disk grub2-install "$BAD_DISK"

Here don't you mean grub-install not grub2-install?  
___________________________________________________



