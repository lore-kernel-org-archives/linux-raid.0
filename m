From: Jean-Baptiste Joret <JORET@de.ibm.com>
Subject: Re: Need some information and help on mdadm in order to support it on IBM z
 Systems
Date: Mon, 14 Apr 2008 13:05:43 +0200
Message-ID: <OF70B5DB7B.09FE2CC6-ONC125742B.0032A67D-C125742B.003CF42B@de.ibm.com>
References: <OF9FBFD1B1.E511C96F-ONC1257428.004472D1-C1257428.004493A0@de.ibm.com> <47FF7831.20707@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47FF7831.20707@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bill,

I have created the array with "mdadm --create /dev/md0 --level=3D1=20
--raid-devices=3D2 /dev/dasd[ef]1 --metadata=3D1.2 --bitmap=3Dinternal"=
 using as=20
you can see version 1.2 of the Metatata format. The Kernel ist the SuSE=
=20
standard kernel 2.6.16.60-0.9-default on s390x (SLES 10 SP2 RC1). I hav=
e=20
this issue with RC2 too.

What I would like to have a more documentation about the Metadata and h=
ow=20
they are used if you have or know someone who can provide this.

Thank you in advance.

Best regards / Mit freundlichen Gruessen / Cordialement / Cordiali Salu=
ti=20

Jean-Baptiste Joret - Linux on System Z=20
Phone: +49 7031 16-3278 / ITN: 39203278 - eMail: joret@de.ibm.com=20

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrung: Herbert Kircher
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294



=46rom:
Bill Davidsen <davidsen@tmr.com>
To:
Jean-Baptiste Joret/Germany/IBM@IBMDE
Cc:
linux-raid@vger.kernel.org
Date:
11.04.2008 16:35
Subject:
Re: Need some information and help on mdadm in order to support it on I=
BM=20
z Systems



Jean-Baptiste Joret wrote:
> Hello,
>
> I am trying to obtain information such as design document or anything=
=20
that=20
> would describe the content of the metadata. I am evaluating the solut=
ion=20

> to determinate whether it is entreprise ready for use as a mirror=20
solution=20
> and if we can support it at IBM.=20
>
> Also I am currently having quite a show stopper issue, where help wou=
ld=20
be=20
> appreciated. I have a RAID1 with 2 Harddisks, when I remove one hardi=
sk=20
(I=20
> put the chpids offline which is equivalent to telling the system that=
=20
the=20
> drive is currently not available), the missing disk is marked as "fau=
lty=20

> spare" when calling mdadm -D /dev/md0.=20
>
> /dev/md0:
>         Version : 01.02.03
>   Creation Time : Fri Apr 11 11:11:59 2008
>      Raid Level : raid1
>      Array Size : 2403972 (2.29 GiB 2.46 GB)
>   Used Dev Size : 2403972 (2.29 GiB 2.46 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Fri Apr 11 11:23:04 2008
>           State : active, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 1
>   Spare Devices : 0
>
>            Name : 0
>            UUID : 9a0a6e30:4b8bbe7f:bc0cad81:9fd46804
>          Events : 8
>
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1      94       21        1      active sync   /dev/dasdf1
>
>        0      94       17        -      faulty spare   /dev/dasde1
>
> When I put the disk back online it is not automatically reinserted in=
to=20
> the array. The only thing that I have tried that worked was to do a h=
ot=20
> remove followed by a hot add (mdadm /dev/md0 -r /dev/dasde1 and then=20
mdadm=20
> /dev/md0 -a /dev/dasde1). Is that the correct way or is there any opt=
ion=20

> to tell the disk is back an clean ? I don't like my solution verymuch=
 as=20

> somtimes I get an error saying the superblock cannot be written.
>
> Thank you very much for any help you can provide.
>
>=20
Start by detailing the versions of the kernel, mdadm, which superblock=20
you use, and your bitmap configuration (or lack of it).

> Best regards / Mit freundlichen Gruessen / Cordialement / Cordiali=20
Saluti=20
>
> Jean-Baptiste Joret - Linux on System Z=20
> Phone: +49 7031 16-3278 / ITN: 39203278 - eMail: joret@de.ibm.com=20
>
> IBM Deutschland Research & Development GmbH
> Vorsitzender des Aufsichtsrats: Martin Jetter
> Gesch=E4ftsf=FChrung: Herbert Kircher
> Sitz der Gesellschaft: B=F6blingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>=20


--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20






--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
