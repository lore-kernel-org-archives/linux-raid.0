From: Titus Winters <twinters@odin.ac.hmc.edu>
Subject: Re: Not-fresh + failure
Date: Wed, 19 Jun 2002 09:24:35 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020619092435.A6189@cs.hmc.edu>
References: <20020618162813.A2366@cs.hmc.edu> <20020618233748.GA13086@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020618233748.GA13086@unthought.net>; from jakob@unthought.net on Wed, Jun 19, 2002 at 01:37:48AM +0200
To: Jakob Oestergaard <jakob@unthought.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My apologies for asking a question that was in the FAQ.  I thought the
not-fresh attribute was perhaps recoverable with something less scary
than mkraid --force.  Turns out this was the correct solution, and
my data is recovered, safe and sound.  Thank you very much.

-Titus

On (06/19 01:37), Jakob Oestergaard wrote:
> On Tue, Jun 18, 2002 at 04:28:13PM -0700, Titus Winters wrote:
> > Please help my poor file server:=20
> >=20
> > I've got 4 scsi drives on two controllers running RAID-5 in softwar=
e.
> >=20
> > So as near as I can tell I've got one drive that failed and cut off=
=20
> > communications with the other disk on the SCSI controller (or somet=
hing)
> > which made that second drive become not-fresh before the kernel pan=
icked.
> >=20
> > dmseg says that one is not-fresh, and the other is faulty.  How do =
I
> > proceed without data loss?  I've tried raidhotadd to bring up the=20
> > not-fresh drive, but the raid device can't start up and thus I can'=
t=20
> > hot add it. =20
>=20
> Section 6.1 in the Software RAID HOWTO:
>=20
> http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO-6.html#s=
s6.1
>=20
> --=20
> ................................................................
> :   jakob@unthought.net   : And I see the elder races,         :
> :.........................: putrid forms of man                :
> :   Jakob =D8stergaard      : See him rise and claim the earth,  :
> :        OZ9ABN           : his downfall is at hand.           :
> :.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
