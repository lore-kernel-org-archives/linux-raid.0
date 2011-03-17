From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: MD without LVM : should I reinstall ?
Date: Thu, 17 Mar 2011 18:55:47 -0300
Message-ID: <AANLkTin61NPGMnM5hb+pi+Gyohwxgk4ndfnxgHsD_cWQ@mail.gmail.com>
References: <201103172236.46540.thocar@thocar.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103172236.46540.thocar@thocar.org>
Sender: linux-raid-owner@vger.kernel.org
To: thocar@thocar.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maybe, you will use snapshot? ext3 don=B4t have snapshot, will you use =
lvm?

2011/3/17 Thomas Carri=E9 <thocar@thocar.org>
>
> Hello,
>
> My hosting provider has a setup for me a Debian server using md RAID1=
 but it
> does not use LVM, should I consider re-install with LVM ?
>
> # mount | grep ' / '
> /dev/md0 on / type ext3 (rw,errors=3Dremount-ro)
> # fdisk -l
>
> Disk /dev/sdb: 250.1 GB, 250059350016 bytes
> ...
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sdb1 =A0 * =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 30155 =A0 242220006=
 =A0 fd =A0Linux raid autodetect
> /dev/sdb2 =A0 =A0 =A0 =A0 =A0 30156 =A0 =A0 =A0 30401 =A0 =A0 1975995=
 =A0 =A05 =A0Extended
> /dev/sdb5 =A0 =A0 =A0 =A0 =A0 30156 =A0 =A0 =A0 30401 =A0 =A0 1975963=
+ =A082 =A0Linux swap / Solaris
>
> Disk /dev/sda: 250.1 GB, 250059350016 bytes
> ...
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sda1 =A0 * =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 30155 =A0 242220006=
 =A0 fd =A0Linux raid autodetect
> /dev/sda2 =A0 =A0 =A0 =A0 =A0 30156 =A0 =A0 =A0 30401 =A0 =A0 1975995=
 =A0 =A05 =A0Extended
> /dev/sda5 =A0 =A0 =A0 =A0 =A0 30156 =A0 =A0 =A0 30401 =A0 =A0 1975963=
+ =A082 =A0Linux swap / Solaris
>
> Disk /dev/md0: 248.0 GB, 248033181696 bytes
> ...
> Disk /dev/md0 doesn't contain a valid partition table
>
> Thanks for your feedback
> --
> Thomas Carri=E9
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
