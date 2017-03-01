From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: GRUB warning after replacing disk drive in RAID1
Date: Wed, 1 Mar 2017 23:13:16 +0100
Message-ID: <b900aca8-7f61-2516-8c6a-a9dd25ce2f17@thelounge.net>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com>
 <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net>
 <008001d29205$e4f503c0$aedf0b40$@wnsdev.com>
 <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net>
 <009601d29218$9fd3e460$df7bad20$@wnsdev.com>
 <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 01.03.2017 um 19:29 schrieb Phil Turmel:
> Hi Peter, Reindl,
>
> { Convention on kernel.org is to reply-to-all, trim unneeded quoted
> material, and bottom post or interleave.  Please do so. }

why should someone reply to the list and everyboy else subscribed to the 
list to trigger multiple copies?

> On 02/28/2017 06:15 PM, Peter Sangas wrote:
>
>> cat /proc/mdstat
>> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4]
>> [raid10]
>
>> md0 : active raid1 sdc1[3] sdb1[1] sda1[0]
>>       19514368 blocks super 1.2 [3/3] [UUU]
>
> Grub1 needs its boot partitions to use v0.90 or v1.0 superblocks.  Grub2
> needs the md module in its core to boot from v1.1 or v1.2 superblocks.
> Anyways, because the content of a v1.2 array does not
> start at the beginning of the member devices, stupid grub doesn't
> connect sd[abc]1 with your /boot mount and therefore delivers 'null'.
> And then doesn't know how to link the core together.
>
> Since this worked before, I would guess your grub was updated and its md
> support was left out.  Hopefully someone with more grub experience can
> chip in here -- I don't use any bootloader on my servers any more

i am not the OP *but* i can assure you that i get the same warnings when 
the /boot RAID1 is not synced, afetr hat grub2-install works just fine 
without that warning and so you can be sure grub has no problem and is 
missing nothing, otherwise the command won't work without warnings afetr 
all arrays are in ync again

[root@srv-rhsoft:~]$ cat /proc/mdstat
Personalities : [raid1] [raid10]
md2 : active raid10 sdc3[4] sdd3[7] sda3[6] sdb3[5]
       3875222528 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]

md0 : active raid1 sdc1[4] sdd1[7] sdb1[5] sda1[6]
       511988 blocks super 1.0 [4/4] [UUUU]

md1 : active raid10 sdc2[4] sdd2[7] sdb2[5] sda2[6]
       30716928 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]
