From: Dieter Stueken <stueken@conterra.de>
Subject: Re: Spares and partitioning huge disks
Date: Fri, 14 Jan 2005 18:29:44 +0100
Message-ID: <41E80188.60601@conterra.de>
References: <crmt7e$8d6$1@sea.gmane.org> <200501092226.25910.maarten@ultratux.net> <20050109222900.GA12793@janus> <200501100016.58847.maarten@ultratux.net> <20050110081526.GA15920@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050110081526.GA15920@janus>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46rank van Maarseveen wrote:
> On Mon, Jan 10, 2005 at 12:16:58AM +0100, maarten wrote:
>>You cut out my entire idea about leaving the 'failed' disk around to=20
>>eventually being able to compensate a further block error on another =
media. =20
>>Why ?  It would _solve_ your problem, wouldn't it ?
>=20
> I did not intend to cut it out but simplified the situation a bit: if
> you have all the RAID5 disks even with a bunch of errors spread out o=
ver
> all of them then yes, you basically still have the data.  Nothing is
> lost provided there's no double fault and disks are not dead yet. But
> there are not many technical people I would trust for recovering from
> this situation. And I wouldn't trust myself without a significant
> coffee intake either :)

I think read errors are to be handled very differently compared to disk
failures. In particular the affected disk should not be kicked out
incautious. If done so, you waste the real power of the RAID5 system
immediately! As long, as any other part of the disk can still be read,
this data must be preserved by all means. As long as only parts of a di=
sk
(even of different disks) can't be read, it is not a fatal problem, as =
long
as the data can still be read from an other disk of the array. There is=
 no
reason to kill any disk in advance.

What I'm missing is some improved concept of replacing a disk:
Kicking off some disk at first and starting to resync to a spare
disk thereafter is a very dangerous approach. Instead some "presync"
should be possible: After a decision to replace some disk, the new
(spare) disk should be prepared in advance, while all other disks are s=
till
running. After the spare disk was successfully prepared, the disk to re=
place
may be disabled.

This sounds a bit like RAID6, but it is much simpler. The complicated p=
art
may be the phase where I have one additional disk. A simple solution wo=
uld
be to perform a resync offline, while no write takes place. This may ev=
en be
performed by a userland utility. If I want to perform the "presync" onl=
ine,
I have to carry out writes to both disks simultaneously, while the pres=
ync
takes place.

Dieter.
--=20
Dieter St=FCken, con terra GmbH, M=FCnster
     stueken@conterra.de
     http://www.conterra.de/
     (0)251-7474-501
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
