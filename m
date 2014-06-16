From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Sun, 15 Jun 2014 22:23:00 -0400
Message-ID: <539E5504.1080809@turmel.org>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TnVubyBNYWdhbGjDo2Vz?= <nunomagalhaes@eu.ipp.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/14/2014 05:01 PM, Nuno Magalh=C3=A3es wrote:
> Hi,
>=20
> Sorry if this is the wrong list. Most of the stuff out there seems
> outdated, and i have some specific doubts.
>=20
> I'm trying to decide how to best create a RAID array and what
> configuration to use. This is a desktop system, nothing
> mission-critical, but i'd like it to be reasonably tailored to the
> hardware and intended usage, and have questions about default values.
>=20
> Hardware:
>     1x Toshiba DT01ACA100 - 32MB bus, 931.0 GiB (1 TB; 1000204886016 =
bytes)
>     2x Seagate ST1000DM0003 - 64MB bus, 931.0 GiB (1 TB; 100020488601=
6 bytes)
> and
>     1x Maxtor 6G160E0 - 8MB bus, 149.1 GiB (160 GB; 160041885696 byte=
s)

Before going any further, check the TLER/ERC support for these drives.
(The Seagate xxxxxDM003 is ringing warning bells for me.)  The output o=
f
"smartctl -l scterc /dev/sdX" for each one will do.  If you get anythin=
g
other than "7.0 seconds" or similar, you'll need special boot-time
scripting.  If you get "not supported", I wouldn't even consider puttin=
g
the drive into any raid array.

Search this list's archives for details on "timeout mismatch", "scterc"=
,
and the consequences of ignoring this.

If you do have good error recovery timeouts, continue with Stan's advic=
e.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
