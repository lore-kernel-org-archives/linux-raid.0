From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: failed drive in raid 1 array
Date: Wed, 23 Feb 2011 22:24:14 +0100
Message-ID: <4D657AFE.3010605@supsi.ch>
References: <4D653B57.1030203@supsi.ch>	<AANLkTim+Sz9Hrpu0rPQt2r4-SgmGEt1svsrs26Ejrkoq@mail.gmail.com>	<4D655D01.6040803@supsi.ch> <AANLkTimQhfvbx72izkg9qxMFkC0xixTPQa6aQ4HF04Hq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimQhfvbx72izkg9qxMFkC0xixTPQa6aQ4HF04Hq@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roberto Spadim wrote:
> i don=C2=B4t know how you setup your kernel (with or without raid

I use the official CentOS kernel with no modification and don't
know about raid autodetect, but:
# cat /boot/config-2.6.24-28-server |grep -i raid
CONFIG_BLK_DEV_3W_XXXX_RAID=3Dm
CONFIG_MD_RAID0=3Dm
CONFIG_MD_RAID1=3Dm
CONFIG_MD_RAID10=3Dm
CONFIG_MD_RAID456=3Dm
CONFIG_MD_RAID5_RESHAPE=3Dy
CONFIG_MEGARAID_LEGACY=3Dm
CONFIG_MEGARAID_MAILBOX=3Dm
CONFIG_MEGARAID_MM=3Dm
CONFIG_MEGARAID_NEWGEN=3Dy
CONFIG_MEGARAID_SAS=3Dm
CONFIG_RAID_ATTRS=3Dm
CONFIG_SCSI_AACRAID=3Dm


> autodetect?) do you use kernel command line to setup raid? autodetect=
?

/dev/md0 in grub
I don't know if that means autodetect, but I guess so..


> here in my test machine i=C2=B4m using kernel command line (grub), i =
don=C2=B4t
> have a server with hotplug bay, i open the case and remove the wire
> with my hands =3D) after reconecting it with another device kerenel

Is it safe? Isn't it a blind bet to fry up the controller and/or disk?


> recognize the new device reread the parititions etc etc and i can add
> it to array again
> my grub is something like:
>=20
> md=3D0,/dev/sda,/dev/sdb .....
>=20
> internal meta data, raid1, i didn=C2=B4t like the autodetect (it=C2=B4=
s good)
> but i prefer hardcoded kernel command line (it=C2=B4s not good with u=
sb
> devices)

the relevant part of my grub is:

default=3D0
timeout=3D5
splashimage=3D(hd0,0)/grub/splash.xpm.gz
hiddenmenu
title CentOS (2.6.9-89.31.1.ELsmp)
         root (hd0,0)
         kernel /vmlinuz-2.6.9-89.31.1.ELsmp ro root=3D/dev/md0 rhgb qu=
iet
         initrd /initrd-2.6.9-89.31.1.ELsmp.img

Best regards.
Robi


>=20
> 2011/2/23 Roberto Nunnari <roberto.nunnari@supsi.ch>:
>> Roberto Spadim wrote:
>>> sata2 without hot plug?
>> Hi Roberto.
>>
>> I mean that there is no hot-plug bay, with sliding rails etc..
>> The drives are connected to the mb using standard sata cables.
>>
>>
>>> check if your sda sdb sdc will change after removing it, it=E6=84=80=
 depends
>>> on your udev or another /dev filesystem
>> Ok, thank you.
>> That means that if I take care to check the above, and
>> the new drive will be sdb, then taking the steps indicated
>> in my original post will do the job?
>>
>> Best regards.
>> Robi
>>
>>
>>> 2011/2/23 Roberto Nunnari <roberto.nunnari@supsi.ch>:
>>>> Hello.
>>>>
>>>> I have a linux box, with two 2TB sata HD in raid 1.
>>>>
>>>> Now, one disk is in failed state and it has no spares:
>>>> # cat /proc/mdstat
>>>> Personalities : [raid1]
>>>> md1 : active raid1 sdb4[2](F) sda4[0]
>>>>     1910200704 blocks [2/1] [U_]
>>>>
>>>> md0 : active raid1 sdb1[1] sda2[0]
>>>>     40957568 blocks [2/2] [UU]
>>>>
>>>> unused devices: <none>
>>>>
>>>>
>>>> The drives are not hot-plug, so I need to shutdown the box.
>>>>
>>>> My plan is to:
>>>> # sfdisk -d /dev/sdb > sdb.sfdisk
>>>> # mdadm /dev/md1 -r /dev/sdb4
>>>> # mdadm /dev/md0 -r /dev/sdb1
>>>> # shutdown -h now
>>>>
>>>> replace the disk and boot (it should come back up, even without on=
e
>>>> drive,
>>>> right?)
>>>>
>>>> # sfdisk /dev/sdb < sdb.sfdisk
>>>> # mdadm /dev/md1 -a /dev/sdb4
>>>> # mdadm /dev/md0 -a /dev/sdb1
>>>>
>>>> and the drives should start to resync, right?
>>>>
>>>> This is my first time I do such a thing, so please, correct me
>>>> if the above is not correct, or is not a best practice for
>>>> my configuration.
>>>>
>>>> My last backup of md1 is of mid november, so I need to be
>>>> pretty sure I will not lose my data (over 1TB).
>>>>
>>>> A bit abount my environment:
>>>> # mdadm --version
>>>> mdadm - v1.12.0 - 14 June 2005
>>>> # cat /etc/redhat-release
>>>> CentOS release 4.8 (Final)
>>>> # uname -rms
>>>> Linux 2.6.9-89.31.1.ELsmp i686
>>>>
>>>> Thank you very much and best regards.
>>>> Robi

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
