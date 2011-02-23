From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: failed drive in raid 1 array
Date: Wed, 23 Feb 2011 14:56:52 -0300
Message-ID: <AANLkTim+Sz9Hrpu0rPQt2r4-SgmGEt1svsrs26Ejrkoq@mail.gmail.com>
References: <4D653B57.1030203@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D653B57.1030203@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sata2 without hot plug?
check if your sda sdb sdc will change after removing it, it=B4s depends
on your udev or another /dev filesystem

2011/2/23 Roberto Nunnari <roberto.nunnari@supsi.ch>:
> Hello.
>
> I have a linux box, with two 2TB sata HD in raid 1.
>
> Now, one disk is in failed state and it has no spares:
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sdb4[2](F) sda4[0]
> =A0 =A0 =A01910200704 blocks [2/1] [U_]
>
> md0 : active raid1 sdb1[1] sda2[0]
> =A0 =A0 =A040957568 blocks [2/2] [UU]
>
> unused devices: <none>
>
>
> The drives are not hot-plug, so I need to shutdown the box.
>
> My plan is to:
> # sfdisk -d /dev/sdb > sdb.sfdisk
> # mdadm /dev/md1 -r /dev/sdb4
> # mdadm /dev/md0 -r /dev/sdb1
> # shutdown -h now
>
> replace the disk and boot (it should come back up, even without one d=
rive,
> right?)
>
> # sfdisk /dev/sdb < sdb.sfdisk
> # mdadm /dev/md1 -a /dev/sdb4
> # mdadm /dev/md0 -a /dev/sdb1
>
> and the drives should start to resync, right?
>
> This is my first time I do such a thing, so please, correct me
> if the above is not correct, or is not a best practice for
> my configuration.
>
> My last backup of md1 is of mid november, so I need to be
> pretty sure I will not lose my data (over 1TB).
>
> A bit abount my environment:
> # mdadm --version
> mdadm - v1.12.0 - 14 June 2005
> # cat /etc/redhat-release
> CentOS release 4.8 (Final)
> # uname -rms
> Linux 2.6.9-89.31.1.ELsmp i686
>
> Thank you very much and best regards.
> Robi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
