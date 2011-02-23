From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: failed drive in raid 1 array
Date: Wed, 23 Feb 2011 16:20:39 -0300
Message-ID: <AANLkTimQhfvbx72izkg9qxMFkC0xixTPQa6aQ4HF04Hq@mail.gmail.com>
References: <4D653B57.1030203@supsi.ch>
	<AANLkTim+Sz9Hrpu0rPQt2r4-SgmGEt1svsrs26Ejrkoq@mail.gmail.com>
	<4D655D01.6040803@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D655D01.6040803@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i don=C2=B4t know how you setup your kernel (with or without raid
autodetect?) do you use kernel command line to setup raid? autodetect?
here in my test machine i=C2=B4m using kernel command line (grub), i do=
n=C2=B4t
have a server with hotplug bay, i open the case and remove the wire
with my hands =3D) after reconecting it with another device kerenel
recognize the new device reread the parititions etc etc and i can add
it to array again
my grub is something like:

md=3D0,/dev/sda,/dev/sdb .....

internal meta data, raid1, i didn=C2=B4t like the autodetect (it=C2=B4s=
 good)
but i prefer hardcoded kernel command line (it=C2=B4s not good with usb
devices)

2011/2/23 Roberto Nunnari <roberto.nunnari@supsi.ch>:
> Roberto Spadim wrote:
>>
>> sata2 without hot plug?
>
> Hi Roberto.
>
> I mean that there is no hot-plug bay, with sliding rails etc..
> The drives are connected to the mb using standard sata cables.
>
>
>> check if your sda sdb sdc will change after removing it, it=E6=84=80=
 depends
>> on your udev or another /dev filesystem
>
> Ok, thank you.
> That means that if I take care to check the above, and
> the new drive will be sdb, then taking the steps indicated
> in my original post will do the job?
>
> Best regards.
> Robi
>
>
>>
>> 2011/2/23 Roberto Nunnari <roberto.nunnari@supsi.ch>:
>>>
>>> Hello.
>>>
>>> I have a linux box, with two 2TB sata HD in raid 1.
>>>
>>> Now, one disk is in failed state and it has no spares:
>>> # cat /proc/mdstat
>>> Personalities : [raid1]
>>> md1 : active raid1 sdb4[2](F) sda4[0]
>>> =C2=A0 =C2=A0 1910200704 blocks [2/1] [U_]
>>>
>>> md0 : active raid1 sdb1[1] sda2[0]
>>> =C2=A0 =C2=A0 40957568 blocks [2/2] [UU]
>>>
>>> unused devices: <none>
>>>
>>>
>>> The drives are not hot-plug, so I need to shutdown the box.
>>>
>>> My plan is to:
>>> # sfdisk -d /dev/sdb > sdb.sfdisk
>>> # mdadm /dev/md1 -r /dev/sdb4
>>> # mdadm /dev/md0 -r /dev/sdb1
>>> # shutdown -h now
>>>
>>> replace the disk and boot (it should come back up, even without one
>>> drive,
>>> right?)
>>>
>>> # sfdisk /dev/sdb < sdb.sfdisk
>>> # mdadm /dev/md1 -a /dev/sdb4
>>> # mdadm /dev/md0 -a /dev/sdb1
>>>
>>> and the drives should start to resync, right?
>>>
>>> This is my first time I do such a thing, so please, correct me
>>> if the above is not correct, or is not a best practice for
>>> my configuration.
>>>
>>> My last backup of md1 is of mid november, so I need to be
>>> pretty sure I will not lose my data (over 1TB).
>>>
>>> A bit abount my environment:
>>> # mdadm --version
>>> mdadm - v1.12.0 - 14 June 2005
>>> # cat /etc/redhat-release
>>> CentOS release 4.8 (Final)
>>> # uname -rms
>>> Linux 2.6.9-89.31.1.ELsmp i686
>>>
>>> Thank you very much and best regards.
>>> Robi
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
