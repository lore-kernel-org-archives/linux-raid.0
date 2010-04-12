From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: raid10,f2 Add a Controller: Which drives to move?
Date: Mon, 12 Apr 2010 08:07:03 +0200
Message-ID: <4BC2B887.6020403@stud.tu-ilmenau.de>
References: <loom.20100411T185315-118@post.gmane.org> <4BC29670.6020504@unart.cz>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BC29670.6020504@unart.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 12.04.2010 05:41, schrieb Tom=E1=A8 Dul=EDk:
> Hi,
> I am not sure if I understand your question, but I suppose you will h=
it
> the problem of udev naming of your disks, and if your disks are
> hotswap-able, then also the problem of hotswap, which is currently
> discussed here in this mailing list.
>=20
> I have spent too much time trying to solve both these problems with t=
he
> current linux SW RAID (mdadm v. 2.6) and here is the first part of my
> solution:
> http://wiki.debian.org/Persistent_disk_names

I cannot quite understand your problem.  As every part of the array
contains it's own metadata, it doesn't matter to md which /dev/sdX a
drive is.  It might matter a bit for boot-time assembly, but actually
that's what UUIDs are for.

>=20
> The page is still not really  finished, I am still playing with my
> server so the documentation must wait.
>=20
>=20
> Michael McCallister napsal(a):
>=20
>> So with four drives sda, sdb, sdc, and sdd and two controllers C1 an=
d
>> C2, should
>> I go with
>>
>>     C1: sda, sdb
>>     C2: sdc, sdd
>>
>> or
>>
>>     C1: sda, sdc
>>     C2: sdb, sdd
>>
>> or some other configuration?
>>  =20

But I understand yours, Michael.  You would like to put those
RAID0-pieces of your RAID10 each on a single controller.  I believe one
must find out what "NEAR" and "FAR" is.
I'd understand it as: "NEAR" is the closer disk - yeah.  Closer in the
array-tree, or it's logical base-LBA is closer?  Neil, could you please
clarify which is which?

>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

All the best,
Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
