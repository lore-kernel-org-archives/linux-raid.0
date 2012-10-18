From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Thu, 18 Oct 2012 21:17:38 +0100
Message-ID: <CADNH=7HqAweunG0wBG5-Ut5ECxt0zpvQaoFS=FhW=g4Sj9Rmug@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3286E6F7-0982-4A87-A83C-5D78B22EE437@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18 October 2012 20:54, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 18, 2012, at 11:11 AM, Mathias Bur=C3=A9n wrote:
>
>> Just to follow up, the reshape succeeded and I'll now shutdown and R=
MA
>> /dev/sde. Thanks all for the answers.
>
> Yeah but two days later and you still are critically degraded without=
 either failed disk replaced and rebuilding. You're one tiny problem aw=
ay from that whole array collapsing and you're worried about this one f=
ussy disk? I don't understand your delay in immediately getting a repla=
cement drive in this array unless you really don't care about the data =
at all, in which case why have a RAID6?
>
> Sure, what are the odds of a 3rd drive dying=E2=80=A6 *shrug* Seems l=
ike an unwise risk tempting fate like this.
>
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

There's no more dying drives in the array, 2 out of 7 died, they are
on RMA soon. (when I can get to the post office).

I did see 5 pending sectors on 1 HDD after the reshape finished
though. I don't care much about the data (it's not critical), RAID6 is
just so I can have one large volume, some speed increase and a bit of
redundancy. If I had them all as single volumes I'd have to use mhddfs
or something to make it look like 1 logical volume. Or even use some
kind of LVM perhaps.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
