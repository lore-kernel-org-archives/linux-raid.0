From: Phil Turmel <philip@turmel.org>
Subject: Re: GRUB warning after replacing disk drive in RAID1
Date: Wed, 1 Mar 2017 13:29:51 -0500
Message-ID: <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com>
 <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net>
 <008001d29205$e4f503c0$aedf0b40$@wnsdev.com>
 <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net>
 <009601d29218$9fd3e460$df7bad20$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <009601d29218$9fd3e460$df7bad20$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Peter, Reindl,

{ Convention on kernel.org is to reply-to-all, trim unneeded quoted
material, and bottom post or interleave.  Please do so. }

On 02/28/2017 06:15 PM, Peter Sangas wrote:

> cat /proc/mdstat
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4]
> [raid10] 

> md0 : active raid1 sdc1[3] sdb1[1] sda1[0]
>       19514368 blocks super 1.2 [3/3] [UUU]

Grub1 needs its boot partitions to use v0.90 or v1.0 superblocks.  Grub2
needs the md module in its core to boot from v1.1 or v1.2 superblocks.
Anyways, because the content of a v1.2 array does not
start at the beginning of the member devices, stupid grub doesn't
connect sd[abc]1 with your /boot mount and therefore delivers 'null'.
And then doesn't know how to link the core together.

Since this worked before, I would guess your grub was updated and its md
support was left out.  Hopefully someone with more grub experience can
chip in here -- I don't use any bootloader on my servers any more.

Phil
