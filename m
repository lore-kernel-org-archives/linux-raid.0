From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: failed drive in raid 1 array
Date: Thu, 24 Feb 2011 19:38:25 -0200
Message-ID: <AANLkTimYtUE0uVktJZOG3yQekYfOUNWdvkhfRQKdPzgp@mail.gmail.com>
References: <4D653B57.1030203@supsi.ch>
	<AANLkTim+Sz9Hrpu0rPQt2r4-SgmGEt1svsrs26Ejrkoq@mail.gmail.com>
	<4D655D01.6040803@supsi.ch>
	<AANLkTimQhfvbx72izkg9qxMFkC0xixTPQa6aQ4HF04Hq@mail.gmail.com>
	<4D657AFE.3010605@supsi.ch>
	<AANLkTikKtkwHATrSE7Ymf2n22Fj06kw9fpNwTr-8WyS1@mail.gmail.com>
	<4D658672.4000503@supsi.ch>
	<4D6681E1.5010905@cdf.toronto.edu>
	<AANLkTinkz2Aq+EDh10-98wYTrDU7+h4F3FOpk2Mu6nqd@mail.gmail.com>
	<4D66CE8A.90105@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D66CE8A.90105@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: Roberto Nunnari <roberto.nunnari@supsi.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

nice thanks !!!

2011/2/24 Iordan Iordanov <iordan@cdf.toronto.edu>:
> Hi Roberto (Spadim),
>
> I am attaching the two files necessary for this functionality. The fi=
rst one
> (gpt_id) is the script which given this example input:
>
> =C2=A0gpt_id sdb 1
>
> should give this example output:
>
> =C2=A0PARTITION_LABEL=3Ditest00-drive00-part00
>
> The second file is a udev configuration file which needs to be droppe=
d into
> /etc/udev/rules.d/. When a new device is attached, it runs gpt_id on =
its
> partitions, and if a GPT label is found, a link in /dev/disk/by-label
> magically appears to the partition in question.
>
> To create a GPT label and name a 100GB partition on /dev/sdb, one wou=
ld do
> something like this (WARNING, WARNING, WARNING THIS IS A DATA-DESTRUC=
TIVE
> PROCESS):
>
> parted /dev/sdb
> mklabel y gpt
> mkpart primary ext3 0 100GB
> name 1 itest00-drive00-part00
> print
> quit
>
> To trigger udevadm to rescan all the devices and remake all the symli=
nks,
> you can run:
>
> udevadm trigger
>
> The gpt_id and the udev rules file are home-brewed at our department.=
 Enjoy!
>
> Cheers,
> Iordan
>
> On 02/24/11 15:08, Roberto Spadim wrote:
>>
>> do you have the udev configuration for this (static)?
>>
>> 2011/2/24 Iordan Iordanov<iordan@cdf.toronto.edu>:
>>>
>>> Hi guys,
>>>
>>> I saw a bunch of discussion of devices changing names when hot-plug=
ged.
>>> If
>>> you get the device name right when you add it to the array first, a=
ll is
>>> good since the superblock is used to "discover" the device later.
>>>
>>> However, to make things easier/clearer, and to avoid errors, one ca=
n take
>>> a
>>> look at the set of directories:
>>>
>>> /dev/disk/by-id
>>> /dev/disk/by-path
>>> /dev/disk/by-uuid
>>> /dev/disk/by-label
>>>
>>> for a predictable, more static view of the drives. The symlinks in =
these
>>> directories are created by udev, and are simply links to the "real"
>>> device
>>> nodes /dev/sd{a-z}*. You can either just use these symlinks as a wa=
y of
>>> verifying that you are adding the right device, or add the device u=
sing
>>> the
>>> symlink.
>>>
>>> At our location, we even augmented udev to add links to labeled GPT
>>> partitions in /dev/disk/by-label, and now our drives/partitions loo=
k like
>>> this:
>>>
>>> iscsi00-drive00-part00 -> =C2=A0../../sda1
>>> iscsi00-drive01-part00 -> =C2=A0../../sdb1
>>> iscsi00-drive02-part00 -> =C2=A0../../sdc1
>>> iscsi00-drive03-part00 -> =C2=A0../../sdd1
>>> iscsi00-drive04-part00 -> =C2=A0../../sde1
>>>
>>> This way, we know exactly which bay contains exactly which drive, a=
nd it
>>> stays this way. If you guys want, I can share with you the changes =
to
>>> udev
>>> necessary and the script which extracts the GPT label and reports i=
t to
>>> udev
>>> for this magic to happen :). Please reply to this thread with a req=
uest
>>> if
>>> you think it may be useful to you.
>>>
>>> Cheers,
>>> Iordan
>>>
>>>
>>> On 02/23/11 17:13, Roberto Nunnari wrote:
>>>>
>>>> Roberto Spadim wrote:
>>>>>
>>>>> hum, maybe you are using mdadm.conf or autodetect, non autodetect
>>>>> should be something like this:
>>>>> i don=C2=B4t know the best solution, but it works ehhehe
>>>>>
>>>>> kernel /vmlinuz-2.6.9-89.31.1.ELsmp ro root=3D/dev/md0 rhgb
>>>>> quiet md=3D0,/dev/sda,/dev/sdb md=3D1,xxxx,yyyy.....
>>>>>
>>>>> or another md array...
>>>>>
>>>>> humm i readed the sata specification and removing isn=C2=B4t a pr=
oblem, at
>>>>> eletronic level the sata channel is only data, no power source, a=
ll
>>>>> channels are diferencial (like rs422 or rs485), i don=C2=B4t see =
anyproblem
>>>>> removing it. i tryed hot plug a revodrive (pciexpress ssd) and it
>>>>> don=C2=B4t work (reboot) hehehe, pci-express isn=C2=B4t hot plug =
=3DP, sata2 don=C2=B4t
>>>>> have problems, the main problem is a short circuit at power sourc=
e, if
>>>>> you remove with caution no problems =3D)
>>>>>
>>>>> i tried in some others distros and udev created a new device when=
 add
>>>>> a diferent disk for example, remove sdb, and add another disk cre=
ate
>>>>> sdc (not sdb), maybe with another udev configuration should work
>>>>
>>>> Ok. I'll keep all that in mind tomorrow.
>>>> Best regards.
>>>> Robi
>>>>
>>>>
>>>>>
>>>>>
>>>>> 2011/2/23 Roberto Nunnari<roberto.nunnari@supsi.ch>:
>>>>>>
>>>>>> Roberto Spadim wrote:
>>>>>>>
>>>>>>> i don=C2=B4t know how you setup your kernel (with or without ra=
id
>>>>>>
>>>>>> I use the official CentOS kernel with no modification and don't
>>>>>> know about raid autodetect, but:
>>>>>> # cat /boot/config-2.6.24-28-server |grep -i raid
>>>>>> CONFIG_BLK_DEV_3W_XXXX_RAID=3Dm
>>>>>> CONFIG_MD_RAID0=3Dm
>>>>>> CONFIG_MD_RAID1=3Dm
>>>>>> CONFIG_MD_RAID10=3Dm
>>>>>> CONFIG_MD_RAID456=3Dm
>>>>>> CONFIG_MD_RAID5_RESHAPE=3Dy
>>>>>> CONFIG_MEGARAID_LEGACY=3Dm
>>>>>> CONFIG_MEGARAID_MAILBOX=3Dm
>>>>>> CONFIG_MEGARAID_MM=3Dm
>>>>>> CONFIG_MEGARAID_NEWGEN=3Dy
>>>>>> CONFIG_MEGARAID_SAS=3Dm
>>>>>> CONFIG_RAID_ATTRS=3Dm
>>>>>> CONFIG_SCSI_AACRAID=3Dm
>>>>>>
>>>>>>
>>>>>>> autodetect?) do you use kernel command line to setup raid?
>>>>>>> autodetect?
>>>>>>
>>>>>> /dev/md0 in grub
>>>>>> I don't know if that means autodetect, but I guess so..
>>>>>>
>>>>>>
>>>>>>> here in my test machine i=C2=B4m using kernel command line (gru=
b), i don=C2=B4t
>>>>>>> have a server with hotplug bay, i open the case and remove the =
wire
>>>>>>> with my hands =3D) after reconecting it with another device ker=
enel
>>>>>>
>>>>>> Is it safe? Isn't it a blind bet to fry up the controller and/or=
 disk?
>>>>>>
>>>>>>
>>>>>>> recognize the new device reread the parititions etc etc and i c=
an add
>>>>>>> it to array again
>>>>>>> my grub is something like:
>>>>>>>
>>>>>>> md=3D0,/dev/sda,/dev/sdb .....
>>>>>>>
>>>>>>> internal meta data, raid1, i didn=C2=B4t like the autodetect (i=
t=C2=B4s good)
>>>>>>> but i prefer hardcoded kernel command line (it=C2=B4s not good =
with usb
>>>>>>> devices)
>>>>>>
>>>>>> the relevant part of my grub is:
>>>>>>
>>>>>> default=3D0
>>>>>> timeout=3D5
>>>>>> splashimage=3D(hd0,0)/grub/splash.xpm.gz
>>>>>> hiddenmenu
>>>>>> title CentOS (2.6.9-89.31.1.ELsmp)
>>>>>> root (hd0,0)
>>>>>> kernel /vmlinuz-2.6.9-89.31.1.ELsmp ro root=3D/dev/md0 rhgb quie=
t
>>>>>> initrd /initrd-2.6.9-89.31.1.ELsmp.img
>>>>>>
>>>>>> Best regards.
>>>>>> Robi
>>>>>>
>>>>>>
>>>>>>> 2011/2/23 Roberto Nunnari<roberto.nunnari@supsi.ch>:
>>>>>>>>
>>>>>>>> Roberto Spadim wrote:
>>>>>>>>>
>>>>>>>>> sata2 without hot plug?
>>>>>>>>
>>>>>>>> Hi Roberto.
>>>>>>>>
>>>>>>>> I mean that there is no hot-plug bay, with sliding rails etc..
>>>>>>>> The drives are connected to the mb using standard sata cables.
>>>>>>>>
>>>>>>>>
>>>>>>>>> check if your sda sdb sdc will change after removing it, it=E6=
=84=80
>>>>>>>>> depends
>>>>>>>>> on your udev or another /dev filesystem
>>>>>>>>
>>>>>>>> Ok, thank you.
>>>>>>>> That means that if I take care to check the above, and
>>>>>>>> the new drive will be sdb, then taking the steps indicated
>>>>>>>> in my original post will do the job?
>>>>>>>>
>>>>>>>> Best regards.
>>>>>>>> Robi
>>>>>>>>
>>>>>>>>
>>>>>>>>> 2011/2/23 Roberto Nunnari<roberto.nunnari@supsi.ch>:
>>>>>>>>>>
>>>>>>>>>> Hello.
>>>>>>>>>>
>>>>>>>>>> I have a linux box, with two 2TB sata HD in raid 1.
>>>>>>>>>>
>>>>>>>>>> Now, one disk is in failed state and it has no spares:
>>>>>>>>>> # cat /proc/mdstat
>>>>>>>>>> Personalities : [raid1]
>>>>>>>>>> md1 : active raid1 sdb4[2](F) sda4[0]
>>>>>>>>>> 1910200704 blocks [2/1] [U_]
>>>>>>>>>>
>>>>>>>>>> md0 : active raid1 sdb1[1] sda2[0]
>>>>>>>>>> 40957568 blocks [2/2] [UU]
>>>>>>>>>>
>>>>>>>>>> unused devices:<none>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> The drives are not hot-plug, so I need to shutdown the box.
>>>>>>>>>>
>>>>>>>>>> My plan is to:
>>>>>>>>>> # sfdisk -d /dev/sdb> =C2=A0sdb.sfdisk
>>>>>>>>>> # mdadm /dev/md1 -r /dev/sdb4
>>>>>>>>>> # mdadm /dev/md0 -r /dev/sdb1
>>>>>>>>>> # shutdown -h now
>>>>>>>>>>
>>>>>>>>>> replace the disk and boot (it should come back up, even with=
out
>>>>>>>>>> one
>>>>>>>>>> drive,
>>>>>>>>>> right?)
>>>>>>>>>>
>>>>>>>>>> # sfdisk /dev/sdb< =C2=A0sdb.sfdisk
>>>>>>>>>> # mdadm /dev/md1 -a /dev/sdb4
>>>>>>>>>> # mdadm /dev/md0 -a /dev/sdb1
>>>>>>>>>>
>>>>>>>>>> and the drives should start to resync, right?
>>>>>>>>>>
>>>>>>>>>> This is my first time I do such a thing, so please, correct =
me
>>>>>>>>>> if the above is not correct, or is not a best practice for
>>>>>>>>>> my configuration.
>>>>>>>>>>
>>>>>>>>>> My last backup of md1 is of mid november, so I need to be
>>>>>>>>>> pretty sure I will not lose my data (over 1TB).
>>>>>>>>>>
>>>>>>>>>> A bit abount my environment:
>>>>>>>>>> # mdadm --version
>>>>>>>>>> mdadm - v1.12.0 - 14 June 2005
>>>>>>>>>> # cat /etc/redhat-release
>>>>>>>>>> CentOS release 4.8 (Final)
>>>>>>>>>> # uname -rms
>>>>>>>>>> Linux 2.6.9-89.31.1.ELsmp i686
>>>>>>>>>>
>>>>>>>>>> Thank you very much and best regards.
>>>>>>>>>> Robi
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
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



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
