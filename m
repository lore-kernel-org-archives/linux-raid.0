From: Phil Turmel <philip@turmel.org>
Subject: Re: GRUB warning after replacing disk drive in RAID1
Date: Wed, 1 Mar 2017 19:05:59 -0500
Message-ID: <ce5ec33c-c38b-de76-1976-bea9e7caba68@turmel.org>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com>
 <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net>
 <008001d29205$e4f503c0$aedf0b40$@wnsdev.com>
 <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net>
 <009601d29218$9fd3e460$df7bad20$@wnsdev.com>
 <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org>
 <008401d292e6$b6d743e0$2485cba0$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008401d292e6$b6d743e0$2485cba0$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2017 06:51 PM, Peter Sangas wrote:
> 
>> { Convention on kernel.org is to reply-to-all, trim unneeded quoted material, and bottom post or interleave.  Please do so. }
> 
> Yes.  thank you.
> 
>> Grub1 needs its boot partitions to use v0.90 or v1.0 superblocks.  Grub2 needs the md module in its core to boot from v1.1 or v1.2 superblocks.
>> Anyways, because the content of a v1.2 array does not start at the beginning of the member devices, stupid grub doesn't connect sd[abc]1 with your /boot mount >and therefore delivers 'null'.
>> And then doesn't know how to link the core together.
> 
> can't say I understand all that but does this mean the server can't boot from the replacement drive?  

Correct.  But it shouldn't be able to boot from the others either, with
grub1.  Something has changed in your grub install since you set up the
original drives.  Only grub2 would be able to boot from your v1.2 md0.

{ Sorry.  I don't know how to fix grub2's md module. }

Phil

