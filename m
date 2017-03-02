From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: GRUB warning after replacing disk drive in RAID1
Date: Thu, 2 Mar 2017 15:00:40 -0800
Message-ID: <008d01d293a8$d24b1350$76e139f0$@wnsdev.com>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com> <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net> <008001d29205$e4f503c0$aedf0b40$@wnsdev.com> <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net> <009601d29218$9fd3e460$df7bad20$@wnsdev.com> <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org> <008401d292e6$b6d743e0$2485cba0$@wnsdev.com> <ce5ec33c-c38b-de76-1976-bea9e7caba68@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ce5ec33c-c38b-de76-1976-bea9e7caba68@turmel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>, 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Correct.  But it shouldn't be able to boot from the others either, with grub1.
> Something has changed in your grub install since you set up the original drives.  Only
> grub2 would be able to boot from your v1.2 md0.
> 
> { Sorry.  I don't know how to fix grub2's md module. }
> 

Just to so I'm crystal clear : the server needs to have grub2 installed so doesn't this confirm grub2 is installed.

grub-install -V
grub-install (GRUB) 2.02~beta2-36ubuntu3.2

and since I'm running Ubuntu 16.04.1 LTS

from https://help.ubuntu.com/community/Grub2
"GRUB 2 is the default boot loader and manager for Ubuntu since version 9.10"
"GRUB 2 is version 1.98 or later"

What Am I missing?

