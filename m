From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: GRUB warning after replacing disk drive in RAID1
Date: Wed, 1 Mar 2017 15:51:12 -0800
Message-ID: <008401d292e6$b6d743e0$2485cba0$@wnsdev.com>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com> <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net> <008001d29205$e4f503c0$aedf0b40$@wnsdev.com> <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net> <009601d29218$9fd3e460$df7bad20$@wnsdev.com> <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>, 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>{ Convention on kernel.org is to reply-to-all, trim unneeded quoted material, and bottom post or interleave.  Please do so. }

Yes.  thank you.

>Grub1 needs its boot partitions to use v0.90 or v1.0 superblocks.  Grub2 needs the md module in its core to boot from v1.1 or v1.2 superblocks.
>Anyways, because the content of a v1.2 array does not start at the beginning of the member devices, stupid grub doesn't connect sd[abc]1 with your /boot mount >and therefore delivers 'null'.
>And then doesn't know how to link the core together.

can't say I understand all that but does this mean the server can't boot from the replacement drive?  



