From: Neil Brown <neilb@suse.de>
Subject: Re: 'Array state: ... 1 failed', but array clean?
Date: Fri, 29 Jan 2010 20:44:18 +1100
Message-ID: <20100129204418.79734e4a@notabene>
References: <1264680565.1928.20.camel@test.apertos.eu>
	<1264683579.1928.23.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264683579.1928.23.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgg==?= Sawicz <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 28 Jan 2010 13:59:39 +0100
Micha=C5=82 Sawicz <michal@sawicz.net> wrote:

> Dnia 2010-01-28, czw o godzinie 13:09 +0100, Micha=C5=82 Sawicz pisze=
:
> > Where does this 'failed' come from? Oh, and it's like that on all
> > members. Is my array safe as /proc/mdstat says?=20
>=20
> Hmm I think it might be related to this:
>=20
> > # mdadm -E /dev/sdb1
> > [...]
> >     Array Slot : 6 (0, failed, 2, 3, 1, 5, 4)
> >    Array State : uuuuUu 1 failed
>=20
> One of the disks in this array was swapped, maybe this is what this i=
nfo
> records? How can I get rid of that?
>=20

The device that was the second device added to the array failed (or
disappeared), and this fact is recorded in case that device ever reappe=
ars...

Yes, this is confusing.  mdadm-3.x report the array state differently.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
