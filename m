From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Not-fresh + failure
Date: Wed, 19 Jun 2002 01:37:48 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020618233748.GA13086@unthought.net>
References: <20020618162813.A2366@cs.hmc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020618162813.A2366@cs.hmc.edu>
To: Titus Winters <twinters@odin.ac.hmc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 18, 2002 at 04:28:13PM -0700, Titus Winters wrote:
> Please help my poor file server:=20
>=20
> I've got 4 scsi drives on two controllers running RAID-5 in software.
>=20
> So as near as I can tell I've got one drive that failed and cut off=20
> communications with the other disk on the SCSI controller (or somethi=
ng)
> which made that second drive become not-fresh before the kernel panic=
ked.
>=20
> dmseg says that one is not-fresh, and the other is faulty.  How do I
> proceed without data loss?  I've tried raidhotadd to bring up the=20
> not-fresh drive, but the raid device can't start up and thus I can't=20
> hot add it. =20

Section 6.1 in the Software RAID HOWTO:

http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO-6.html#ss6=
=2E1

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
