From: Phil Turmel <philip@turmel.org>
Subject: Re: Do I have a bad HDD?
Date: Sun, 31 Jul 2011 19:42:42 -0400
Message-ID: <4E35E872.2000704@turmel.org>
References: <CADNH=7HDCwtUr-HSN7fH_GSH8jTYb-SAwmKY0ZRn3opWAhKiBQ@mail.gmail.com> <CADNH=7EJ7tvw2DEsAbeuxxRO1k961RSV4axgvfRUBaKG+Q455Q@mail.gmail.com> <CADNH=7EHAyk7Z7Wa72XO=p1od6AQP5aew_W5DffgLfZeCu=d-g@mail.gmail.com> <CADNH=7F3CVZ6r56jFrSHoVyzOZTHCfXPE_j-Rn8powbB6BLBYQ@mail.gmail.com> <4E359E26.2080500@truschnigg.info> <CADNH=7FmDpRhYbXGMJ=h17x=7hKL-=Wpoydnca=VAkLGqCfSFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7FmDpRhYbXGMJ=h17x=7hKL-=Wpoydnca=VAkLGqCfSFQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Johannes Truschnigg <johannes@truschnigg.info>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good evening Mathias,

On 07/31/2011 02:31 PM, Mathias Bur=C3=A9n wrote:

[trim]

> No I don't have a backup ;), perhaps it's time to get one. This isn't
> super important data, more like "nice to have".
>=20
> I don't have any hotplug bays or anything like that (you'll see in a
> while after I put up the pictures) so I shut down the system to take
> the faulty HDD out.
>=20
> Is it wise to run a check on the array while it's degraded by 1 HDD?

It shouldn't hurt your array, other than a bit of exercise.  If another
drive is marginal, it could conceivably "push it over the edge".

Any positive value it has will occur anyways during the resync with the
replacement drive for sdh.

I wouldn't bother running the scrub until the resync is finished.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
