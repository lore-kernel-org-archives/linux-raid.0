From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Tue, 22 Oct 2002 13:24:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021022112401.GA26549@unthought.net>
References: <20021022104522.GC24075@unthought.net> <Pine.LNX.4.44.0210221248540.26127-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0210221248540.26127-100000@ddx.a2000.nu>
To: raid@ddx.a2000.nu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 22, 2002 at 12:49:41PM +0200, raid@ddx.a2000.nu wrote:
>=20
> On Tue, 22 Oct 2002, Jakob Oestergaard wrote:
>=20
> > I didn't follow the beginning of this thread, sorry.  Is this SCSI?
>=20
> Ide disks on 3ware 7850 using software raid5

Ok.  Odd.

My first guess would be that it's some master/slave IDE issue - but you
are probably running all your disks as masters (one disk per channel),
right?

Other than that... Well, if the parity information is intact, the disks
would need to skip the parity blocks when the array is read from
sequentially.  With a degraded array, the reads are all contiguous on
the disks - this could be a difference perhaps??  =20

What chunk size are you using?  And can you try a chunk size that is an
order of magnitude bigger or smaller?   (might take some time to test
this out).

=46or example, if you use a 4k chunksize (I don't think you do, if my l=
ast
guess holds), then try 128k.  If you are using 64k or above (which,
again, if I am guessing correctly, is probably more like what you're
using), then try 4k.

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
