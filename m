From: Carabetta Giulio <g.carabetta@abi.it>
Subject: Offtopic: on case (was: R: RAID6 reshape, 2 disk failures)
Date: Fri, 19 Oct 2012 16:32:42 +0200
Message-ID: <4FDB990B62C2D849BA8EADBDD1C5928E1372362B18@CCRMBX.abiad.abi.lan>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
 <C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com>
 <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com>
 <235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com>
 <CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com>
 <D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com>
 <CADNH=7G0d+7-Y5fwimV6U_u8ep1BAWzFP0jQJOm4RmAkk0urXQ@mail.gmail.com>
 <507FEE52.50103@hardwarefreak.com>
 <CADNH=7FKd9LuUzwnQ7W4Evo_PzGRjY8nK6u1R3AMvzq17FMe=w@mail.gmail.com>
 <CADNH=7HEBDGrN+2SpLB30mAN0nW0ky=KGwCgnxeY4OSejFr1yw@mail.gmail.com>
 <3286E6F7-0982-4A87-A83C-5D78B22EE437@colorremedies.com>
 <CADNH=7HqAweunG0wBG5-Ut5ECxt0zpvQaoFS=FhW=g4Sj9Rmug@mail.gmail.com>
 <50806D6C.2050103@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50806D6C.2050103@hardwarefreak.com>
Content-Language: it-IT
Sender: linux-raid-owner@vger.kernel.org
To: "'stan@hardwarefreak.com'" <stan@hardwarefreak.com>, =?iso-8859-1?Q?=27Mathias_Bur=E9n=27?= <mathias.buren@gmail.com>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry for the OT, but...

> Lack of a List-Post header got me again...sorry for the dup Mathias.
>
> On 10/18/2012 3:17 PM, Mathias Bur=E9n wrote:
>=20
> > If I had them all as single volumes I'd have to use mhddfs or=20
> > something to make it look like 1 logical volume. Or even use some k=
ind=20
> > of LVM perhaps.
>=20
> Or md/RAID --linear.  Given the list you're posting to I'm surprised =
you forgot this option.
>=20
> But running without redundancy of any kind will cause more trouble th=
an you currently have.
>=20
> Last words of advice:
>=20
> In the future, spend a little more per drive and get units that will =
live longer.  Also, mounting a 120mm fan in the bottom of that Antec > =
cube chassis blowing "up" on the drives simply circulates the hot air a=
lready inside the chassis.  It does not increase CFM of cool air=20
> intake nor exhaust of hot air.  So T_case is pretty much the same as =
before you put the 2nd 120mm fan in there.  And T_case is the temp=20
> that determines drive life.
>=20
> "silent chassis" and RAID are mutually exclusive.  You'll rarely, if =
ever, properly cool multiple HDDs, of any persuasion, in a "silent"
> chassis.  To make it silent the fans must turn at very low RPM, thus =
yielding very low CFM, thus yielding high device temps.

You are right, I know that very well...=20
Also I'm looking for a compromise between temperature and noise: what d=
o you think about this case?
http://www.lian-li.com/v2/en/product/product06.php?pr_index=3D480&cl_in=
dex=3D1&sc_index=3D26&ss_index=3D67&g=3Df


>=20
> --
> Stan
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in the body of a message to majordomo@vger.kernel.org More majordomo >=
 info at  http://vger.kernel.org/majordomo-info.html

Giulio Carabetta--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
