From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Can't boot from /dev/md0 (RAID-1)
Date: Mon, 1 Jul 2002 13:21:11 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020701112111.GB18580@unthought.net>
References: <200206302046.g5UKkgpS006815@ns2.is.bizsystems.com> <200207011207.07552.roy@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200207011207.07552.roy@karlsbakk.net>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: michael@insulin-pumpers.org, Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 01, 2002 at 12:07:07PM +0200, Roy Sigurd Karlsbakk wrote:
=2E..
>=20
> I've read the fscking manual - all I can find - for both grub and lil=
o, and=20
> I've tried all possible configurations I can think of.
>=20
> point is - I beleive there's a BIOS/linux misunderstanding somewhere

Did you try the   raid-extra-boot  option for LILO ?  I really don't
know if this is the problem you are seeing, but it's worth a shot I
think.

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
