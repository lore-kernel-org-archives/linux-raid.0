From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: GRUB warning after replacing disk drive in RAID1
Date: Tue, 7 Mar 2017 12:54:19 +0000
Message-ID: <58BEAD7B.5070709@youngman.org.uk>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com>
 <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net>
 <008001d29205$e4f503c0$aedf0b40$@wnsdev.com>
 <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net>
 <009601d29218$9fd3e460$df7bad20$@wnsdev.com>
 <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org>
 <58B81B80.6020708@youngman.org.uk>
 <008401d296c6$f5ee1e80$e1ca5b80$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008401d296c6$f5ee1e80$e1ca5b80$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, 'Phil Turmel' <philip@turmel.org>, 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/03/17 22:13, Peter Sangas wrote:
> In addition,  the wiki says " you will need to configure your distro to use an initramfs.
> 
> here are the last few lines of my grub.cnf: 
> 
>          echo    'Loading Linux 4.4.0-36-generic ...'
>          linux    /vmlinuz-4.4.0-36-generic root=UUID=cddffa50-9713-4205-aab6-86745735958b ro recovery nomodeset 
>          echo    'Loading initial ramdisk ...'
>          initrd   /initrd.img-4.4.0-36-generic
> 
> should I be concerned my grub.cnf uses initrd.img and not initramfs?   My grub.cnf was last modified 11/2016 and I've rebooted successfully into a RAID1 since.

I think your problem is right there !!!

Look at the wiki, but I can NOT see the magic command "domdadm", without
which mdadm doesn't get loaded and the array doesn't get assembled. No
array, no root, no system ...

(Oh - initrd, initramfs, they're probably the same thing. :-)

Cheers,
Wol
