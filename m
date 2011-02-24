From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: failed drive in raid 1 array
Date: Thu, 24 Feb 2011 19:00:59 -0300
Message-ID: <AANLkTikPk=ej0++J8uud_bTPoKUJPrA7tC4HgSVroqkR@mail.gmail.com>
References: <4D653B57.1030203@supsi.ch>
	<AANLkTim+Sz9Hrpu0rPQt2r4-SgmGEt1svsrs26Ejrkoq@mail.gmail.com>
	<4D654FD8.1070206@alice.nl>
	<4D657A45.7020306@supsi.ch>
	<4D66D2FF.8090005@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D66D2FF.8090005@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: Albert Pauw <albert.pauw@alice.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=3D) nice hehe

2011/2/24 Roberto Nunnari <roberto.nunnari@supsi.ch>:
> Roberto Nunnari wrote:
>>
>> Albert Pauw wrote:
>>>
>>> =C2=A0On 02/23/11 06:56 PM, Roberto Spadim wrote:
>>>>
>>>> sata2 without hot plug?
>>>> check if your sda sdb sdc will change after removing it, it=E6=84=80=
 depends
>>>> on your udev or another /dev filesystem
>>>>
>>>> 2011/2/23 Roberto Nunnari<roberto.nunnari@supsi.ch>:
>>>>>
>>>>> Hello.
>>>>>
>>>>> I have a linux box, with two 2TB sata HD in raid 1.
>>>>>
>>>>> Now, one disk is in failed state and it has no spares:
>>>>> # cat /proc/mdstat
>>>>> Personalities : [raid1]
>>>>> md1 : active raid1 sdb4[2](F) sda4[0]
>>>>> =C2=A0 =C2=A0 =C2=A01910200704 blocks [2/1] [U_]
>>>>>
>>>>> md0 : active raid1 sdb1[1] sda2[0]
>>>>> =C2=A0 =C2=A0 =C2=A040957568 blocks [2/2] [UU]
>>>>>
>>>>> unused devices:<none>
>>>>>
>>>>>
>>>>> The drives are not hot-plug, so I need to shutdown the box.
>>>>>
>>>>> My plan is to:
>>>>> # sfdisk -d /dev/sdb> =C2=A0sdb.sfdisk
>>>>> # mdadm /dev/md1 -r /dev/sdb4
>>>
>>> -> removing should be ok, as the partition has failed in md1
>>
>> ok.
>>
>>
>>>>> # mdadm /dev/md0 -r /dev/sdb1
>>>
>>> -> In this case, sdb1 hasn't failed according to the output of
>>> /proc/mdstat, so you should fail it otherwise you can't remove it:
>>> mdadm /dev/md0 -f /dev/sdb1
>>> mdadm /dev/md0 -r /dev/sdb1
>>
>> good to know! Thank you.
>>
>>
>>>
>>>>> # shutdown -h now
>>>>>
>>>>> replace the disk and boot (it should come back up, even without o=
ne
>>>>> drive,
>>>>> right?)
>>>>>
>>>>> # sfdisk /dev/sdb< =C2=A0sdb.sfdisk
>>>>> # mdadm /dev/md1 -a /dev/sdb4
>>>>> # mdadm /dev/md0 -a /dev/sdb1
>>>>>
>>>>> and the drives should start to resync, right?
>>>>>
>>>>> This is my first time I do such a thing, so please, correct me
>>>>> if the above is not correct, or is not a best practice for
>>>>> my configuration.
>>>>>
>>>>> My last backup of md1 is of mid november, so I need to be
>>>>> pretty sure I will not lose my data (over 1TB).
>>>>>
>>>>> A bit abount my environment:
>>>>> # mdadm --version
>>>>> mdadm - v1.12.0 - 14 June 2005
>>>>> # cat /etc/redhat-release
>>>>> CentOS release 4.8 (Final)
>>>>> # uname -rms
>>>>> Linux 2.6.9-89.31.1.ELsmp i686
>>>
>>> What about sdb2 an sdb3, are they in use as normal mountpoints, or =
swap.
>>> Then these should be commented out in /etc/fstab
>>> before you change the disk.
>>
>> Yes. They're normal mount point, so I'll have to
>> comment them out before rebooting, especially the swap partition.
>> Thank you for pointing that out!
>>
>> Best regards.
>> Robi
>
> Thank you very much Roberto and Albert.
> I replaced the defective drive.
> md0 was rebuilt almost immediatly, md1 is still rebuilding
> but already completed 77%.
>
> Great linux-raid md!
> Best regards.
> Robi
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
