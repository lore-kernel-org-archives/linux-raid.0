From: Jure Pecar <pegasus@telemach.net>
Subject: Re: ServerWorks chipset
Date: Mon, 26 Aug 2002 15:10:34 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020826151034.4e04e5d0.pegasus@telemach.net>
References: <Pine.LNX.4.30.0208261440170.10850-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 boundary="=.Ui?PfpYs/Dm6c)"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.30.0208261440170.10850-100000@duplo.agenda.si>
To: Danilo Godec <danci@agenda.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=.Ui?PfpYs/Dm6c)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Aug 2002 14:45:27 +0200 (CEST)
Danilo Godec <danci@agenda.si> wrote:

> Hi!
> 
> I'm using several Intel server boards with ServerWorks CSB5 chipset for
> IDE. Even though this chipset is supposed to support ATA100 and it is
> supposed to be supported in Linux and I do have CONFIG_BLK_DEV_SVWKS=y in
> my .config, I can't set speeds higher than 'hdparm -X66 /dev/hda'!
> 

ServerWorks ide is known for its DMA brokeness. See
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0208.2/1137.html
for reference.

Personally i dont care much about ide on intel's server boards ... use scsi
instead.

--


Jure Pecar

--=.Ui?PfpYs/Dm6c)
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)

iD8DBQE9aijMOHUMrcOSg+8RAoUMAJwMnljQ1OHYQa+Y016l7an27biUugCfYgDQ
fnesLPI8uG7netYpgyOykgQ=
=v85j
-----END PGP SIGNATURE-----

--=.Ui?PfpYs/Dm6c)--

