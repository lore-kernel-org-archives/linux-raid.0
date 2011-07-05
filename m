From: NeilBrown <neilb@suse.de>
Subject: Re: Curious problem with asynchronous RAID1 rebuild operations
Date: Tue, 5 Jul 2011 10:34:04 +1000
Message-ID: <20110705103404.0ed0e9bb@notabene.brown>
References: <CALvtuFQ_c_-8DqKGaTV6LjL0JXC=8VKPKyx5U1Be49fepLcWzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALvtuFQ_c_-8DqKGaTV6LjL0JXC=8VKPKyx5U1Be49fepLcWzg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Cal Leeming [Simplicity Media Ltd]" <cal.leeming@simplicitymedialtd.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2 Jul 2011 12:07:54 +0100 "Cal Leeming [Simplicity Media Ltd]"
<cal.leeming@simplicitymedialtd.co.uk> wrote:

> Hi all,
>=20
> I tried to rebuild/sync two RAID1 arrays at the same time, with stran=
ge results.
>=20
> When a new drive was added into md0, it started to sync fine at
> 123,000kb/sec. Whilst that was running, I also added a new drive into
> md1, and this causes both arrays sync speed to slow down to
> 20,000kb/sec. I checked the=A0/proc/sys/dev/raid/speed_limit_{min|max=
}
> and these were both set fine.
>=20
> I removed the drive from md1, and the md0 sync went back to the norma=
l speed.
>=20
> RAID Setup:
> md0 - 2 drives (2TB Western Digital)
> md1 - 2 drives (500GB M3 SDD)
>=20
> So my question is, does anyone know why the sync speed (on all arrays=
)
> slowed down to almost 6-7 times the norm, when two (or more?) sync
> operations are taking place?
>=20

Dodgy controller?  I assume both arrays are on the same controller.

Can you plug in a separate controller even if only temporarily and see =
what
happens?

I can see how any interaction with md would have this effect.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
