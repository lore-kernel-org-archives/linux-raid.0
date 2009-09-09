From: Nagilum <nagilum@nagilum.org>
Subject: Re: Software Raid 5 work on ROOT ?
Date: Wed, 09 Sep 2009 18:57:57 +0200
Message-ID: <20090909185757.21404cr9zf6dtack@cakebox.homeunix.net>
References: <1252059563.4aa0e9ab25de3@imp.free.fr>
 <20090908123422.13526q1f9zbd1dcs@cakebox.homeunix.net>
 <70ed7c3e0909080536n2ce8cdf0tce16916999eae8b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909080536n2ce8cdf0tce16916999eae8b0@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: lfmarante@free.fr, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a rescue system on the same USB stick (it's 1GB).
So I can have a full linux system to debug my RAID if there should be =20
problems.
=46or me LVM doesn't really make any difference the limiting factor is =
=20
dmcrypt. Still the RAID5 with LVM+crypto+xfs does ~100MB/s sequential =20
reading. (>300MB/s from md0 directly) That's more than I need.
Kind regards,

----- Message from majedb@gmail.com ---------
     Date: Tue, 8 Sep 2009 15:36:53 +0300
     From: "Majed B." <majedb@gmail.com>
  Subject: Re: Software Raid 5 work on ROOT ?
       To: Nagilum <nagilum@nagilum.org>
       Cc: lfmarante@free.fr, linux-raid@vger.kernel.org


> I was able to install & boot Slamd64 (a 64-bit port of Slackware) wit=
h
> raid5 directly. I wrote a HOWTO on Slamd64's forums, but I can't
> access them now, but luckily I wrote a copy of my own:
> http://mbhtech.blogspot.com/2008/01/raid-expansion-and-beauty-of-xfs.=
html
>
> You'll need to put separate /boot from the rest, and I don't know
> whether this works with grub or not; I used LILO.
>
> I faced one problem a few months back where the array broke (one disk
> jumped out) and I couldn't access my system at all, because the syste=
m
> wouldn't boot from a degraded array. I had to put the installation CD
> and fix it from there.
>
> Maybe if I had compiled busybox into the kernel, I would've saved
> myself some trouble. Also, I read a few days back that you could pass
> a parameter to the kernel to make it boot a degraded array. I don't
> remember where or what the syntax was unfortunately.
>
> I hope this helps!
>
> P.S.: I'd skip LVM. I've been speed-testing it lately and its
> performance is quite crippling. The read speed of the array directly
> is 125 MB/s, while the Logical Volume reads at 43 MB/s only!
>
> 2009/9/8 Nagilum <nagilum@nagilum.org>:
>> The way I worked around this is to boot off of a USB stick.
>> So grub is installed on the USB stick, reads the kernel and the init=
rd from
>> it, the initrd brings up the disk, the raid, the dm-crypt and the lv=
m,
>> mounts / from the lvm and boots it.
>> Kind regards,
>>
>> ----- Message from lfmarante@free.fr ---------
>> =C2=A0 =C2=A0Date: Fri, 04 Sep 2009 12:19:23 +0200
>> =C2=A0 =C2=A0From: lfmarante@free.fr
>> =C2=A0Subject: Software Raid 5 work on ROOT ?
>> =C2=A0 =C2=A0 =C2=A0To: linux-raid@vger.kernel.org
>>
>>
>>> Hello every body.
>>>
>>> I have a question in regard of booting linux under a raid 5. It is
>>> possible ?
>>> All the guides that I found on the net say to have a /boot not stri=
pped,
>>> (raid1
>>> is ok). [EX:
>>> http://www.gentoo.org/doc/en/gentoo-x86+raid+lvm2-quickinstall.xml
>>> ]
>>>
>>> They say to have / not stripped too. And these guide show to have a=
n raid
>>> 1 boot
>>> and / and create a LVM volume for /usr /opt /var /whatever that can=
 be
>>> raid 5.
>>> It is not easiest to have directly / in raid 5 format ?
>>> If it's possible I would prefere to have raid 5 /
>>> There any particular configuration for grub to boot it?
>>>
>>> Thanks in advance.
>>>
>
----- End message from majedb@gmail.com -----



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 =
#
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 =
#
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   =
#
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux =
#
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 =
#
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
