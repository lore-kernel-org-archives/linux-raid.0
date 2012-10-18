From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Thu, 18 Oct 2012 13:17:21 +0100
Message-ID: <CADNH=7FKd9LuUzwnQ7W4Evo_PzGRjY8nK6u1R3AMvzq17FMe=w@mail.gmail.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
	<C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com>
	<CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com>
	<235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com>
	<CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com>
	<D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com>
	<CADNH=7G0d+7-Y5fwimV6U_u8ep1BAWzFP0jQJOm4RmAkk0urXQ@mail.gmail.com>
	<507FEE52.50103@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <507FEE52.50103@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18 October 2012 12:56, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 10/17/2012 2:03 PM, Mathias Bur=C3=A9n wrote:
>
>> There are no CRC errors so I doubt the cable is at fault. In any way=
,
>> I've RMA'd drives for less, and an RMA is underway for this drive.
>> Just need to wait for the reshape to finish so I can get in the
>> server. Btw, with a few holes drilled this bad boy holds 7 3.5" HDDs
>> no problem: http://www.antec.com/productPSU.php?id=3D30&pid=3D3
>
> It would seem you didn't mod the airflow of the case along with the
> increased drive count.  The NSK1380 has really poor airflow to begin
> with: a single PSU mounted 120mm super low RPM fan.  Antec is current=
ly
> shipping the NSK1380 with an additional PCI slot centrifugal fan to h=
elp
> overcome the limitations of the native design.
>
> You bought crap drives, WD20EARS, then improperly modded a case to ho=
use
> more than twice the design limit of HDDs.
>
> I'd say you stacked the deck against yourself here Mathias.
>
> --
> Stan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Now now, the setup is working like a charm. Disk failures happen all
the time. There's an additional 120mm at the bottom, blowing up
towards the 7 HDDs. I bought "crap" drives because they were cheap.

In the 2 years a total of 3 drives have failed, but the array has
never failed. I'm very pleased with it (HTPC, with an ION board and 4x
SATA PCI-E controller for E10)

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
