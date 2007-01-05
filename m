From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: Raid1 : mounting a 1.0-version raid as root at boot time not working
Date: Fri, 5 Jan 2007 16:26:24 +0100
Message-ID: <fd8d0180701050726y6d972a62w8ea080cf0d07d8d9@mail.gmail.com>
References: <fd8d0180701050259m699e30b8o2c07cf8547e99406@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180701050259m699e30b8o2c07cf8547e99406@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From Documentation/md.txt

"As of kernel 2.6.9, only drives with a type 0 superblock can be
autodetected and run at boot time."

Sorry for the noise, I shall have understood that by myself...

In order to fix this issue, isn't it possible to implement in kernel a
behaviour close to what we can find in util.c: guess_super() of the
mdadm package ?
Would that be too dangerous ?
It seems to me that the tricky part is dealing with the ctime stuff of
all possible superblocks found...

Regards,

2007/1/5, Francois Barre <francois.barre@gmail.com>:
> Hi all,
>
> First of all, best wishes for 2007, may the Penguin be with you for
> the whole year on.
>
> Then, my problem.
>
> 1. The setup : x86_64 2x500GB sata, linux 2.6.18-6, raid 1 on
> /dev/sd[ab]1 -> /dev/md0.
> Raid1 is configured with a 1.0 superblock version, but no autoraid 0xfd stuff.
> The aim is to have / mounted on md0.
> Lilo has been teached to have root=/dev/md0 and
> md=0,/dev/sda1,/dev/sdb1, and with an explicit "raid=noautodetect".
> The rest is not (that) important.
>
> 2. The symptoms :
> At boot time, we do have the correct md: "Loading md0 :
> /dev/sda1,/dev/sdb1" message
> but while tryping to add /dev/sda1 in /dev/md0, we have :
> "md: /dev/sda1 has invalid sb, not importing!"
> Same thing for /dev/sdb1
>
> 3. My guess...
> I must test this a bit further, but my guess is as follows :
> - not being autodetected, /dev/md0 device is created using a 0.9
> version by default : in md.c: set_array_info(), as info is memset(),
> info->major_version is zero.
> - then at md.c: add_new_disk(), md_import_device() is called with
> mddev->major_version=0.
> - md_import_device() fails because it's told to load a superblock v0.x
> and it finds no superblock magic where it looks at it.
>
> 4. Conclusions
> First, is my analysis correct ?
> The box is being heavily used now (with a non-raid root...), so I
> can't test any further before tonight, but I may test using a v0.9
> superblock, and with autodetect stuff as well...
>
