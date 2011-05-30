From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: disable raid autodetect at boot
Date: Mon, 30 May 2011 10:05:42 +0300
Message-ID: <4DE341C6.9020602@oldum.net>
References: <BANLkTim=K8b_3jD5RAdMT6+0TYQXNAHBtg@mail.gmail.com>	<4DDA388C.2020000@msgid.tls.msk.ru>	<BANLkTi=zLb7j_MvkTyQa=ifMAS+kDCkbvg@mail.gmail.com>	<4DDA5F51.3090501@msgid.tls.msk.ru> <BANLkTik=qRE_c5XWs6kjbT90otnmdGdaog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTik=qRE_c5XWs6kjbT90otnmdGdaog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,
you should most likely disable the assembly of the arrays in the initramfs pre/post startup subsystem scripts.

I have it configured such as when initramfs image is loaded it automagically detects all my raid drives, various
versions: 0.9 and 1.2.

For example:

$ gunzip < /boot/initrd.img-2.6.32-5-vserver-amd64 | cpio -i --make-directories
62745 blocks
$ ls
bin  conf  etc  init  lib  lib64  sbin  scripts


You can take it from here...

Cheers,
- -Nik

On 05/25/2011 06:15 PM, Alexander Lyakas wrote:
> Michael,
> thank you for your advice.
> 
> The only place where I saw mdadm is being called on boot is via
> /etc/init.d/mdadm, which starts mdadm with --monitor --scan options.
> Still I disabled the daemon start (in /etc/default/mdadm), but
> inactive raid keeps reappearing on boot.
> 
> How can I find out who else might be calling mdadm on boot?
> 
> Thanks,
>    Alex.
> 
> 
> On Mon, May 23, 2011 at 4:21 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>> 23.05.2011 16:50, Alexander Lyakas wrote:
>>> Michael,
>>> can you pls explain what do I need to look at to disable this.
>>
>>> On Mon, May 23, 2011 at 1:35 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>
>>>> This is not kernel autodetection, this is your initramfs/initrd
>>>> and mdadm.  Or maybe mdadm in the regular root filesystem.
>>
>> You need to find out where and how mdadm is called
>> on your system during bootup, and fix that place.
>>
>> /mjt
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJN40HGAAoJEDFLYVOGGjgXG/cH/R6IqX2rTr9Wjt9jxF6ad2GG
2r9AZpK7AV4m9ckDeqUYTrojjDA/rvOMVneMuqG22GgAt/JQ5M5AIZFlH39i8VfN
DL/DNd27hbjh+6rDd9I6LEDxCtO4UyAOtkI313fou8Yn8LdzOJvc9K58hsLUumhl
O+w/AmcOGFYnoOdVajobfDDQT1vb8TXYCA0rM6+w9+f94BQm1HPgxqJNfkBpry3P
N9qB0dngw7rnt1pXgYoi6zpiGSnqD/5tnnF9cYvq9HfRvK1/YwHAbwkZFDtuMwj1
lZOb6nC4MhPMmBFYW63FneGYW6YojUYDgSmJbWJHfwBRt2ScfgmfkR+sQ6R7AqM=
=MM9u
-----END PGP SIGNATURE-----
