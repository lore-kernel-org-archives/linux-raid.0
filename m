From: Jurriaan <thunder7@xs4all.nl>
Subject: Re: Fedora 2.0 - raid1 not working
Date: Tue, 9 Nov 2004 20:41:27 +0100
Message-ID: <20041109194127.GA17963@middle.of.nowhere>
References: <419115A5.4050905@skybuilders.com> <20041109192219.GA5822@middle.of.nowhere> <41911ACB.2070604@skybuilders.com>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41911ACB.2070604@skybuilders.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Burkhardt <jesse@skybuilders.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jesse Burkhardt <jesse@skybuilders.com>
Date: Tue, Nov 09, 2004 at 02:30:19PM -0500
>    Hi Jurriaan,
> 
>    Your interpretation of my scenerio is correct. Boot is successful when
>    both drives A and B are present; also when just drive B is present, but
>    not when just drive A is present.
> 
>    I am using a grub loader which ennumerates thusly:
> 
>    /boot/grub/menu.lst
> 
>    default=0
>    timeout=10
>    splashimage=(hd0,0)/grub/splash.xpm.gz
>    title Fedora Core (2.6.5-1.358)
>            root (hd0,0)
>            kernel /vmlinuz-2.6.5-1.358 ro root=/dev/md1 rhgb quiet
>            initrd /initrd-2.6.5-1.358.img
> 
I'm still not clear on what happens when boot isn't succesful. Do you
get error messages from grub? If so, what do they say?

Also note that while my menu.lst works fine and lets me boot from both
drives, I haven't tested disconnecting one. I know where my data is, and
my backup, and in case of trouble, I can (and have tested that I can)
boot from a Knoppix-cd.

Kind regards,
Jurriaan
-- 
and even as Pug spoke, he knew the answer to his question.
"Whom must I seek?"
The girl's eyes seemed to pierce his soul. Calmly she said,
"You must find Macros the Black."
        Raymond E Feist - A Darkess at Sethanon
Debian (Unstable) GNU/Linux 2.6.9-mm1 2x6078 bogomips load 0.32
