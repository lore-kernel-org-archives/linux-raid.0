From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: URGENT lilo problems
Date: Wed, 24 Apr 2002 11:52:34 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020424115234.A30278@unthought.net>
References: <20020424090459Z310953-22651+15685@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020424090459Z310953-22651+15685@vger.kernel.org>; from iain@minihub.org on Wed, Apr 24, 2002 at 06:56:59PM +1000
To: Iain <iain@minihub.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 24, 2002 at 06:56:59PM +1000, Iain wrote:
> Hi,
>=20
> I am trying to setup a bootable raid1 system.
>=20
> When I run lilo I get the following error:
>=20
> Fatal: map file must be on the boot RAID partition
>=20
> The map file is in /boot which is on /dev/md0 the partition I want to=
 boot=20
> from.

Can you send  /proc/mdstat and /etc/lilo.conf ?

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
