From: Raz <raziebe@gmail.com>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over all
	strip_zones.
Date: Sat, 16 May 2009 00:19:01 +0300
Message-ID: <5d96567b0905151419m1744a8a0td1f59641ea2775e6@mail.gmail.com>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	<1242297833-13908-2-git-send-email-maan@systemlinux.org> <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
	<18956.3337.786085.284689@notabene.brown> <1242316280.11444.4.camel@raz>
	<20090515173040.GN6403@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090515173040.GN6403@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have not patched yet my code with this new serie, but where is patch
1/6 ? Does it exist or simply wrong numbering ?


On Fri, May 15, 2009 at 8:30 PM, Andre Noll <maan@systemlinux.org> wrot=
e:
> On 18:51, raz ben yehuda wrote:
>
>> > and as we aren't using ->sectors in this loop any more, I think it
>> > can be discarded completely, just making struct strip_zone 20% sma=
ller
>> > and improving cache performance.
>> >
>> > What do you think?
>> hamm.. please do not do it now. I think i need it for the reshape
>> because I have to traverse each zone up to its end.
>
> Well, you can always get the zone size of zone #i by
>
> =A0 =A0 =A0 =A0z[i].zone_end - z[i - 1].zone_end
>
> (with z[-1].zone_end :=3D 0). Since reshape is a slow operation anywa=
y,
> the additional subtraction won't hurt, and we'd have the smaller
> cache footprint during normal operation. So I'd be inclined to kill
> ->sectors as well.
>
> Andre
> --
> The only person who always got his work done by Friday was Robinson C=
rusoe
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
>
> iD8DBQFKDabAWto1QDEAkw8RAoEmAKCqYyRinCYIuXWi4fhJSLKfj//2XgCfYTfp
> z0lX/gg5fAfGb8IM0XKOAl4=3D
> =3DShCN
> -----END PGP SIGNATURE-----
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
