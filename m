From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: switching from harware to kernel raid5
Date: Thu, 2 May 2002 18:12:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020502181215.P31556@unthought.net>
References: <20020429072215.GA26049@apartia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020429072215.GA26049@apartia.org>; from vindex@apartia.org on Mon, Apr 29, 2002 at 09:22:15AM +0200
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 29, 2002 at 09:22:15AM +0200, Louis-David Mitterrand wrote:
>=20
> Hello,
>=20
> On one of our servers I upgraded the 3x4.2G disks to 3x18G and remove=
d
> the Mylex Acceleraid 160 in favor of pure kernel (2.4.18) root raid5
> (reiserfs) with a small raid1 (ext2) boot partition.
>=20
> The reasons I did this:
>=20
> - latest kernel's stability,
> - raid code time tested,
> - simpler hardware configuration,
> - transferability of the disks to a non Mylex-equiped box,
> - better performance?
>=20
> Is there any downside going from hardware to kernel raid5? It seems t=
o
> work very well.=20

The only downside that I can think of, is that noone has written driver=
s for
the typical hot-plug backplanes yet.  Therefore, you will not have a pr=
etty LED
blinking to tell you which disk to replace.

=46or many people this is not really much of a problem.  But at some si=
tes it is
- you cannot let the "server monkey" replace disks if there is no clear
  idiot-proof indication of which disk to replace.  At sites where the
competent administrator may be in a whole other building, this can be a
problem.

Actually, I'd love to see the pretty LEDs flashing when a disk dies too=
=2E It is
not a necessity for me, but it would be a convenience.

(mostly because I want the LEDs to do Night-Rider style flashing when t=
he array
 is running normally  - weehee ! ;)

>=20
> I even had to switch off the machine during testing because a loose P=
CI
> card hung it: upong reboot the raid5 partition resynced itself fine. =
Was
> I just lucky?

I suppose you were lucky you didn't toast your hardware.  :)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
