From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: GRUB warning after replacing disk drive in RAID1
Date: Mon, 6 Mar 2017 14:13:58 -0800
Message-ID: <008401d296c6$f5ee1e80$e1ca5b80$@wnsdev.com>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com> <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net> <008001d29205$e4f503c0$aedf0b40$@wnsdev.com> <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net> <009601d29218$9fd3e460$df7bad20$@wnsdev.com> <5136f32b-a0bb-dc16-cae9-59946ea21622@turmel.org> <58B81B80.6020708@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58B81B80.6020708@youngman.org.uk>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Wols Lists' <antlists@youngman.org.uk>, 'Phil Turmel' <philip@turmel.org>, 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On March 02, 2017 5:18 AM, Wols Lists wrote :
> Look at the raid wiki
> 
> https://raid.wiki.kernel.org/index.php/Converting_an_existing_system
> 
> it mentions grub.

Wol, I'm trying to understand what you and others are suggesting is causing this grub warning.  

according to the raid.wiki you referenced the last line of grub.cnf should look like this to support booting from RAID:

         initrd  /boot/initramfs-genkernel-x86_64-4.4.6-gentoo

In addition,  the wiki says " you will need to configure your distro to use an initramfs.

here are the last few lines of my grub.cnf: 

         echo    'Loading Linux 4.4.0-36-generic ...'
         linux    /vmlinuz-4.4.0-36-generic root=UUID=cddffa50-9713-4205-aab6-86745735958b ro recovery nomodeset 
         echo    'Loading initial ramdisk ...'
         initrd   /initrd.img-4.4.0-36-generic

should I be concerned my grub.cnf uses initrd.img and not initramfs?   My grub.cnf was last modified 11/2016 and I've rebooted successfully into a RAID1 since.


Finally, on Friday 3/3 I swapped one of the disks (sdc) in this RAID1 with a brand new identical disk.  After creating the partitions and syncing I issued 
install-grub /dev/sdc and there were no warnings.   If my grub was broken why would there be no warning but a week ago doing the exact disk swap/same sequence of commands I got a warning.  Nothing on the system was changed during that time.


Thank you.



