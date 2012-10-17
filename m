From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Wed, 17 Oct 2012 12:46:19 -0600
Message-ID: <D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com> <C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com> <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com> <235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com> <CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 17, 2012, at 10:27 AM, Mathias Bur=E9n wrote:

> [419246.582409] end_request: I/O error, dev sde, sector 2343892776
> [419246.582492] md/raid:md0: read error not correctable (sector
> 2343890728 on sde1).
> [419246.582502] md/raid:md0: read error not correctable (sector
> 2343890736 on sde1).
> [419246.582511] md/raid:md0: read error not correctable (sector
> 2343890744 on sde1).
> [419246.582519] md/raid:md0: read error not correctable (sector
> 2343890752 on sde1).
> [419246.582527] md/raid:md0: read error not correctable (sector
> 2343890760 on sde1).
> [419246.582535] md/raid:md0: read error not correctable (sector
> 2343890768 on sde1).
> [419246.582543] md/raid:md0: read error not correctable (sector
> 2343890776 on sde1).
> [419246.582552] md/raid:md0: read error not correctable (sector
> 2343890784 on sde1).
> [419246.582560] md/raid:md0: read error not correctable (sector
> 2343890792 on sde1).
> [419246.582568] md/raid:md0: read error not correctable (sector


=2E..
>=20
> You can see the first start of the reshape, then sde started freaking=
 out.

A lot more than just 5 sectors. I'd replace the drive and the cable. If=
 it's under warranty, have it replaced. If not, maybe ata secure erase =
it, extended offline smart test, and use it down the road for something=
 not so important if it passes without further problems.

So basically, replace the dead sda drive ASAP so it can start rebuildin=
g.

I'd consider marking sde faulty so that it's neither being reshaped or =
rebuilt and then replace it once the new sda is rebuilt. You can probab=
ly replace them both at the same time and have them both rebuilding; bu=
t I'm being a little conservative on how many changes you make until yo=
u get yourself back to some level of redundancy.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
