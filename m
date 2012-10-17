From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Wed, 17 Oct 2012 20:03:44 +0100
Message-ID: <CADNH=7G0d+7-Y5fwimV6U_u8ep1BAWzFP0jQJOm4RmAkk0urXQ@mail.gmail.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
	<C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com>
	<CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com>
	<235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com>
	<CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com>
	<D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17 October 2012 19:46, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 17, 2012, at 10:27 AM, Mathias Bur=C3=A9n wrote:
>
>> [419246.582409] end_request: I/O error, dev sde, sector 2343892776
>> [419246.582492] md/raid:md0: read error not correctable (sector
>> 2343890728 on sde1).
>> [419246.582502] md/raid:md0: read error not correctable (sector
>> 2343890736 on sde1).
>> [419246.582511] md/raid:md0: read error not correctable (sector
>> 2343890744 on sde1).
>> [419246.582519] md/raid:md0: read error not correctable (sector
>> 2343890752 on sde1).
>> [419246.582527] md/raid:md0: read error not correctable (sector
>> 2343890760 on sde1).
>> [419246.582535] md/raid:md0: read error not correctable (sector
>> 2343890768 on sde1).
>> [419246.582543] md/raid:md0: read error not correctable (sector
>> 2343890776 on sde1).
>> [419246.582552] md/raid:md0: read error not correctable (sector
>> 2343890784 on sde1).
>> [419246.582560] md/raid:md0: read error not correctable (sector
>> 2343890792 on sde1).
>> [419246.582568] md/raid:md0: read error not correctable (sector
>
>
> ...
>>
>> You can see the first start of the reshape, then sde started freakin=
g out.
>
> A lot more than just 5 sectors. I'd replace the drive and the cable. =
If it's under warranty, have it replaced. If not, maybe ata secure eras=
e it, extended offline smart test, and use it down the road for somethi=
ng not so important if it passes without further problems.

There are no CRC errors so I doubt the cable is at fault. In any way,
I've RMA'd drives for less, and an RMA is underway for this drive.
Just need to wait for the reshape to finish so I can get in the
server. Btw, with a few holes drilled this bad boy holds 7 3.5" HDDs
no problem: http://www.antec.com/productPSU.php?id=3D30&pid=3D3

>
> So basically, replace the dead sda drive ASAP so it can start rebuild=
ing.
>

Hm where do you get sda from? sda is the OS disk, an old SSD. (it
currently holds the reshape backup file)

> I'd consider marking sde faulty so that it's neither being reshaped o=
r rebuilt and then replace it once the new sda is rebuilt. You can prob=
ably replace them both at the same time and have them both rebuilding; =
but I'm being a little conservative on how many changes you make until =
you get yourself back to some level of redundancy.
>
>
> Chris Murphy--

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
