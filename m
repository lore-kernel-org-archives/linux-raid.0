From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Tue, 22 Oct 2002 12:45:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021022104522.GC24075@unthought.net>
References: <02Oct22.043816edt.62658@gpu.utcc.utoronto.ca> <Pine.LNX.4.44.0210221154500.26127-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0210221154500.26127-100000@ddx.a2000.nu>
To: raid@ddx.a2000.nu
Cc: Chris Siebenmann <cks@utcc.utoronto.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 22, 2002 at 11:58:56AM +0200, raid@ddx.a2000.nu wrote:
> On Tue, 22 Oct 2002, Chris Siebenmann wrote:
> >  At a guess: when RAID-5 is intact, the kernel must read the entire
> > stripe size worth of data to verify the parity. When a RAID-5 array=
 has
> > a dead disk, any intact data block can be handed to the application
> > the moment it comes off the disk as there is no point in doing pari=
ty
> > verification. (The kernel has to reconstruct the missing blocks, bu=
t
> > most of the blocks are present and good.)
>=20
> i thought raid5 was doing parity calculation when writing ?

Correct. RAID-5 will not do parity calculation when reading. RAID-5 wil=
l
give you availability but it will not give you integrity.

> difference between rading from failed an intact raid5 is almost twice=
 the
> speed (failed is doing 150MB/sec, intact is doing 80MB/sec)

I didn't follow the beginning of this thread, sorry.  Is this SCSI?

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
