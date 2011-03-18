From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: MD without LVM : should I reinstall ?
Date: Fri, 18 Mar 2011 21:12:25 +0000
Message-ID: <AANLkTinxz=CJ6VReNfSdQ=QXT8+VBEwCK6OriOB34ah=@mail.gmail.com>
References: <201103172232.28515.thocar@thocar.org>
	<AANLkTinG1RSiXZZdN+Fc__AJ14hAAua8gxySbbM_C3gZ@mail.gmail.com>
	<201103182159.40249.thocar@thocar.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103182159.40249.thocar@thocar.org>
Sender: linux-raid-owner@vger.kernel.org
To: thocar@thocar.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18 March 2011 20:59, Thomas Carri=C3=A9 <thocar@thocar.org> wrote:
> On Jueves 17 Marzo 2011 23:33:02 usted escribi=C3=B3:
>> On 17 March 2011 21:32, Thomas Carri=C3=A9 <thocar@thocar.org> wrote=
:
>> > Hello,
>> >
>> > My hosting provider has a setup for me a Debian server using md RA=
ID1 but
>> > it does not use LVM, should I consider re-install with LVM ?
>> >
>> > # mount | grep ' / '
>> > /dev/md0 on / type ext3 (rw,errors=3Dremount-ro)
>> > # fdisk -l
>> >
>> > Disk /dev/sdb: 250.1 GB, 250059350016 bytes
>> > ...
>> > =C2=A0 Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> > /dev/sdb1 =C2=A0 * =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=
=A0 =C2=A0 30155 =C2=A0 242220006 =C2=A0 fd =C2=A0Linux raid
>> > autodetect /dev/sdb2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 30156 =C2=A0=
 =C2=A0 =C2=A0 30401 =C2=A0 =C2=A0 1975995 =C2=A0 =C2=A05
>> > =C2=A0Extended /dev/sdb5 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 30156 =
=C2=A0 =C2=A0 =C2=A0 30401 =C2=A0 =C2=A0 1975963+ =C2=A082 =C2=A0Linux
>> > swap / Solaris
>> >
>> > Disk /dev/sda: 250.1 GB, 250059350016 bytes
>> > ...
>> > =C2=A0 Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> > /dev/sda1 =C2=A0 * =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=
=A0 =C2=A0 30155 =C2=A0 242220006 =C2=A0 fd =C2=A0Linux raid
>> > autodetect /dev/sda2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 30156 =C2=A0=
 =C2=A0 =C2=A0 30401 =C2=A0 =C2=A0 1975995 =C2=A0 =C2=A05
>> > =C2=A0Extended /dev/sda5 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 30156 =
=C2=A0 =C2=A0 =C2=A0 30401 =C2=A0 =C2=A0 1975963+ =C2=A082 =C2=A0Linux
>> > swap / Solaris
>> >
>> > Disk /dev/md0: 248.0 GB, 248033181696 bytes
>> > ...
>> > Disk /dev/md0 doesn't contain a valid partition table
>> >
>> > Thanks for your feedback
>> > --
>> > Thomas Carri=C3=A9
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>>
>> Of course not. If you wanted LVM you'd switch to it. If you don't kn=
ow
>> if you want it, then obviously you don't need it.
>
> Hello,
>
> Have a look at the command output : "Disk /dev/md0 doesn't contain a =
valid
> partition table"
>
> Is it safe to ignore this warning ?
>
>>
>> Jesus.
>>
>> // M
>
> --
> Thomas Carri=C3=A9
>

Sorry for the rude response,

AFAIK you'll see that "warning" if you use LVM (I see it in my setup),
as LVM isn't a file system per se.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
