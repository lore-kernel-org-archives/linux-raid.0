From: Du <eduardo@minicom.com.br>
Subject: Re: Raid and LVM and LILO
Date: Tue, 18 Jul 2006 09:52:59 -0300
Message-ID: <44BCD9AB.1090205@minicom.com.br>
References: <44BC21B6.1080507@minicom.com.br> <44BCCDCF.9070707@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44BCCDCF.9070707@waldoware.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Waldo wrote:
> Hi Du,
>
> Did you create a /boot partition?  /boot cannot be on LVM (AFAIK), an=
d=20
> can be a regular partition or raid1.  HTH.
The second thing I tried was that. I made a 200 MB /dev/md0 to be the=20
/boot partition and the rest to be /dev/md1 where the system will be=20
under LVM. But LILO says be that I dont have an active partition. I set=
=20
the /dev/md0 to be bootable, and set the 2 "Raid Linux Autodetect"=20
partitions that makes /dev/md0 bootable too. But LILO never installs...

>
> Paul
>
> Du wrote:
>> Hi, I was/am trying to install Debian Sarge r2 with 2 Sata HD's=20
>> working on Raid 1 via Software and in this newly MD device, I put=20
>> LVM. All works fine and the debian installs well, but when the LILO=20
>> try to install, it says me that I dont have an active partition and=20
>> no matter what I do, it doesnt installs....
>>
>> Does anybody knows what is happening?
>>
>> Is it a bad idea work with Raid via software and LVM???
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> E-mail classificado pelo Identificador de Spam Inteligente Terra.
> Para alterar a categoria classificada, visite
> http://mail.terra.com.br/protected_email/imail/imail.cgi?+_u=3Dminico=
m024&_l=3D1,1153224157.733357.13705.tulear.hst.terra.com.br,3286,Des15,=
Des15=20
>
>
> Esta mensagem foi verificada pelo E-mail Protegido Terra.
> Scan engine: McAfee VirusScan / Atualizado em 17/07/2006 / Vers=E3o:=20
> 4.4.00/4808
> Proteja o seu e-mail Terra: http://mail.terra.com.br/
>
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
