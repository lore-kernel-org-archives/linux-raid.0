From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: RAID1, backup & BCV
Date: Wed, 19 Jun 2002 14:50:23 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020619125023.GB13519@unthought.net>
References: <D3BC284A3EACD5119CDF0002A53F8B971FFC2B@blmsrocopc02.bausch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D3BC284A3EACD5119CDF0002A53F8B971FFC2B@blmsrocopc02.bausch.com>
To: "Buechler, Mark R" <Mark_R_Buechler@bausch.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jun 19, 2002 at 08:39:59AM -0400, Buechler, Mark R wrote:
> I was wondering if Linux RAID had anything like what EMC corporation =
calls a
> BCV (Business Continuity Volume). A BCV is simply a second or third m=
irror
> which is synced up with the main devices and then broken off and kept=
 as a
> backup. You can then at any point restore from the BCV mirror by doin=
g a
> reverse sync from it to the main devices. This is a very handy thing =
when it
> comes to shared disk. You can sync a mirror on one system, break it a=
nd
> mount it up on another to back it up and all without having to stop a=
ny
> applications on the primary server or put any excessive load on it.
>=20
> I was wondering if there were plans for this sort of functionality or=
 if
> anyone has given it any thought.
>=20

It is supported. You can do this, as far as I see it, with raidhotadd,
mkraid and raidhotremove/raidsetfaulty.

We don't have the buzzword, and there's no nifty front-end for it, but
the functionality is all there as far as I see.

> - Mark.
>=20
>=20
> EMAIL DISCLAIMER=20
>=20
> Please Note: The information contained in this message may be privile=
ged and
> confidential, protected from disclosure, and/or intended only for the=
 use of
> the individual or entity named above. If the reader of this message i=
s not
> the intended recipient, or an employee or agent responsible for deliv=
ering
> this message to the intended recipient, you are hereby notified that =
any
> disclosure, distribution, copying or other dissemination of this
> communication is strictly prohibited. If you received this communicat=
ion in
> error, please immediately reply to the sender, delete the message and
> destroy all copies of it.
>=20

Wow  ;)

> Thank You
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

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
