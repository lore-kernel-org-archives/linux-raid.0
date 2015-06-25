From: Jared Mauch <jared@puck.nether.net>
Subject: Re: (R) in mdstat output, clean && degraded
Date: Thu, 25 Jun 2015 07:47:25 -0400
Message-ID: <A950552E-3B87-4663-AF54-0D711FBB8846@puck.nether.net>
References: <51364598-D6AA-43E7-B9A1-C3C09255D3D4@puck.nether.net> <20150625085201.4b2c6995@noble>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150625085201.4b2c6995@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Jun 24, 2015, at 6:52 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> You should be able to turn this into a fully functional RAID1 array b=
y:
>=20
> mdadm /dev/md127 --fail /dev/sdd1=20
> mdadm /dev/md127 --remove /dev/sdd1
> mdadm /dev/md127 --re-add /dev/sdd1
>=20
> When you fail sdd1, sdg1 will change from being a 'replacement' to be=
ing
> a regular member.
> When you --re-add /dev/sdd1 you benefit from the fact that raid1
> doesn't really care which device is in which slot (unlike raid5).
> So re-adding something marked for slot 0 into slot 1 is perfectly
> acceptable.
> As the bitmap is present and uptodate, the recovery will be very fast=
=2E
>=20
> I would recommend doing some basic checks for data consistency after
> removing sdd1 and before re-adding it.  I might be wrong about
> something and sdg1 might contain complete garbage - it never hurts to
> check :-)

So this actually doesn=E2=80=99t work:

# mdadm /dev/md127 --fail /dev/sdd1
mdadm: set device faulty failed for /dev/sdd1:  Device or resource busy
# mdadm /dev/md127 --fail /dev/sdg1
mdadm: set device faulty failed for /dev/sdg1:  Device or resource busy

so I may have to physically remove sdd1 to recover this it seems, or st=
op
and reassemble is my guess.

- Jared

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
