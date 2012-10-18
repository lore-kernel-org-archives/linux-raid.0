From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Thu, 18 Oct 2012 15:58:20 -0500
Message-ID: <50806D6C.2050103@hardwarefreak.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com> <C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com> <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com> <235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com> <CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com> <D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com> <CADNH=7G0d+7-Y5fwimV6U_u8ep1BAWzFP0jQJOm4RmAkk0urXQ@mail.gmail.com> <507FEE52.50103@hardwarefreak.com> <CADNH=7FKd9LuUzwnQ7W4Evo_PzGRjY8nK6u1R3AMvzq17FMe=w@mail.gmail.com> <CADNH=7HEBDGrN+2SpLB30mAN0nW0ky=KGwCgnxeY4OSejFr1yw@mail.gmail.com> <3286E6F7-0982-4A87-A83C-5D78B22EE437@colorremedies.com> <CADNH=7HqAweunG0wBG5-Ut5ECxt0zpvQaoFS=FhW=g4Sj9Rmug@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HqAweunG0wBG5-Ut5ECxt0zpvQaoFS=FhW=g4Sj9Rmug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Lack of a List-Post header got me again...sorry for the dup Mathias.

On 10/18/2012 3:17 PM, Mathias Bur=E9n wrote:

> If I had them all as single volumes I'd have to use mhddfs
> or something to make it look like 1 logical volume. Or even use some
> kind of LVM perhaps.

Or md/RAID --linear.  Given the list you're posting to I'm surprised yo=
u
forgot this option.

But running without redundancy of any kind will cause more trouble than
you currently have.

Last words of advice:

In the future, spend a little more per drive and get units that will
live longer.  Also, mounting a 120mm fan in the bottom of that Antec
cube chassis blowing "up" on the drives simply circulates the hot air
already inside the chassis.  It does not increase CFM of cool air intak=
e
nor exhaust of hot air.  So T_case is pretty much the same as before yo=
u
put the 2nd 120mm fan in there.  And T_case is the temp that determines
drive life.

"silent chassis" and RAID are mutually exclusive.  You'll rarely, if
ever, properly cool multiple HDDs, of any persuasion, in a "silent"
chassis.  To make it silent the fans must turn at very low RPM, thus
yielding very low CFM, thus yielding high device temps.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
