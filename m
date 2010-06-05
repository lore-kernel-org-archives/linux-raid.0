From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID Configuration For New Home Server
Date: Sat, 5 Jun 2010 12:41:27 -0700
Message-ID: <AANLkTinbN9-ne0ySKq-GRGLiIhHopH_a-vtysx7yjmob@mail.gmail.com>
References: <AANLkTilAzPKlOMecKpQLIEPOqAhFDglR5STq3_QP_caW@mail.gmail.com>
	<A8.CB.03181.F378A0C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A8.CB.03181.F378A0C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Carlos Mennens <carloswill@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jun 5, 2010 at 10:19 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Carlos Mennens
>> Sent: Wednesday, June 02, 2010 8:00 AM
>> To: Mdadm
>> Subject: Re: RAID Configuration For New Home Server
>>
>> On Wed, Jun 2, 2010 at 3:54 AM, =C2=A0<tron@monkii.net> wrote:
>> > There are about as many answers to this as there are people using =
your
>> > setup so let's all agree that there's no "one way" of doing things=
=2E
>>
>> Thanks for all the suggestions and you guys are right. There will no
>> right or wrong answer here but I just want to make sure I am not doi=
ng
>> anything that will hinder / limit performance in my system. At most =
my
>> system will simply idle and do nothing more than store a few files f=
or
>> me so I think RAID5 is going to be my selection for my / file system=
=2E
>> I have 4 identical drives and need to partition them all the same to
>> avoid any inconsistencies across the RAID array. Since Grub doesn't
>> support RAID5 for /boot, I will need to make a 4 disk RAID1 for /boo=
t
>> & do the same for Swap. Does this look reasonable to you guys?
>>
>> Partitioning the 1st disk below:
>>
>> /dev/sda1 100 MB - RAID (bootable)
>> /dev/sda2 =C2=A0 =C2=A0 2 GB - RAID
>> /dev/sda3 320 GB - RAID
>>
>> Do that same partition schema above for all 4 drives and then create=
 my
>> RAID:
>>
>> /
>> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D4 /dev/sda3 /de=
v/sdb3
>> /dev/sdc3 /dev/sdd3
>>
>> /boot
>> mdadm --create /dev/md1 --level=3D1 --raid-devices=3D4 /dev/sda1 /de=
v/sdb1
>> /dev/sdc1 /dev/sdd1
>>
>> Swap
>> mdadm --create /dev/md2 --level=3D1 --raid-devices=3D4 /dev/sda2 /de=
v/sdb2
>> /dev/sdc2 /dev/sdd2
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0It's certainly workable. =C2=A0You might c=
onsider something other than
> RAID1 for your swap partition.

Looks reasonable. Some comments:

1) I didn't bother using RAID on my /boot. I just installed grub on
each of the 3 drives but only boot from the first one. If that
partition goes bad I can boot from the second or third drive any time
by just telling BIOS to use a different drive. This saves me from
dealing with any mkinitrd stuff. I've never had a boot partition go
bad because of the drive itself in 14 years running Linux. They go bad
because I write the wrong stuff there. RAID doesn't solve that
problem. This method does require that I update the two backups by
hand once in awhile. That's OK by me.

2) I don't use RAID for swap. I let the kernel do that internally. I
almost never swap out on my home server so trying to protect that with
RAID for the few moments I might use it seems like overkill to me.

3) Your main RAID is exactly what I use on my home server, albeit I
use 3 drives, not 4.

HTH,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
